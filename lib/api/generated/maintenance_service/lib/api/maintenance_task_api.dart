//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class MaintenanceTaskApi {
  MaintenanceTaskApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Mark a task as completed
  ///
  /// Mark a specific task as completed
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] taskId (required):
  Future<Response> completeTaskWithHttpInfo(int id, int taskId,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/tasks/{taskId}/complete'
      .replaceAll('{id}', id.toString())
      .replaceAll('{taskId}', taskId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Mark a task as completed
  ///
  /// Mark a specific task as completed
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] taskId (required):
  Future<ApiResponseDTOMaintenanceTaskDTO?> completeTask(int id, int taskId,) async {
    final response = await completeTaskWithHttpInfo(id, taskId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOMaintenanceTaskDTO',) as ApiResponseDTOMaintenanceTaskDTO;
    
    }
    return null;
  }

  /// Create a new maintenance task
  ///
  /// Create a new task for a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [CreateMaintenanceTaskDTO] createMaintenanceTaskDTO (required):
  Future<Response> createTaskWithHttpInfo(int id, CreateMaintenanceTaskDTO createMaintenanceTaskDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/tasks'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = createMaintenanceTaskDTO;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a new maintenance task
  ///
  /// Create a new task for a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [CreateMaintenanceTaskDTO] createMaintenanceTaskDTO (required):
  Future<ApiResponseDTOMaintenanceTaskDTO?> createTask(int id, CreateMaintenanceTaskDTO createMaintenanceTaskDTO,) async {
    final response = await createTaskWithHttpInfo(id, createMaintenanceTaskDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOMaintenanceTaskDTO',) as ApiResponseDTOMaintenanceTaskDTO;
    
    }
    return null;
  }

  /// Delete a maintenance task
  ///
  /// Delete a specific task
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] taskId (required):
  Future<Response> deleteTaskWithHttpInfo(int id, int taskId,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/tasks/{taskId}'
      .replaceAll('{id}', id.toString())
      .replaceAll('{taskId}', taskId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete a maintenance task
  ///
  /// Delete a specific task
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] taskId (required):
  Future<void> deleteTask(int id, int taskId,) async {
    final response = await deleteTaskWithHttpInfo(id, taskId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get all maintenance tasks for an aquarium
  ///
  /// Retrieve tasks, optionally filtered by status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [String] status:
  Future<Response> getAllTasksWithHttpInfo(int id, { String? status, }) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/tasks'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get all maintenance tasks for an aquarium
  ///
  /// Retrieve tasks, optionally filtered by status
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [String] status:
  Future<ApiResponseDTOListMaintenanceTaskDTO?> getAllTasks(int id, { String? status, }) async {
    final response = await getAllTasksWithHttpInfo(id,  status: status, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListMaintenanceTaskDTO',) as ApiResponseDTOListMaintenanceTaskDTO;
    
    }
    return null;
  }

  /// Update a maintenance task
  ///
  /// Update details of a specific task
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] taskId (required):
  ///
  /// * [UpdateMaintenanceTaskDTO] updateMaintenanceTaskDTO (required):
  Future<Response> updateTaskWithHttpInfo(int id, int taskId, UpdateMaintenanceTaskDTO updateMaintenanceTaskDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/tasks/{taskId}'
      .replaceAll('{id}', id.toString())
      .replaceAll('{taskId}', taskId.toString());

    // ignore: prefer_final_locals
    Object? postBody = updateMaintenanceTaskDTO;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update a maintenance task
  ///
  /// Update details of a specific task
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] taskId (required):
  ///
  /// * [UpdateMaintenanceTaskDTO] updateMaintenanceTaskDTO (required):
  Future<ApiResponseDTOMaintenanceTaskDTO?> updateTask(int id, int taskId, UpdateMaintenanceTaskDTO updateMaintenanceTaskDTO,) async {
    final response = await updateTaskWithHttpInfo(id, taskId, updateMaintenanceTaskDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOMaintenanceTaskDTO',) as ApiResponseDTOMaintenanceTaskDTO;
    
    }
    return null;
  }
}
