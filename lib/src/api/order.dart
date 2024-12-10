import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';

Future<dynamic> getAllOrders({required String api}) async {
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

Future<dynamic> createOrder(
    {required int listid,
    required double weight,
    required double price,
    required String currency,
    required String packageContent,
    required Uint8List? packageImage,
    required String api}) async {
  Map<String, dynamic> body = {
    'listingId': listid,
    'weight': weight,
    'price': price,
    'currency': currency,
    'packageContent': packageContent,
    'packageImage': packageImage,
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

Future<dynamic> getMyOrder({required api}) async {
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

Future<dynamic> updateOrderStatus(
    {required int? orderNo,
    required String orderStatus,
    required String api}) async {
  Map<String, dynamic> body = {
    'id': orderNo,
    'orderStatus': orderStatus,
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

Future<dynamic> getOrderDetail({required String api, required int id}) async {
  Map<String, dynamic> body = {
    'id': id,
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

Future<dynamic> updatePaymentStatus(
    {required int? orderNo,
    required String paymentStatus,
    required Uint8List? paymentProof,
    required String api}) async {
  Map<String, dynamic> body = {
    'id': orderNo,
    'paymentStatus': paymentStatus,
    'paymentProof': paymentProof
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

Future<dynamic> updatePackageLocation(
    {required int orderNo,
    required String? location,
    required String? orderStatus,
    required String api}) async {
  Map<String, dynamic> body = {
    'id': orderNo,
    'packageLocation': location,
    'orderStatus': orderStatus,
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

Future<dynamic> getReceivedOrders({required api}) async {
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

Future<dynamic> getBankDetails({required int carrierID, required api}) async {
  Map<String, int> body = {
    'carrierId': carrierID,
  };

  try {
    final response = await dio.post(api, data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      if (response.data['status'] == 'exist') {
        return writeSuccessResponse(response: response);
      } else {
        return writeErrorResponse(response: response);
      }
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
