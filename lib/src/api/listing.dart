import 'package:dio/dio.dart';
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';

Future<dynamic> addListing(
    {required String destination,
    required double weight,
    required double price,
    required String currency,
    required String date,
    required String lastDate,
    required String additionalInfo,
    required api}) async {
  Map<String, dynamic> body = {
    'destination': destination,
    'weightAvailable': weight,
    'pricePerKg': price,
    'currency': currency,
    'departureDate': date,
    'lastReceivedDate': lastDate,
    'description': additionalInfo,
  };

  try {
    final response = await dio.post((api), data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return writeConnectionTimeoutResponse();
    }
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> getMyListing({required String api}) async {
  try {
    final response = await dio.get((api));

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return writeConnectionTimeoutResponse();
    }
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> getAllListings({required String api}) async {
  try {
    final response = await dio.get((api));

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return writeConnectionTimeoutResponse();
    }
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> modifyListing(
    {required int? id,
    required String destination,
    required double weight,
    required double price,
    required String currency,
    required String date,
    required String lastDate,
    required String additionalInfo,
    required api}) async {
  Map<String, dynamic> body = {
    'id': id,
    'destination': destination,
    'weightAvailable': weight,
    'pricePerKg': price,
    'currency': currency,
    'departureDate': date,
    'lastReceivedDate': lastDate,
    'description': additionalInfo,
  };

  try {
    final response = await dio.patch((api), data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return writeConnectionTimeoutResponse();
    }
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> checkExistingOrder(
    {required int id, required String api}) async {
  Map<String, int> body = {'id': id};

  try {
    final response = await dio.post((api), data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return writeConnectionTimeoutResponse();
    }
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> deleteListing(
    {required int id, required String api}) async {
  Map<String, int> body = {'id': id};

  try {
    final response = await dio.delete((api), data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return writeConnectionTimeoutResponse();
    }
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}