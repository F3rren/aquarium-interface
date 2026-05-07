//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AquariumApi {
  AquariumApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add manual parameter
  ///
  /// Record a new manual parameter measurement for an aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [ManualParameterDTO] manualParameterDTO (required):
  Future<Response> addManualParameterWithHttpInfo(int id, ManualParameterDTO manualParameterDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/manual-parameters'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = manualParameterDTO;

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

  /// Add manual parameter
  ///
  /// Record a new manual parameter measurement for an aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [ManualParameterDTO] manualParameterDTO (required):
  Future<ApiResponseDTOManualParameterDTO?> addManualParameter(int id, ManualParameterDTO manualParameterDTO,) async {
    final response = await addManualParameterWithHttpInfo(id, manualParameterDTO,);
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

  /// Add water parameter
  ///
  /// Record a new water parameter measurement for an aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [WaterParameterDTO] waterParameterDTO (required):
  Future<Response> addWaterParameterWithHttpInfo(int id, WaterParameterDTO waterParameterDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/water-parameters'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = waterParameterDTO;

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

  /// Add water parameter
  ///
  /// Record a new water parameter measurement for an aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [WaterParameterDTO] waterParameterDTO (required):
  Future<ApiResponseDTOWaterParameterDTO?> addWaterParameter(int id, WaterParameterDTO waterParameterDTO,) async {
    final response = await addWaterParameterWithHttpInfo(id, waterParameterDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOWaterParameterDTO',) as ApiResponseDTOWaterParameterDTO;
    
    }
    return null;
  }

  /// Create a new aquarium
  ///
  /// Receive and save a new aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateAquariumDTO] createAquariumDTO (required):
  Future<Response> createAquariumWithHttpInfo(CreateAquariumDTO createAquariumDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums';

    // ignore: prefer_final_locals
    Object? postBody = createAquariumDTO;

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

  /// Create a new aquarium
  ///
  /// Receive and save a new aquarium
  ///
  /// Parameters:
  ///
  /// * [CreateAquariumDTO] createAquariumDTO (required):
  Future<ApiResponseDTOAquariumResponseDTO?> createAquarium(CreateAquariumDTO createAquariumDTO,) async {
    final response = await createAquariumWithHttpInfo(createAquariumDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOAquariumResponseDTO',) as ApiResponseDTOAquariumResponseDTO;
    
    }
    return null;
  }

  /// Delete an aquarium
  ///
  /// Remove a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> deleteAquariumWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}'
      .replaceAll('{id}', id.toString());

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

  /// Delete an aquarium
  ///
  /// Remove a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<void> deleteAquarium(int id,) async {
    final response = await deleteAquariumWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get all aquariums
  ///
  /// Retrieve paginated list of aquariums
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] page:
  ///   Zero-based page index (0..N)
  ///
  /// * [int] size:
  ///   The size of the page to be returned
  ///
  /// * [List<String>] sort:
  ///   Sorting criteria in the format: property,(asc|desc). Default sort order is ascending. Multiple sort criteria are supported.
  Future<Response> getAllAquariumsWithHttpInfo({ int? page, int? size, List<String>? sort, }) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (page != null) {
      queryParams.addAll(_queryParams('', 'page', page));
    }
    if (size != null) {
      queryParams.addAll(_queryParams('', 'size', size));
    }
    if (sort != null) {
      queryParams.addAll(_queryParams('multi', 'sort', sort));
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

  /// Get all aquariums
  ///
  /// Retrieve paginated list of aquariums
  ///
  /// Parameters:
  ///
  /// * [int] page:
  ///   Zero-based page index (0..N)
  ///
  /// * [int] size:
  ///   The size of the page to be returned
  ///
  /// * [List<String>] sort:
  ///   Sorting criteria in the format: property,(asc|desc). Default sort order is ascending. Multiple sort criteria are supported.
  Future<ApiResponseDTOListAquariumResponseDTO?> getAllAquariums({ int? page, int? size, List<String>? sort, }) async {
    final response = await getAllAquariumsWithHttpInfo( page: page, size: size, sort: sort, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListAquariumResponseDTO',) as ApiResponseDTOListAquariumResponseDTO;
    
    }
    return null;
  }

  /// Get aquarium by ID
  ///
  /// Retrieve details of a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getAquariumByIdWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}'
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

  /// Get aquarium by ID
  ///
  /// Retrieve details of a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOAquariumResponseDTO?> getAquariumById(int id,) async {
    final response = await getAquariumByIdWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOAquariumResponseDTO',) as ApiResponseDTOAquariumResponseDTO;
    
    }
    return null;
  }

  /// Get latest manual parameter
  ///
  /// Retrieve the most recent manual parameter measurement
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getLatestManualParameterWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/manual-parameters/latest'
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

  /// Get latest manual parameter
  ///
  /// Retrieve the most recent manual parameter measurement
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOManualParameterDTO?> getLatestManualParameter(int id,) async {
    final response = await getLatestManualParameterWithHttpInfo(id,);
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

  /// Get latest water parameter
  ///
  /// Retrieve the most recent water parameter measurement
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getLatestWaterParameterWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/water-parameters/latest'
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
  /// Retrieve the most recent water parameter measurement
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOWaterParameterDTO?> getLatestWaterParameter(int id,) async {
    final response = await getLatestWaterParameterWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOWaterParameterDTO',) as ApiResponseDTOWaterParameterDTO;
    
    }
    return null;
  }

  /// Get manual parameters
  ///
  /// Retrieve all manual parameter measurements for an aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getManualParametersWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/manual-parameters'
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

  /// Get manual parameters
  ///
  /// Retrieve all manual parameter measurements for an aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOListManualParameterDTO?> getManualParameters(int id,) async {
    final response = await getManualParametersWithHttpInfo(id,);
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

  /// Get manual parameters history
  ///
  /// Retrieve historical manual parameter data
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [String] from (required):
  ///
  /// * [String] to (required):
  Future<Response> getManualParametersHistoryWithHttpInfo(int id, String from, String to,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/manual-parameters/history'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'from', from));
      queryParams.addAll(_queryParams('', 'to', to));

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
  /// Retrieve historical manual parameter data
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [String] from (required):
  ///
  /// * [String] to (required):
  Future<ApiResponseDTOListManualParameterDTO?> getManualParametersHistory(int id, String from, String to,) async {
    final response = await getManualParametersHistoryWithHttpInfo(id, from, to,);
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

  /// Get target parameters
  ///
  /// Retrieve the target parameter values for an aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getTargetParametersWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/target-parameters'
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

  /// Get target parameters
  ///
  /// Retrieve the target parameter values for an aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOTargetParameterDTO?> getTargetParameters(int id,) async {
    final response = await getTargetParametersWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOTargetParameterDTO',) as ApiResponseDTOTargetParameterDTO;
    
    }
    return null;
  }

  /// Get water parameters
  ///
  /// Retrieve water parameter measurements for an aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] limit:
  Future<Response> getWaterParametersWithHttpInfo(int id, { int? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/water-parameters'
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
  /// Retrieve water parameter measurements for an aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [int] limit:
  Future<ApiResponseDTOListWaterParameterDTO?> getWaterParameters(int id, { int? limit, }) async {
    final response = await getWaterParametersWithHttpInfo(id,  limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListWaterParameterDTO',) as ApiResponseDTOListWaterParameterDTO;
    
    }
    return null;
  }

  /// Get water parameters history
  ///
  /// Retrieve historical water parameter data
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
  Future<Response> getWaterParametersHistoryWithHttpInfo(int id, { String? period, String? from, String? to, }) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/water-parameters/history'
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
  /// Retrieve historical water parameter data
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
  Future<ApiResponseDTOListWaterParameterDTO?> getWaterParametersHistory(int id, { String? period, String? from, String? to, }) async {
    final response = await getWaterParametersHistoryWithHttpInfo(id,  period: period, from: from, to: to, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListWaterParameterDTO',) as ApiResponseDTOListWaterParameterDTO;
    
    }
    return null;
  }

  /// Save target parameters
  ///
  /// Set target parameter values for an aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [TargetParameterDTO] targetParameterDTO (required):
  Future<Response> saveTargetParametersWithHttpInfo(int id, TargetParameterDTO targetParameterDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/target-parameters'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = targetParameterDTO;

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

  /// Save target parameters
  ///
  /// Set target parameter values for an aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [TargetParameterDTO] targetParameterDTO (required):
  Future<ApiResponseDTOTargetParameterDTO?> saveTargetParameters(int id, TargetParameterDTO targetParameterDTO,) async {
    final response = await saveTargetParametersWithHttpInfo(id, targetParameterDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOTargetParameterDTO',) as ApiResponseDTOTargetParameterDTO;
    
    }
    return null;
  }

  /// Update an existing aquarium
  ///
  /// Modify details of a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [UpdateAquariumDTO] updateAquariumDTO (required):
  Future<Response> updateAquariumWithHttpInfo(int id, UpdateAquariumDTO updateAquariumDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = updateAquariumDTO;

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

  /// Update an existing aquarium
  ///
  /// Modify details of a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [UpdateAquariumDTO] updateAquariumDTO (required):
  Future<ApiResponseDTOAquariumResponseDTO?> updateAquarium(int id, UpdateAquariumDTO updateAquariumDTO,) async {
    final response = await updateAquariumWithHttpInfo(id, updateAquariumDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOAquariumResponseDTO',) as ApiResponseDTOAquariumResponseDTO;
    
    }
    return null;
  }
}
