# parameters_service.api.WaterParameterApi

## Load the API package
```dart
import 'package:parameters_service/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addParameter**](WaterParameterApi.md#addparameter) | **POST** /aquariums/{id}/parameters | Add a new water parameter
[**getLatestParameter**](WaterParameterApi.md#getlatestparameter) | **GET** /aquariums/{id}/parameters/latest | Get latest water parameter
[**getParametersByAquarium**](WaterParameterApi.md#getparametersbyaquarium) | **GET** /aquariums/{id}/parameters | Get water parameters
[**getParametersHistory**](WaterParameterApi.md#getparametershistory) | **GET** /aquariums/{id}/parameters/history | Get water parameters history


# **addParameter**
> ApiResponseDTOParameterDTO addParameter(id, createParameterDTO)

Add a new water parameter

Add a new water parameter for a specific aquarium

### Example
```dart
import 'package:parameters_service/api.dart';

final api_instance = WaterParameterApi();
final id = 789; // int | 
final createParameterDTO = CreateParameterDTO(); // CreateParameterDTO | 

try {
    final result = api_instance.addParameter(id, createParameterDTO);
    print(result);
} catch (e) {
    print('Exception when calling WaterParameterApi->addParameter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **createParameterDTO** | [**CreateParameterDTO**](CreateParameterDTO.md)|  | 

### Return type

[**ApiResponseDTOParameterDTO**](ApiResponseDTOParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLatestParameter**
> ApiResponseDTOParameterDTO getLatestParameter(id)

Get latest water parameter

Retrieve the most recent water parameter

### Example
```dart
import 'package:parameters_service/api.dart';

final api_instance = WaterParameterApi();
final id = 789; // int | 

try {
    final result = api_instance.getLatestParameter(id);
    print(result);
} catch (e) {
    print('Exception when calling WaterParameterApi->getLatestParameter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOParameterDTO**](ApiResponseDTOParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getParametersByAquarium**
> ApiResponseDTOListParameterDTO getParametersByAquarium(id, limit)

Get water parameters

Retrieve water parameters for a specific aquarium with optional limit

### Example
```dart
import 'package:parameters_service/api.dart';

final api_instance = WaterParameterApi();
final id = 789; // int | 
final limit = 56; // int | 

try {
    final result = api_instance.getParametersByAquarium(id, limit);
    print(result);
} catch (e) {
    print('Exception when calling WaterParameterApi->getParametersByAquarium: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **limit** | **int**|  | [optional] [default to 10]

### Return type

[**ApiResponseDTOListParameterDTO**](ApiResponseDTOListParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getParametersHistory**
> ApiResponseDTOListParameterDTO getParametersHistory(id, period, from, to)

Get water parameters history

Retrieve history based on period or date range

### Example
```dart
import 'package:parameters_service/api.dart';

final api_instance = WaterParameterApi();
final id = 789; // int | 
final period = period_example; // String | 
final from = from_example; // String | 
final to = to_example; // String | 

try {
    final result = api_instance.getParametersHistory(id, period, from, to);
    print(result);
} catch (e) {
    print('Exception when calling WaterParameterApi->getParametersHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **period** | **String**|  | [optional] 
 **from** | **String**|  | [optional] 
 **to** | **String**|  | [optional] 

### Return type

[**ApiResponseDTOListParameterDTO**](ApiResponseDTOListParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

