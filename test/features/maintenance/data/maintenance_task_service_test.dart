import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/maintenance/data/maintenance_task_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late MaintenanceTaskService sut;

  setUp(() {
    api = MockApiService();
    sut = MaintenanceTaskService(api);
  });

  group('no aquarium selected', () {
    test('getAllTasks throws NoAquariumSelectedException', () {
      expect(sut.getAllTasks(), throwsA(isA<NoAquariumSelectedException>()));
    });

    test('initializeDefaultTasks throws NoAquariumSelectedException', () {
      expect(
        sut.initializeDefaultTasks(),
        throwsA(isA<NoAquariumSelectedException>()),
      );
    });
  });

  group('getAllTasks', () {
    test('returns [] for a data-wrapped empty list', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/tasks'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getAllTasks(), isEmpty);
    });

    test('returns [] for a bare empty array', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/tasks')).thenAnswer((_) async => []);

      expect(await sut.getAllTasks(), isEmpty);
    });

    test('returns [] for an unexpected response shape', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/tasks'))
          .thenAnswer((_) async => 'weird');

      expect(await sut.getAllTasks(), isEmpty);
    });

    test('rethrows on network error', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/tasks')).thenThrow(Exception('down'));

      expect(sut.getAllTasks(), throwsA(isA<Exception>()));
    });
  });

  group('status-filtered queries', () {
    test('getPendingTasks appends ?status=pending', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/tasks?status=pending'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getPendingTasks(), isEmpty);
      verify(() => api.get('/aquariums/1/tasks?status=pending')).called(1);
    });

    test('getCompletedTasks appends ?status=completed', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/tasks?status=completed'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getCompletedTasks(), isEmpty);
      verify(() => api.get('/aquariums/1/tasks?status=completed')).called(1);
    });
  });

  group('getTaskStatistics', () {
    test('returns all-zero counts for an empty task list', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/tasks'))
          .thenAnswer((_) async => {'data': []});

      final stats = await sut.getTaskStatistics();

      expect(stats['total'], 0);
      expect(stats['pending'], 0);
      expect(stats['overdue'], 0);
      expect(stats['dueToday'], 0);
      expect(stats['disabled'], 0);
    });
  });
}
