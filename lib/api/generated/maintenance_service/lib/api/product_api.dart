//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ProductApi {
  ProductApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new product
  ///
  /// Create a new product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateProductDTO] createProductDTO (required):
  Future<Response> createProductWithHttpInfo(CreateProductDTO createProductDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/products';

    // ignore: prefer_final_locals
    Object? postBody = createProductDTO;

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

  /// Create a new product
  ///
  /// Create a new product
  ///
  /// Parameters:
  ///
  /// * [CreateProductDTO] createProductDTO (required):
  Future<ApiResponseDTOProductDTO?> createProduct(CreateProductDTO createProductDTO,) async {
    final response = await createProductWithHttpInfo(createProductDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOProductDTO',) as ApiResponseDTOProductDTO;
    
    }
    return null;
  }

  /// Delete a product
  ///
  /// Delete a specific product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> deleteProductWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/products/{id}'
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

  /// Delete a product
  ///
  /// Delete a specific product
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<void> deleteProduct(int id,) async {
    final response = await deleteProductWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get all products
  ///
  /// Retrieve products, optionally filtered by category, brand, or search term
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] category:
  ///
  /// * [String] brand:
  ///
  /// * [String] search:
  ///
  /// * [bool] favorites:
  ///
  /// * [bool] expired:
  ///
  /// * [bool] expiringSoon:
  ///
  /// * [bool] lowStock:
  ///
  /// * [bool] shouldUseAgain:
  Future<Response> getAllProductsWithHttpInfo({ String? category, String? brand, String? search, bool? favorites, bool? expired, bool? expiringSoon, bool? lowStock, bool? shouldUseAgain, }) async {
    // ignore: prefer_const_declarations
    final path = r'/products';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (category != null) {
      queryParams.addAll(_queryParams('', 'category', category));
    }
    if (brand != null) {
      queryParams.addAll(_queryParams('', 'brand', brand));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (favorites != null) {
      queryParams.addAll(_queryParams('', 'favorites', favorites));
    }
    if (expired != null) {
      queryParams.addAll(_queryParams('', 'expired', expired));
    }
    if (expiringSoon != null) {
      queryParams.addAll(_queryParams('', 'expiringSoon', expiringSoon));
    }
    if (lowStock != null) {
      queryParams.addAll(_queryParams('', 'lowStock', lowStock));
    }
    if (shouldUseAgain != null) {
      queryParams.addAll(_queryParams('', 'shouldUseAgain', shouldUseAgain));
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

  /// Get all products
  ///
  /// Retrieve products, optionally filtered by category, brand, or search term
  ///
  /// Parameters:
  ///
  /// * [String] category:
  ///
  /// * [String] brand:
  ///
  /// * [String] search:
  ///
  /// * [bool] favorites:
  ///
  /// * [bool] expired:
  ///
  /// * [bool] expiringSoon:
  ///
  /// * [bool] lowStock:
  ///
  /// * [bool] shouldUseAgain:
  Future<ApiResponseDTOListProductDTO?> getAllProducts({ String? category, String? brand, String? search, bool? favorites, bool? expired, bool? expiringSoon, bool? lowStock, bool? shouldUseAgain, }) async {
    final response = await getAllProductsWithHttpInfo( category: category, brand: brand, search: search, favorites: favorites, expired: expired, expiringSoon: expiringSoon, lowStock: lowStock, shouldUseAgain: shouldUseAgain, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOListProductDTO',) as ApiResponseDTOListProductDTO;
    
    }
    return null;
  }

  /// Get all product categories
  ///
  /// Retrieve the list of all available product categories
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getCategoriesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/products/categories';

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

  /// Get all product categories
  ///
  /// Retrieve the list of all available product categories
  Future<ApiResponseDTOProductCategory?> getCategories() async {
    final response = await getCategoriesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOProductCategory',) as ApiResponseDTOProductCategory;
    
    }
    return null;
  }

  /// Get product by ID
  ///
  /// Retrieve a specific product by its ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> getProductByIdWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/products/{id}'
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

  /// Get product by ID
  ///
  /// Retrieve a specific product by its ID
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOProductDTO?> getProductById(int id,) async {
    final response = await getProductByIdWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOProductDTO',) as ApiResponseDTOProductDTO;
    
    }
    return null;
  }

  /// Mark product as used
  ///
  /// Update the last used date of a product to today
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> markAsUsedWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/products/{id}/mark-used'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Mark product as used
  ///
  /// Update the last used date of a product to today
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOProductDTO?> markAsUsed(int id,) async {
    final response = await markAsUsedWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOProductDTO',) as ApiResponseDTOProductDTO;
    
    }
    return null;
  }

  /// Toggle favorite status
  ///
  /// Toggle the favorite status of a product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> toggleFavoriteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/products/{id}/toggle-favorite'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Toggle favorite status
  ///
  /// Toggle the favorite status of a product
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<ApiResponseDTOProductDTO?> toggleFavorite(int id,) async {
    final response = await toggleFavoriteWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOProductDTO',) as ApiResponseDTOProductDTO;
    
    }
    return null;
  }

  /// Update an existing product
  ///
  /// Update details of a specific product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [UpdateProductDTO] updateProductDTO (required):
  Future<Response> updateProductWithHttpInfo(int id, UpdateProductDTO updateProductDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/products/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = updateProductDTO;

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

  /// Update an existing product
  ///
  /// Update details of a specific product
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [UpdateProductDTO] updateProductDTO (required):
  Future<ApiResponseDTOProductDTO?> updateProduct(int id, UpdateProductDTO updateProductDTO,) async {
    final response = await updateProductWithHttpInfo(id, updateProductDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOProductDTO',) as ApiResponseDTOProductDTO;
    
    }
    return null;
  }

  /// Update product quantity
  ///
  /// Add or subtract from product quantity
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [QuantityChangeDTO] quantityChangeDTO (required):
  Future<Response> updateQuantityWithHttpInfo(int id, QuantityChangeDTO quantityChangeDTO,) async {
    // ignore: prefer_const_declarations
    final path = r'/products/{id}/quantity'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = quantityChangeDTO;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update product quantity
  ///
  /// Add or subtract from product quantity
  ///
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [QuantityChangeDTO] quantityChangeDTO (required):
  Future<ApiResponseDTOProductDTO?> updateQuantity(int id, QuantityChangeDTO quantityChangeDTO,) async {
    final response = await updateQuantityWithHttpInfo(id, quantityChangeDTO,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApiResponseDTOProductDTO',) as ApiResponseDTOProductDTO;
    
    }
    return null;
  }
}
