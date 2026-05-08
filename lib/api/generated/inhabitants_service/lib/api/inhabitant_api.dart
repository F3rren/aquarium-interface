//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class InhabitantApi {
  InhabitantApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add an inhabitant to an aquarium
  ///
  /// Add a new inhabitant to a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [CreateInhabitantDTO] createInhabitantDTO (required):
  Future<Response> addInhabitantToAquariumWithHttpInfo(int id, CreateInhabitantDTO createInhabitantDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/inhabitants'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = createInhabitantDTO;

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

  /// Add an inhabitant to an aquarium
  ///
  /// Add a new inhabitant to a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [CreateInhabitantDTO] createInhabitantDTO (required):
  Future<ApiResponseDTOInhabitantDetailsDTO?> addInhabitantToAquarium(int id, CreateInhabitantDTO createInhabitantDTO,) async {
    final response = await addInhabitantToAquariumWithHttpInfo(id, createInhabitantDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOInhabitantDetailsDTO',) as ApiResponseDTOInhabitantDetailsDTO;
    
    }
    return null;
  }

  /// Get inhabitants by aquarium ID
  ///
  /// Retrieve details of inhabitants in a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getAquariumInhabitantsWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{id}/inhabitants'
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

  /// Get inhabitants by aquarium ID
  ///
  /// Retrieve details of inhabitants in a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOListInhabitantDetailsDTO?> getAquariumInhabitants(int id,) async {
    final response = await getAquariumInhabitantsWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListInhabitantDetailsDTO',) as ApiResponseDTOListInhabitantDetailsDTO;
    
    }
    return null;
  }

  /// Remove an inhabitant from an aquarium
  ///
  /// Remove an inhabitant from a specific aquarium
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  ///
  /// * [int] inhabitantId (required):
  Future<Response> removeInhabitantFromAquariumWithHttpInfo(int aquariumId, int inhabitantId,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{aquariumId}/inhabitants/{inhabitantId}'
      .replaceAll('{aquariumId}', aquariumId.toString())
      .replaceAll('{inhabitantId}', inhabitantId.toString());

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

  /// Remove an inhabitant from an aquarium
  ///
  /// Remove an inhabitant from a specific aquarium
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  ///
  /// * [int] inhabitantId (required):
  Future<void> removeInhabitantFromAquarium(int aquariumId, int inhabitantId,) async {
    final response = await removeInhabitantFromAquariumWithHttpInfo(aquariumId, inhabitantId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update an inhabitant
  ///
  /// Update quantity, notes, custom name, current size or other custom fields of an inhabitant
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  ///
  /// * [int] inhabitantId (required):
  ///
  /// * [UpdateInhabitantDTO] updateInhabitantDTO (required):
  Future<Response> updateInhabitantWithHttpInfo(int aquariumId, int inhabitantId, UpdateInhabitantDTO updateInhabitantDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/aquariums/{aquariumId}/inhabitants/{inhabitantId}'
      .replaceAll('{aquariumId}', aquariumId.toString())
      .replaceAll('{inhabitantId}', inhabitantId.toString());

    // ignore: prefer_final_locals
    Object? postBody = updateInhabitantDTO;

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

  /// Update an inhabitant
  ///
  /// Update quantity, notes, custom name, current size or other custom fields of an inhabitant
  ///
  /// Parameters:
  ///
  /// * [int] aquariumId (required):
  ///
  /// * [int] inhabitantId (required):
  ///
  /// * [UpdateInhabitantDTO] updateInhabitantDTO (required):
  Future<ApiResponseDTOInhabitantDetailsDTO?> updateInhabitant(int aquariumId, int inhabitantId, UpdateInhabitantDTO updateInhabitantDTO,) async {
    final response = await updateInhabitantWithHttpInfo(aquariumId, inhabitantId, updateInhabitantDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOInhabitantDetailsDTO',) as ApiResponseDTOInhabitantDetailsDTO;
    
    }
    return null;
  }
}
