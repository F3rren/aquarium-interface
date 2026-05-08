# maintenance_service.api.MaintenanceTaskApi

## Load the API package
```dart
import 'package:maintenance_service/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**completeTask**](MaintenanceTaskApi.md#completetask) | **POST** /aquariums/{id}/tasks/{taskId}/complete | Mark a task as completed
[**createTask**](MaintenanceTaskApi.md#createtask) | **POST** /aquariums/{id}/tasks | Create a new maintenance task
[**deleteTask**](MaintenanceTaskApi.md#deletetask) | **DELETE** /aquariums/{id}/tasks/{taskId} | Delete a maintenance task
[**getAllTasks**](MaintenanceTaskApi.md#getalltasks) | **GET** /aquariums/{id}/tasks | Get all maintenance tasks for an aquarium
[**updateTask**](MaintenanceTaskApi.md#updatetask) | **PUT** /aquariums/{id}/tasks/{taskId} | Update a maintenance task


# **completeTask**
> ApiResponseDTOMaintenanceTaskDTO completeTask(id, taskId)

Mark a task as completed

Mark a specific task as completed

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = MaintenanceTaskApi();
final id = 789; // int | 
final taskId = 789; // int | 

try {
    final result = api_instance.completeTask(id, taskId);
    print(result);
} catch (e) {
    print('Exception when calling MaintenanceTaskApi->completeTask: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **taskId** | **int**|  | 

### Return type

[**ApiResponseDTOMaintenanceTaskDTO**](ApiResponseDTOMaintenanceTaskDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createTask**
> ApiResponseDTOMaintenanceTaskDTO createTask(id, createMaintenanceTaskDTO)

Create a new maintenance task

Create a new task for a specific aquarium

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = MaintenanceTaskApi();
final id = 789; // int | 
final createMaintenanceTaskDTO = CreateMaintenanceTaskDTO(); // CreateMaintenanceTaskDTO | 

try {
    final result = api_instance.createTask(id, createMaintenanceTaskDTO);
    print(result);
} catch (e) {
    print('Exception when calling MaintenanceTaskApi->createTask: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **createMaintenanceTaskDTO** | [**CreateMaintenanceTaskDTO**](CreateMaintenanceTaskDTO.md)|  | 

### Return type

[**ApiResponseDTOMaintenanceTaskDTO**](ApiResponseDTOMaintenanceTaskDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteTask**
> deleteTask(id, taskId)

Delete a maintenance task

Delete a specific task

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = MaintenanceTaskApi();
final id = 789; // int | 
final taskId = 789; // int | 

try {
    api_instance.deleteTask(id, taskId);
} catch (e) {
    print('Exception when calling MaintenanceTaskApi->deleteTask: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **taskId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllTasks**
> ApiResponseDTOListMaintenanceTaskDTO getAllTasks(id, status)

Get all maintenance tasks for an aquarium

Retrieve tasks, optionally filtered by status

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = MaintenanceTaskApi();
final id = 789; // int | 
final status = status_example; // String | 

try {
    final result = api_instance.getAllTasks(id, status);
    print(result);
} catch (e) {
    print('Exception when calling MaintenanceTaskApi->getAllTasks: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **status** | **String**|  | [optional] 

### Return type

[**ApiResponseDTOListMaintenanceTaskDTO**](ApiResponseDTOListMaintenanceTaskDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateTask**
> ApiResponseDTOMaintenanceTaskDTO updateTask(id, taskId, updateMaintenanceTaskDTO)

Update a maintenance task

Update details of a specific task

### Example
```dart
import 'package:maintenance_service/api.dart';

final api_instance = MaintenanceTaskApi();
final id = 789; // int | 
final taskId = 789; // int | 
final updateMaintenanceTaskDTO = UpdateMaintenanceTaskDTO(); // UpdateMaintenanceTaskDTO | 

try {
    final result = api_instance.updateTask(id, taskId, updateMaintenanceTaskDTO);
    print(result);
} catch (e) {
    print('Exception when calling MaintenanceTaskApi->updateTask: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **taskId** | **int**|  | 
 **updateMaintenanceTaskDTO** | [**UpdateMaintenanceTaskDTO**](UpdateMaintenanceTaskDTO.md)|  | 

### Return type

[**ApiResponseDTOMaintenanceTaskDTO**](ApiResponseDTOMaintenanceTaskDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

