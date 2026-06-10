import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/settings/data/notification_settings_service.dart';
import 'package:acquariumfe/features/settings/domain/models/notification_settings.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
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
    test('returns default settings when no aquarium selected (no API call)',
        () async {
      final result = await sut.loadSettings();

      expect(result, isA<NotificationSettings>());
      verifyNever(() => api.get(any()));
    });

    test('returns default settings on network error', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/settings/notifications'))
          .thenThrow(Exception('down'));

      final result = await sut.loadSettings();

      expect(result, isA<NotificationSettings>());
    });
  });

  group('saveSettings', () {
    test('throws NoAquariumSelectedException when no aquarium selected', () {
      expect(
        sut.saveSettings(NotificationSettings()),
        throwsA(isA<NoAquariumSelectedException>()),
      );
    });

    test('posts to the notifications endpoint and caches the result',
        () async {
      sut.setCurrentAquarium(1);
      final settings = NotificationSettings();
      when(() => api.post('/aquariums/1/settings/notifications', any()))
          .thenAnswer((_) async => {'ok': true});

      await sut.saveSettings(settings);

      verify(() => api.post('/aquariums/1/settings/notifications', any()))
          .called(1);

      // The cache now holds the saved instance: the next load skips the network.
      final loaded = await sut.loadSettings();
      expect(loaded, same(settings));
      verifyNever(() => api.get(any()));
    });
  });

  group('cache invalidation', () {
    test('setCurrentAquarium clears the cached settings', () async {
      sut.setCurrentAquarium(1);
      final settings = NotificationSettings();
      when(() => api.post('/aquariums/1/settings/notifications', any()))
          .thenAnswer((_) async => {'ok': true});
      await sut.saveSettings(settings); // populates the cache

      sut.setCurrentAquarium(2); // different aquarium → cache must be dropped
      when(() => api.get('/aquariums/2/settings/notifications'))
          .thenThrow(Exception('down'));

      // A fresh load is attempted (it falls back to defaults on the error)
      // rather than returning the previously cached instance.
      final loaded = await sut.loadSettings();
      expect(loaded, isNot(same(settings)));
      verify(() => api.get('/aquariums/2/settings/notifications')).called(1);
    });
  });

  group('resetToDefaults', () {
    test('no-ops (no throw, no API call) when no aquarium selected', () async {
      await sut.resetToDefaults();
      verifyNever(() => api.delete(any()));
    });
  });
}
