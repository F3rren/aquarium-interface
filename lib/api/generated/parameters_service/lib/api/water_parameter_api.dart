//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class WaterParameterApi {
  WaterParameterApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add a new water parameter
  ///
  /// Add a new water parameter for a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [CreateParameterDTO] createParameterDTO (required):
  Future<Response> addParameterWithHttpInfo(int id, CreateParameterDTO createParameterDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/parameters'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = createParameterDTO;

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

  /// Add a new water parameter
  ///
  /// Add a new water parameter for a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [CreateParameterDTO] createParameterDTO (required):
  Future<ApiResponseDTOParameterDTO?> addParameter(int id, CreateParameterDTO createParameterDTO,) async {
    final response = await addParameterWithHttpInfo(id, createParameterDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOParameterDTO',) as ApiResponseDTOParameterDTO;
    
    }
    return null;
  }

  /// Get latest water parameter
  ///
  /// Retrieve the most recent water parameter
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getLatestParameterWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/parameters/latest'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

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

  /// Get latest water parameter
  ///
  /// Retrieve the most recent water parameter
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOParameterDTO?> getLatestParameter(int id,) async {
    final response = await getLatestParameterWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOParameterDTO',) as ApiResponseDTOParameterDTO;
    
    }
    return null;
  }

  /// Get water parameters
  ///
  /// Retrieve water parameters for a specific aquarium with optional limit
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] limit:
  Future<Response> getParametersByAquariumWithHttpInfo(int id, { int? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/parameters'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
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

  /// Get water parameters
  ///
  /// Retrieve water parameters for a specific aquarium with optional limit
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] limit:
  Future<ApiResponseDTOListParameterDTO?> getParametersByAquarium(int id, { int? limit, }) async {
    final response = await getParametersByAquariumWithHttpInfo(id,  limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListParameterDTO',) as ApiResponseDTOListParameterDTO;
    
    }
    return null;
  }

  /// Get water parameters history
  ///
  /// Retrieve history based on period or date range
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [String] period:
  ///
  /// * [String] from:
  ///
  /// * [String] to:
  Future<Response> getParametersHistoryWithHttpInfo(int id, { String? period, String? from, String? to, }) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/parameters/history'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (from != null) {
      queryParams.addAll(_queryParams('', 'from', from));
    }
    if (to != null) {
      queryParams.addAll(_queryParams('', 'to', to));
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

  /// Get water parameters history
  ///
  /// Retrieve history based on period or date range
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [String] period:
  ///
  /// * [String] from:
  ///
  /// * [String] to:
  Future<ApiResponseDTOListParameterDTO?> getParametersHistory(int id, { String? period, String? from, String? to, }) async {
    final response = await getParametersHistoryWithHttpInfo(id,  period: period, from: from, to: to, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListParameterDTO',) as ApiResponseDTOListParameterDTO;
    
    }
    return null;
  }
}
