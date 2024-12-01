import 'dart:convert';
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';
import 'package:jim/src/flutter_storage.dart';
import 'package:http/http.dart' as http;

Future<dynamic> addListing(
    {required String destination,
    required double weight,
    required double price,
    required String currency,
    required String date,
    required String lastDate,
    required String additionalInfo,
    required String accountHolder,
    required String bankName,
    required String accountNumber,
    required api}) async {
  final url = Uri.parse((baseUrl + api));
  String? token = await StorageService.getAccessToken();

  // Create the request body as per your payload struct
  Map<String, dynamic> body = {
    'destination': destination,
    'weightAvailable': weight,
    'pricePerKg': price,
    'currency': currency,
    'departureDate': date,
    'lastReceivedDate': lastDate,
    'description': additionalInfo,
    'accountNumber': accountNumber,
    'accountHolder': accountHolder,
    'bankName': bankName,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(responseBody: response.body);
    } else {
      if (jsonDecode(response.body)['error'].contains("access token expired")) {
        return writeAccessTokenExpResponse();
      }

      return writeErrorResponse(responseBody: response.body);
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> getMyListing({required String api}) async {
  String? token = await StorageService.getAccessToken();
  final url = Uri.parse((baseUrl + api));

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(responseBody: response.body);
    }
    else {
      if (jsonDecode(response.body)['error'].contains("access token expired")) {
        return writeAccessTokenExpResponse();
      }

      return writeErrorResponse(responseBody: response.body);
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> getAllListings({required String api}) async {
  String? token = await StorageService.getAccessToken();
  final url = Uri.parse((baseUrl + api));

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(responseBody: response.body);
    }
    else {
      if (jsonDecode(response.body)['error'].contains("access token expired")) {
        return writeAccessTokenExpResponse();
      }

      return writeErrorResponse(responseBody: response.body);
    }
  } catch (e) {
    print('Error occurred: $e');
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
    required String accountHolder,
    required String bankName,
    required String accountNumber,
    required api}) async {
  final url = Uri.parse((baseUrl + api));

  String? token = await StorageService.getAccessToken();

  Map<String, dynamic> body = {
    'id': id,
    'destination': destination,
    'weightAvailable': weight,
    'pricePerKg': price,
    'currency': currency,
    'departureDate': date,
    'lastReceivedDate': lastDate,
    'description': additionalInfo,
    'accountNumber': accountNumber,
    'accountHolder': accountHolder,
    'bankName': bankName,
  };

  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(responseBody: response.body);
    }
    else {
      if (jsonDecode(response.body)['error'].contains("access token expired")) {
        return writeAccessTokenExpResponse();
      }

      return writeErrorResponse(responseBody: response.body);
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
