//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class SpeciesApi {
  SpeciesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get all corals
  ///
  /// Retrieve a list of all coral species
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getAllCoralsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/species/corals';

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

  /// Get all corals
  ///
  /// Retrieve a list of all coral species
  Future<ApiResponseDTOListCoralResponseDTO?> getAllCorals() async {
    final response = await getAllCoralsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListCoralResponseDTO',) as ApiResponseDTOListCoralResponseDTO;
    
    }
    return null;
  }

  /// Get all fish
  ///
  /// Retrieve a list of all fish species
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getAllFishWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/species/fish';

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

  /// Get all fish
  ///
  /// Retrieve a list of all fish species
  Future<ApiResponseDTOListFishResponseDTO?> getAllFish() async {
    final response = await getAllFishWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListFishResponseDTO',) as ApiResponseDTOListFishResponseDTO;
    
    }
    return null;
  }

  /// Get a coral by ID
  ///
  /// Retrieve details of a specific coral by its ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getCoralByIdWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/species/corals/{id}'
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

  /// Get a coral by ID
  ///
  /// Retrieve details of a specific coral by its ID
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOCoralResponseDTO?> getCoralById(int id,) async {
    final response = await getCoralByIdWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOCoralResponseDTO',) as ApiResponseDTOCoralResponseDTO;
    
    }
    return null;
  }

  /// Get a fish by ID
  ///
  /// Retrieve details of a specific fish by its ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getFishByIdWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/species/fish/{id}'
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

  /// Get a fish by ID
  ///
  /// Retrieve details of a specific fish by its ID
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOFishResponseDTO?> getFishById(int id,) async {
    final response = await getFishByIdWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOFishResponseDTO',) as ApiResponseDTOFishResponseDTO;
    
    }
    return null;
  }
}
