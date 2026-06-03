/// Central mock definitions for all tests.
///
/// Import this file in any test that needs to mock a service.
/// Using mocktail: no code generation required.
library;

import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/core/network/api_service.dart';
import 'package:acquariumfe/features/aquarium/data/aquarium_service.dart';
import 'package:acquariumfe/features/parameters/data/parameter_service.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import 'package:acquariumfe/features/maintenance/data/maintenance_task_service.dart';
import 'package:acquariumfe/features/parameters/data/manual_parameters_service.dart';

// ── Service mocks ─────────────────────────────────────────────────────────────

class MockApiService extends Mock implements ApiService {}

class MockAquariumsService extends Mock implements AquariumsService {}

class MockParameterService extends Mock implements ParameterService {}

class MockTargetParametersService extends Mock
    implements TargetParametersService {}

class MockMaintenanceTaskService extends Mock
    implements MaintenanceTaskService {}

class MockManualParametersService extends Mock
    implements ManualParametersService {}
