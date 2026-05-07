# aquariums_service.api.AquariumApi

## Load the API package
```dart
import 'package:aquariums_service/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addManualParameter**](AquariumApi.md#addmanualparameter) | **POST** /aquariums/{id}/manual-parameters | Add manual parameter
[**addWaterParameter**](AquariumApi.md#addwaterparameter) | **POST** /aquariums/{id}/water-parameters | Add water parameter
[**createAquarium**](AquariumApi.md#createaquarium) | **POST** /aquariums | Create a new aquarium
[**deleteAquarium**](AquariumApi.md#deleteaquarium) | **DELETE** /aquariums/{id} | Delete an aquarium
[**getAllAquariums**](AquariumApi.md#getallaquariums) | **GET** /aquariums | Get all aquariums
[**getAquariumById**](AquariumApi.md#getaquariumbyid) | **GET** /aquariums/{id} | Get aquarium by ID
[**getLatestManualParameter**](AquariumApi.md#getlatestmanualparameter) | **GET** /aquariums/{id}/manual-parameters/latest | Get latest manual parameter
[**getLatestWaterParameter**](AquariumApi.md#getlatestwaterparameter) | **GET** /aquariums/{id}/water-parameters/latest | Get latest water parameter
[**getManualParameters**](AquariumApi.md#getmanualparameters) | **GET** /aquariums/{id}/manual-parameters | Get manual parameters
[**getManualParametersHistory**](AquariumApi.md#getmanualparametershistory) | **GET** /aquariums/{id}/manual-parameters/history | Get manual parameters history
[**getTargetParameters**](AquariumApi.md#gettargetparameters) | **GET** /aquariums/{id}/target-parameters | Get target parameters
[**getWaterParameters**](AquariumApi.md#getwaterparameters) | **GET** /aquariums/{id}/water-parameters | Get water parameters
[**getWaterParametersHistory**](AquariumApi.md#getwaterparametershistory) | **GET** /aquariums/{id}/water-parameters/history | Get water parameters history
[**saveTargetParameters**](AquariumApi.md#savetargetparameters) | **POST** /aquariums/{id}/target-parameters | Save target parameters
[**updateAquarium**](AquariumApi.md#updateaquarium) | **PUT** /aquariums/{id} | Update an existing aquarium


# **addManualParameter**
> ApiResponseDTOManualParameterDTO addManualParameter(id, manualParameterDTO)

Add manual parameter

Record a new manual parameter measurement for an aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 
final manualParameterDTO = ManualParameterDTO(); // ManualParameterDTO | 

try {
    final result = api_instance.addManualParameter(id, manualParameterDTO);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->addManualParameter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **manualParameterDTO** | [**ManualParameterDTO**](ManualParameterDTO.md)|  | 

### Return type

[**ApiResponseDTOManualParameterDTO**](ApiResponseDTOManualParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addWaterParameter**
> ApiResponseDTOWaterParameterDTO addWaterParameter(id, waterParameterDTO)

Add water parameter

Record a new water parameter measurement for an aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 
final waterParameterDTO = WaterParameterDTO(); // WaterParameterDTO | 

try {
    final result = api_instance.addWaterParameter(id, waterParameterDTO);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->addWaterParameter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **waterParameterDTO** | [**WaterParameterDTO**](WaterParameterDTO.md)|  | 

### Return type

[**ApiResponseDTOWaterParameterDTO**](ApiResponseDTOWaterParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createAquarium**
> ApiResponseDTOAquariumResponseDTO createAquarium(createAquariumDTO)

Create a new aquarium

Receive and save a new aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final createAquariumDTO = CreateAquariumDTO(); // CreateAquariumDTO | 

try {
    final result = api_instance.createAquarium(createAquariumDTO);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->createAquarium: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAquariumDTO** | [**CreateAquariumDTO**](CreateAquariumDTO.md)|  | 

### Return type

[**ApiResponseDTOAquariumResponseDTO**](ApiResponseDTOAquariumResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAquarium**
> deleteAquarium(id)

Delete an aquarium

Remove a specific aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 

try {
    api_instance.deleteAquarium(id);
} catch (e) {
    print('Exception when calling AquariumApi->deleteAquarium: $e\n');
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

# **getAllAquariums**
> ApiResponseDTOListAquariumResponseDTO getAllAquariums(page, size, sort)

Get all aquariums

Retrieve paginated list of aquariums

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final page = 56; // int | Zero-based page index (0..N)
final size = 56; // int | The size of the page to be returned
final sort = []; // List<String> | Sorting criteria in the format: property,(asc|desc). Default sort order is ascending. Multiple sort criteria are supported.

try {
    final result = api_instance.getAllAquariums(page, size, sort);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getAllAquariums: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**| Zero-based page index (0..N) | [optional] [default to 0]
 **size** | **int**| The size of the page to be returned | [optional] [default to 20]
 **sort** | [**List<String>**](String.md)| Sorting criteria in the format: property,(asc|desc). Default sort order is ascending. Multiple sort criteria are supported. | [optional] [default to const []]

### Return type

[**ApiResponseDTOListAquariumResponseDTO**](ApiResponseDTOListAquariumResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAquariumById**
> ApiResponseDTOAquariumResponseDTO getAquariumById(id)

Get aquarium by ID

Retrieve details of a specific aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 

try {
    final result = api_instance.getAquariumById(id);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getAquariumById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOAquariumResponseDTO**](ApiResponseDTOAquariumResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLatestManualParameter**
> ApiResponseDTOManualParameterDTO getLatestManualParameter(id)

Get latest manual parameter

Retrieve the most recent manual parameter measurement

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 

try {
    final result = api_instance.getLatestManualParameter(id);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getLatestManualParameter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOManualParameterDTO**](ApiResponseDTOManualParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLatestWaterParameter**
> ApiResponseDTOWaterParameterDTO getLatestWaterParameter(id)

Get latest water parameter

Retrieve the most recent water parameter measurement

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 

try {
    final result = api_instance.getLatestWaterParameter(id);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getLatestWaterParameter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOWaterParameterDTO**](ApiResponseDTOWaterParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getManualParameters**
> ApiResponseDTOListManualParameterDTO getManualParameters(id)

Get manual parameters

Retrieve all manual parameter measurements for an aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 

try {
    final result = api_instance.getManualParameters(id);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getManualParameters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOListManualParameterDTO**](ApiResponseDTOListManualParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getManualParametersHistory**
> ApiResponseDTOListManualParameterDTO getManualParametersHistory(id, from, to)

Get manual parameters history

Retrieve historical manual parameter data

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 
final from = from_example; // String | 
final to = to_example; // String | 

try {
    final result = api_instance.getManualParametersHistory(id, from, to);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getManualParametersHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **from** | **String**|  | 
 **to** | **String**|  | 

### Return type

[**ApiResponseDTOListManualParameterDTO**](ApiResponseDTOListManualParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTargetParameters**
> ApiResponseDTOTargetParameterDTO getTargetParameters(id)

Get target parameters

Retrieve the target parameter values for an aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 

try {
    final result = api_instance.getTargetParameters(id);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getTargetParameters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ApiResponseDTOTargetParameterDTO**](ApiResponseDTOTargetParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWaterParameters**
> ApiResponseDTOListWaterParameterDTO getWaterParameters(id, limit)

Get water parameters

Retrieve water parameter measurements for an aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 
final limit = 56; // int | 

try {
    final result = api_instance.getWaterParameters(id, limit);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getWaterParameters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **limit** | **int**|  | [optional] [default to 10]

### Return type

[**ApiResponseDTOListWaterParameterDTO**](ApiResponseDTOListWaterParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWaterParametersHistory**
> ApiResponseDTOListWaterParameterDTO getWaterParametersHistory(id, period, from, to)

Get water parameters history

Retrieve historical water parameter data

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 
final period = period_example; // String | 
final from = from_example; // String | 
final to = to_example; // String | 

try {
    final result = api_instance.getWaterParametersHistory(id, period, from, to);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->getWaterParametersHistory: $e\n');
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

[**ApiResponseDTOListWaterParameterDTO**](ApiResponseDTOListWaterParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveTargetParameters**
> ApiResponseDTOTargetParameterDTO saveTargetParameters(id, targetParameterDTO)

Save target parameters

Set target parameter values for an aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 
final targetParameterDTO = TargetParameterDTO(); // TargetParameterDTO | 

try {
    final result = api_instance.saveTargetParameters(id, targetParameterDTO);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->saveTargetParameters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **targetParameterDTO** | [**TargetParameterDTO**](TargetParameterDTO.md)|  | 

### Return type

[**ApiResponseDTOTargetParameterDTO**](ApiResponseDTOTargetParameterDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAquarium**
> ApiResponseDTOAquariumResponseDTO updateAquarium(id, updateAquariumDTO)

Update an existing aquarium

Modify details of a specific aquarium

### Example
```dart
import 'package:aquariums_service/api.dart';

final api_instance = AquariumApi();
final id = 789; // int | 
final updateAquariumDTO = UpdateAquariumDTO(); // UpdateAquariumDTO | 

try {
    final result = api_instance.updateAquarium(id, updateAquariumDTO);
    print(result);
} catch (e) {
    print('Exception when calling AquariumApi->updateAquarium: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **updateAquariumDTO** | [**UpdateAquariumDTO**](UpdateAquariumDTO.md)|  | 

### Return type

[**ApiResponseDTOAquariumResponseDTO**](ApiResponseDTOAquariumResponseDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

