import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/settings/data/notification_settings_service.dart';
import 'package:acquariumfe/features/settings/domain/models/notification_settings.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late NotificationSettingsService sut;

  setUpAll(() {
    // saveSettings posts settings.toJson() matched with any().
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    api = MockApiService();
    sut = NotificationSettingsService(api);
  });

  group('loadSettings', () {
    test('returns default settings on a non-data response', () async {
      when(() => api.get('/aquariums/1/settings/notifications'))
          .thenAnswer((_) async => {});

      final result = await sut.loadSettings(1);

      expect(result, isA<NotificationSettings>());
    });

    test('returns default settings on network error', () async {
      when(() => api.get('/aquariums/1/settings/notifications'))
          .thenThrow(Exception('down'));

      final result = await sut.loadSettings(1);

      expect(result, isA<NotificationSettings>());
    });
  });

  group('saveSettings', () {
    test('posts to the notifications endpoint and caches the result',
        () async {
      final settings = NotificationSettings();
      when(() => api.post('/aquariums/1/settings/notifications', any()))
          .thenAnswer((_) async => {'ok': true});

      await sut.saveSettings(1, settings);

      verify(() => api.post('/aquariums/1/settings/notifications', any()))
          .called(1);

      // Cached → the next load does not hit the network.
      final loaded = await sut.loadSettings(1);
      expect(loaded, same(settings));
      verifyNever(() => api.get(any()));
    });

    test('caches each aquarium independently', () async {
      final s1 = NotificationSettings();
      final s2 = NotificationSettings();
      when(() => api.post(any(), any())).thenAnswer((_) async => {'ok': true});

      await sut.saveSettings(1, s1);
      await sut.saveSettings(2, s2);

      expect(await sut.loadSettings(1), same(s1));
      expect(await sut.loadSettings(2), same(s2));
      verifyNever(() => api.get(any()));
    });
  });

  group('resetToDefaults', () {
    test('deletes the settings and drops the cached entry', () async {
      final settings = NotificationSettings();
      when(() => api.post('/aquariums/1/settings/notifications', any()))
          .thenAnswer((_) async => {'ok': true});
      await sut.saveSettings(1, settings); // populate the cache

      when(() => api.delete('/aquariums/1/settings/notifications'))
          .thenAnswer((_) async => {'ok': true});
      await sut.resetToDefaults(1);

      verify(() => api.delete('/aquariums/1/settings/notifications')).called(1);

      // Cache dropped → the next load hits the network again.
      when(() => api.get('/aquariums/1/settings/notifications'))
          .thenAnswer((_) async => {});
      await sut.loadSettings(1);
      verify(() => api.get('/aquariums/1/settings/notifications')).called(1);
    });
  });
}
