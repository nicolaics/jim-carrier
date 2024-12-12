import 'package:dio/dio.dart';
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';

Future<dynamic> getBankDetail() async {
  try {
    final response = await dio.get("/bank-detail");

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

Future<dynamic> updateBankDetail(
    {required String bankName,
    required String accountNumber,
    required String accountHolder}) async {
  Map<String, String> body = {
    'bankName': bankName,
    'accountNumber': accountNumber,
    'accountHolder': accountHolder
  };

  try {
    final response = await dio.post("/bank-detail/update", data: body);

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

Future<dynamic> getCarrierBankDetail(
    {required int carrierID, required api}) async {
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
