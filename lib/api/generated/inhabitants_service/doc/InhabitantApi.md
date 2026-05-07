# inhabitants_service.api.InhabitantApi

## Load the API package
```dart
import 'package:inhabitants_service/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addInhabitantToAquarium**](InhabitantApi.md#addinhabitanttoaquarium) | **POST** /aquariums/{id}/inhabitants | Add an inhabitant to an aquarium
[**getAquariumInhabitants**](InhabitantApi.md#getaquariuminhabitants) | **GET** /aquariums/{id}/inhabitants | Get inhabitants by aquarium ID
[**removeInhabitantFromAquarium**](InhabitantApi.md#removeinhabitantfromaquarium) | **DELETE** /aquariums/{aquariumId}/inhabitants/{inhabitantId} | Remove an inhabitant from an aquarium
[**updateInhabitant**](InhabitantApi.md#updateinhabitant) | **PUT** /aquariums/{aquariumId}/inhabitants/{inhabitantId} | Update an inhabitant


# **addInhabitantToAquarium**
> ApiResponseDTOInhabitantDetailsDTO addInhabitantToAquarium(id, createInhabitantDTO)

Add an inhabitant to an aquarium

Add a new inhabitant to a specific aquarium

### Example
```dart
import 'package:inhabitants_service/api.dart';

final api_instance = InhabitantApi();
final id = 789; // int | 
final createInhabitantDTO = CreateInhabitantDTO(); // CreateInhabitantDTO | 

try {
    final result = api_instance.addInhabitantToAquarium(id, createInhabitantDTO);
    print(result);
} catch (e) {
    print('Exception when calling InhabitantApi->addInhabitantToAquarium: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **createInhabitantDTO** | [**CreateInhabitantDTO**](CreateInhabitantDTO.md)|  | 

### Return type

[**ApiResponseDTOInhabitantDetailsDTO**](ApiResponseDTOInhabitantDetailsDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAquariumInhabitants**
> ApiResponseDTOListInhabitantDetailsDTO getAquariumInhabitants(id)

Get inhabitants by aquarium ID

Retrieve details of inhabitants in a specific aquarium

### Example
```dart
import 'package:inhabitants_service/api.dart';

final api_instance = InhabitantApi();
final id = 789; // int | 

try {
    final result = api_instance.getAquariumInhabitants(id);
    print(result);
} catch (e) {
    print('Exception when calling InhabitantApi->getAquariumInhabitants: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOListInhabitantDetailsDTO**](ApiResponseDTOListInhabitantDetailsDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeInhabitantFromAquarium**
> removeInhabitantFromAquarium(aquariumId, inhabitantId)

Remove an inhabitant from an aquarium

Remove an inhabitant from a specific aquarium

### Example
```dart
import 'package:inhabitants_service/api.dart';

final api_instance = InhabitantApi();
final aquariumId = 789; // int | 
final inhabitantId = 789; // int | 

try {
    api_instance.removeInhabitantFromAquarium(aquariumId, inhabitantId);
} catch (e) {
    print('Exception when calling InhabitantApi->removeInhabitantFromAquarium: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aquariumId** | **int**|  | 
 **inhabitantId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateInhabitant**
> ApiResponseDTOInhabitantDetailsDTO updateInhabitant(aquariumId, inhabitantId, updateInhabitantDTO)

Update an inhabitant

Update quantity, notes, custom name, current size or other custom fields of an inhabitant

### Example
```dart
import 'package:inhabitants_service/api.dart';

final api_instance = InhabitantApi();
final aquariumId = 789; // int | 
final inhabitantId = 789; // int | 
final updateInhabitantDTO = UpdateInhabitantDTO(); // UpdateInhabitantDTO | 

try {
    final result = api_instance.updateInhabitant(aquariumId, inhabitantId, updateInhabitantDTO);
    print(result);
} catch (e) {
    print('Exception when calling InhabitantApi->updateInhabitant: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aquariumId** | **int**|  | 
 **inhabitantId** | **int**|  | 
 **updateInhabitantDTO** | [**UpdateInhabitantDTO**](UpdateInhabitantDTO.md)|  | 

### Return type

[**ApiResponseDTOInhabitantDetailsDTO**](ApiResponseDTOInhabitantDetailsDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

