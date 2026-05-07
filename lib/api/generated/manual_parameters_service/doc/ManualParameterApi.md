# manual_parameters_service.api.ManualParameterApi

## Load the API package
```dart
import 'package:manual_parameters_service/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addManualParameter**](ManualParameterApi.md#addmanualparameter) | **POST** /aquariums/{aquariumId}/parameters/manual | Add a new manual parameter
[**getLatestManualParameter**](ManualParameterApi.md#getlatestmanualparameter) | **GET** /aquariums/{aquariumId}/parameters/manual | Get latest manual parameter
[**getManualParametersHistory**](ManualParameterApi.md#getmanualparametershistory) | **GET** /aquariums/{aquariumId}/parameters/manual/history | Get manual parameters history


# **addManualParameter**
> ApiResponseDTOManualParameterDTO addManualParameter(aquariumId, createManualParameterDTO)

Add a new manual parameter

Add a new manual parameter for a specific aquarium

### Example
```dart
import 'package:manual_parameters_service/api.dart';

final api_instance = ManualParameterApi();
final aquariumId = 789; // int | 
final createManualParameterDTO = CreateManualParameterDTO(); // CreateManualParameterDTO | 

try {
    final result = api_instance.addManualParameter(aquariumId, createManualParameterDTO);
    print(result);
} catch (e) {
    print('Exception when calling ManualParameterApi->addManualParameter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aquariumId** | **int**|  | 
 **createManualParameterDTO** | [**CreateManualParameterDTO**](CreateManualParameterDTO.md)|  | 

### Return type

[**ApiResponseDTOManualParameterDTO**](ApiResponseDTOManualParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLatestManualParameter**
> ApiResponseDTOManualParameterDTO getLatestManualParameter(aquariumId)

Get latest manual parameter

Retrieve the most recent manual parameter

### Example
```dart
import 'package:manual_parameters_service/api.dart';

final api_instance = ManualParameterApi();
final aquariumId = 789; // int | 

try {
    final result = api_instance.getLatestManualParameter(aquariumId);
    print(result);
} catch (e) {
    print('Exception when calling ManualParameterApi->getLatestManualParameter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aquariumId** | **int**|  | 

### Return type

[**ApiResponseDTOManualParameterDTO**](ApiResponseDTOManualParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getManualParametersHistory**
> ApiResponseDTOListManualParameterDTO getManualParametersHistory(aquariumId, from, to)

Get manual parameters history

Retrieve manual parameters within a date range

### Example
```dart
import 'package:manual_parameters_service/api.dart';

final api_instance = ManualParameterApi();
final aquariumId = 789; // int | 
final from = from_example; // String | 
final to = to_example; // String | 

try {
    final result = api_instance.getManualParametersHistory(aquariumId, from, to);
    print(result);
} catch (e) {
    print('Exception when calling ManualParameterApi->getManualParametersHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aquariumId** | **int**|  | 
 **from** | **String**|  | [optional] 
 **to** | **String**|  | [optional] 

### Return type

[**ApiResponseDTOListManualParameterDTO**](ApiResponseDTOListManualParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

