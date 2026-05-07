# target_parameter_service.api.TargetParameterApi

## Load the API package
```dart
import 'package:target_parameter_service/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getTargetParameters**](TargetParameterApi.md#gettargetparameters) | **GET** /aquariums/{aquariumId}/settings/targets | Get target parameters for an aquarium
[**saveTargetParameters**](TargetParameterApi.md#savetargetparameters) | **POST** /aquariums/{aquariumId}/settings/targets | Save target parameters for an aquarium


# **getTargetParameters**
> ApiResponseDTOTargetParameterResponseDTO getTargetParameters(aquariumId)

Get target parameters for an aquarium

Retrieve target parameters for a specific aquarium

### Example
```dart
import 'package:target_parameter_service/api.dart';

final api_instance = TargetParameterApi();
final aquariumId = 789; // int | 

try {
    final result = api_instance.getTargetParameters(aquariumId);
    print(result);
} catch (e) {
    print('Exception when calling TargetParameterApi->getTargetParameters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aquariumId** | **int**|  | 

### Return type

[**ApiResponseDTOTargetParameterResponseDTO**](ApiResponseDTOTargetParameterResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveTargetParameters**
> ApiResponseDTOTargetParameterResponseDTO saveTargetParameters(aquariumId, saveTargetParameterDTO)

Save target parameters for an aquarium

Save or update target parameters for a specific aquarium

### Example
```dart
import 'package:target_parameter_service/api.dart';

final api_instance = TargetParameterApi();
final aquariumId = 789; // int | 
final saveTargetParameterDTO = SaveTargetParameterDTO(); // SaveTargetParameterDTO | 

try {
    final result = api_instance.saveTargetParameters(aquariumId, saveTargetParameterDTO);
    print(result);
} catch (e) {
    print('Exception when calling TargetParameterApi->saveTargetParameters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aquariumId** | **int**|  | 
 **saveTargetParameterDTO** | [**SaveTargetParameterDTO**](SaveTargetParameterDTO.md)|  | 

### Return type

[**ApiResponseDTOTargetParameterResponseDTO**](ApiResponseDTOTargetParameterResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

