# species_service.api.SpeciesApi

## Load the API package
```dart
import 'package:species_service/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAllCorals**](SpeciesApi.md#getallcorals) | **GET** /species/corals | Get all corals
[**getAllFish**](SpeciesApi.md#getallfish) | **GET** /species/fish | Get all fish
[**getCoralById**](SpeciesApi.md#getcoralbyid) | **GET** /species/corals/{id} | Get a coral by ID
[**getFishById**](SpeciesApi.md#getfishbyid) | **GET** /species/fish/{id} | Get a fish by ID


# **getAllCorals**
> ApiResponseDTOListCoralResponseDTO getAllCorals()

Get all corals

Retrieve a list of all coral species

### Example
```dart
import 'package:species_service/api.dart';

final api_instance = SpeciesApi();

try {
    final result = api_instance.getAllCorals();
    print(result);
} catch (e) {
    print('Exception when calling SpeciesApi->getAllCorals: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiResponseDTOListCoralResponseDTO**](ApiResponseDTOListCoralResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllFish**
> ApiResponseDTOListFishResponseDTO getAllFish()

Get all fish

Retrieve a list of all fish species

### Example
```dart
import 'package:species_service/api.dart';

final api_instance = SpeciesApi();

try {
    final result = api_instance.getAllFish();
    print(result);
} catch (e) {
    print('Exception when calling SpeciesApi->getAllFish: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiResponseDTOListFishResponseDTO**](ApiResponseDTOListFishResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCoralById**
> ApiResponseDTOCoralResponseDTO getCoralById(id)

Get a coral by ID

Retrieve details of a specific coral by its ID

### Example
```dart
import 'package:species_service/api.dart';

final api_instance = SpeciesApi();
final id = 789; // int | 

try {
    final result = api_instance.getCoralById(id);
    print(result);
} catch (e) {
    print('Exception when calling SpeciesApi->getCoralById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOCoralResponseDTO**](ApiResponseDTOCoralResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFishById**
> ApiResponseDTOFishResponseDTO getFishById(id)

Get a fish by ID

Retrieve details of a specific fish by its ID

### Example
```dart
import 'package:species_service/api.dart';

final api_instance = SpeciesApi();
final id = 789; // int | 

try {
    final result = api_instance.getFishById(id);
    print(result);
} catch (e) {
    print('Exception when calling SpeciesApi->getFishById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOFishResponseDTO**](ApiResponseDTOFishResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

