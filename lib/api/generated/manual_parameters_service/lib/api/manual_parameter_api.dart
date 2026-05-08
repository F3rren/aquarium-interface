//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ManualParameterApi {
  ManualParameterApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add a new manual parameter
  ///
  /// Add a new manual parameter for a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  ///
  /// * [CreateManualParameterDTO] createManualParameterDTO (required):
  Future<Response> addManualParameterWithHttpInfo(int aquariumId, CreateManualParameterDTO createManualParameterDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{aquariumId}/parameters/manual'
      .replaceAll('{aquariumId}', aquariumId.toString());

    // ignore: prefer_final_locals
    Object? postBody = createManualParameterDTO;

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

  /// Add a new manual parameter
  ///
  /// Add a new manual parameter for a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  ///
  /// * [CreateManualParameterDTO] createManualParameterDTO (required):
  Future<ApiResponseDTOManualParameterDTO?> addManualParameter(int aquariumId, CreateManualParameterDTO createManualParameterDTO,) async {
    final response = await addManualParameterWithHttpInfo(aquariumId, createManualParameterDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOManualParameterDTO',) as ApiResponseDTOManualParameterDTO;
    
    }
    return null;
  }

  /// Get latest manual parameter
  ///
  /// Retrieve the most recent manual parameter
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  Future<Response> getLatestManualParameterWithHttpInfo(int aquariumId,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{aquariumId}/parameters/manual'
      .replaceAll('{aquariumId}', aquariumId.toString());

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

  /// Get latest manual parameter
  ///
  /// Retrieve the most recent manual parameter
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  Future<ApiResponseDTOManualParameterDTO?> getLatestManualParameter(int aquariumId,) async {
    final response = await getLatestManualParameterWithHttpInfo(aquariumId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOManualParameterDTO',) as ApiResponseDTOManualParameterDTO;
    
    }
    return null;
  }

  /// Get manual parameters history
  ///
  /// Retrieve manual parameters within a date range
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  ///
  /// * [String] from:
  ///
  /// * [String] to:
  Future<Response> getManualParametersHistoryWithHttpInfo(int aquariumId, { String? from, String? to, }) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{aquariumId}/parameters/manual/history'
      .replaceAll('{aquariumId}', aquariumId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

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

  /// Get manual parameters history
  ///
  /// Retrieve manual parameters within a date range
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  ///
  /// * [String] from:
  ///
  /// * [String] to:
  Future<ApiResponseDTOListManualParameterDTO?> getManualParametersHistory(int aquariumId, { String? from, String? to, }) async {
    final response = await getManualParametersHistoryWithHttpInfo(aquariumId,  from: from, to: to, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListManualParameterDTO',) as ApiResponseDTOListManualParameterDTO;
    
    }
    return null;
  }
}
