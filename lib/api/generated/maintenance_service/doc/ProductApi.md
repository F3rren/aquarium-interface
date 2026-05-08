# maintenance_service.api.ProductApi

## Load the API package
```dart
import 'package:maintenance_service/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createProduct**](ProductApi.md#createproduct) | **POST** /products | Create a new product
[**deleteProduct**](ProductApi.md#deleteproduct) | **DELETE** /products/{id} | Delete a product
[**getAllProducts**](ProductApi.md#getallproducts) | **GET** /products | Get all products
[**getCategories**](ProductApi.md#getcategories) | **GET** /products/categories | Get all product categories
[**getProductById**](ProductApi.md#getproductbyid) | **GET** /products/{id} | Get product by ID
[**markAsUsed**](ProductApi.md#markasused) | **PATCH** /products/{id}/mark-used | Mark product as used
[**toggleFavorite**](ProductApi.md#togglefavorite) | **PATCH** /products/{id}/toggle-favorite | Toggle favorite status
[**updateProduct**](ProductApi.md#updateproduct) | **PUT** /products/{id} | Update an existing product
[**updateQuantity**](ProductApi.md#updatequantity) | **PATCH** /products/{id}/quantity | Update product quantity


# **createProduct**
> ApiResponseDTOProductDTO createProduct(createProductDTO)

Create a new product

Create a new product

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();
final createProductDTO = CreateProductDTO(); // CreateProductDTO | 

try {
    final result = api_instance.createProduct(createProductDTO);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->createProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createProductDTO** | [**CreateProductDTO**](CreateProductDTO.md)|  | 

### Return type

[**ApiResponseDTOProductDTO**](ApiResponseDTOProductDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProduct**
> deleteProduct(id)

Delete a product

Delete a specific product

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();
final id = 789; // int | 

try {
    api_instance.deleteProduct(id);
} catch (e) {
    print('Exception when calling ProductApi->deleteProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllProducts**
> ApiResponseDTOListProductDTO getAllProducts(category, brand, search, favorites, expired, expiringSoon, lowStock, shouldUseAgain)

Get all products

Retrieve products, optionally filtered by category, brand, or search term

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();
final category = category_example; // String | 
final brand = brand_example; // String | 
final search = search_example; // String | 
final favorites = true; // bool | 
final expired = true; // bool | 
final expiringSoon = true; // bool | 
final lowStock = true; // bool | 
final shouldUseAgain = true; // bool | 

try {
    final result = api_instance.getAllProducts(category, brand, search, favorites, expired, expiringSoon, lowStock, shouldUseAgain);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->getAllProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **category** | **String**|  | [optional] 
 **brand** | **String**|  | [optional] 
 **search** | **String**|  | [optional] 
 **favorites** | **bool**|  | [optional] 
 **expired** | **bool**|  | [optional] 
 **expiringSoon** | **bool**|  | [optional] 
 **lowStock** | **bool**|  | [optional] 
 **shouldUseAgain** | **bool**|  | [optional] 

### Return type

[**ApiResponseDTOListProductDTO**](ApiResponseDTOListProductDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCategories**
> ApiResponseDTOProductCategory getCategories()

Get all product categories

Retrieve the list of all available product categories

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();

try {
    final result = api_instance.getCategories();
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->getCategories: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiResponseDTOProductCategory**](ApiResponseDTOProductCategory.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProductById**
> ApiResponseDTOProductDTO getProductById(id)

Get product by ID

Retrieve a specific product by its ID

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();
final id = 789; // int | 

try {
    final result = api_instance.getProductById(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->getProductById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOProductDTO**](ApiResponseDTOProductDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markAsUsed**
> ApiResponseDTOProductDTO markAsUsed(id)

Mark product as used

Update the last used date of a product to today

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();
final id = 789; // int | 

try {
    final result = api_instance.markAsUsed(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->markAsUsed: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOProductDTO**](ApiResponseDTOProductDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **toggleFavorite**
> ApiResponseDTOProductDTO toggleFavorite(id)

Toggle favorite status

Toggle the favorite status of a product

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();
final id = 789; // int | 

try {
    final result = api_instance.toggleFavorite(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->toggleFavorite: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOProductDTO**](ApiResponseDTOProductDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProduct**
> ApiResponseDTOProductDTO updateProduct(id, updateProductDTO)

Update an existing product

Update details of a specific product

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();
final id = 789; // int | 
final updateProductDTO = UpdateProductDTO(); // UpdateProductDTO | 

try {
    final result = api_instance.updateProduct(id, updateProductDTO);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->updateProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **updateProductDTO** | [**UpdateProductDTO**](UpdateProductDTO.md)|  | 

### Return type

[**ApiResponseDTOProductDTO**](ApiResponseDTOProductDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateQuantity**
> ApiResponseDTOProductDTO updateQuantity(id, quantityChangeDTO)

Update product quantity

Add or subtract from product quantity

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = ProductApi();
final id = 789; // int | 
final quantityChangeDTO = QuantityChangeDTO(); // QuantityChangeDTO | 

try {
    final result = api_instance.updateQuantity(id, quantityChangeDTO);
    print(result);
} catch (e) {
    print('Exception when calling ProductApi->updateQuantity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **quantityChangeDTO** | [**QuantityChangeDTO**](QuantityChangeDTO.md)|  | 

### Return type

[**ApiResponseDTOProductDTO**](ApiResponseDTOProductDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

