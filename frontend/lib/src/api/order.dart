import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';
import 'package:jim/src/flutter_storage.dart';

Future<dynamic> getAllOrders({required String api}) async {
  String? token2 = await StorageService.getToken();
  print("Token in api get: $token2");
  final url = Uri.parse((baseUrl + api));

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token2',
      },
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      print('response getOrder ${response.body}');
      return jsonDecode(response.body);
    } else {
      //print('Error: ${response.body}');
      return {"status": "failed"}; // Returning a consistent response format
    }
  } catch (e) {
    print('Error occurred: $e');
    return {
      "status": "error",
      "message": e.toString()
    }; // Return an error object
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
  String? token2 = await StorageService.getToken();
  final url = Uri.parse((baseUrl + api));

  Map<String, dynamic> body = {
    'listingId': listid,
    'weight': weight,
    'price': price,
    'currency': currency,
    'packageContent': packageContent,
    'packageImage': packageImage,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token2',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      print('User ordered successfully');
      return jsonDecode(response.body)['token'];
    } else {
      print('Failed to order: ${response.body}');
      return "failed";
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> getMyOrder({required api}) async {
  final url = Uri.parse((baseUrl + api));
  String? token2 = await StorageService.getToken();

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token2',
      },
    );
    if (response.statusCode.isSuccessfulHttpStatusCode) {
      print('Data received');
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // Handle errors, e.g. 400, 500, etc.
      print('Failed to addlisting: ${response.body}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> updateOrderStatus(
    {required int? orderNo,
    required String orderStatus,
    required String api}) async {
  final url = Uri.parse((baseUrl + api));
  String? token = await StorageService.getToken();
  Map<String, dynamic> body = {
    'id': orderNo,
    'orderStatus': orderStatus,
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
    dynamic responseDecode = jsonDecode(response.body);
    if (response.statusCode.isSuccessfulHttpStatusCode) {
      print("Confirmation success");
      return responseDecode['token'];
    } else {
      if (responseDecode['error'].contains("to registration")) {
        return "toRegist";
      }
      return responseDecode['error'];
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> getOrderDetail({required String api, required int id}) async {
  final url = Uri.parse((baseUrl + api));
  String? token2 = await StorageService.getToken();

  Map<String, dynamic> body = {
    'id': id,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token2',
      },
      body: jsonEncode(body)
    );
    
    if (response.statusCode.isSuccessfulHttpStatusCode) {
      print('Data received');
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // Handle errors, e.g. 400, 500, etc.
      print('Failed to addlisting: ${response.body}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> updatePaymentStatus(
    {required int? orderNo,
      required String paymentStatus,
      required Uint8List? paymentProof,
      required String api}) async {
  final url = Uri.parse((baseUrl + api));
  String? token = await StorageService.getToken();
  Map<String, dynamic> body = {
    'id': orderNo,
    'paymentStatus': paymentStatus,
    'paymentProof':paymentProof
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
    dynamic responseDecode = jsonDecode(response.body);
    if (response.statusCode.isSuccessfulHttpStatusCode) {
      print("Confirmation success");
      return responseDecode['token'];
    } else {
      if (responseDecode['error'].contains("to registration")) {
        return "toRegist";
      }
      return responseDecode['error'];
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}