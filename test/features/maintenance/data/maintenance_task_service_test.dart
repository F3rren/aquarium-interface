import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/maintenance/data/maintenance_task_service.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late MaintenanceTaskService sut;

  setUp(() {
    api = MockApiService();
    sut = MaintenanceTaskService(api);
  });

  group('getAllTasks', () {
    test('returns [] for a data-wrapped empty list', () async {
      when(() => api.get('/aquariums/1/tasks'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getAllTasks(1), isEmpty);
    });

    test('returns [] for a bare empty array', () async {
      when(() => api.get('/aquariums/1/tasks')).thenAnswer((_) async => []);

      expect(await sut.getAllTasks(1), isEmpty);
    });

    test('returns [] for an unexpected response shape', () async {
      when(() => api.get('/aquariums/1/tasks'))
          .thenAnswer((_) async => 'weird');

      expect(await sut.getAllTasks(1), isEmpty);
    });

    test('rethrows on network error', () async {
      when(() => api.get('/aquariums/1/tasks')).thenThrow(Exception('down'));

      expect(sut.getAllTasks(1), throwsA(isA<Exception>()));
    });

    test('targets the tasks endpoint of the given aquarium', () async {
      when(() => api.get('/aquariums/9/tasks'))
          .thenAnswer((_) async => {'data': []});

      await sut.getAllTasks(9);

      verify(() => api.get('/aquariums/9/tasks')).called(1);
    });
  });

  group('status-filtered queries', () {
    test('getPendingTasks appends ?status=pending', () async {
      when(() => api.get('/aquariums/1/tasks?status=pending'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getPendingTasks(1), isEmpty);
      verify(() => api.get('/aquariums/1/tasks?status=pending')).called(1);
    });

    test('getCompletedTasks appends ?status=completed', () async {
      when(() => api.get('/aquariums/1/tasks?status=completed'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getCompletedTasks(1), isEmpty);
      verify(() => api.get('/aquariums/1/tasks?status=completed')).called(1);
    });
  });

  group('getTaskStatistics', () {
    test('returns all-zero counts for an empty task list', () async {
      when(() => api.get('/aquariums/1/tasks'))
          .thenAnswer((_) async => {'data': []});

      final stats = await sut.getTaskStatistics(1);

      expect(stats['total'], 0);
      expect(stats['pending'], 0);
      expect(stats['overdue'], 0);
      expect(stats['dueToday'], 0);
      expect(stats['disabled'], 0);
    });
  });
}
