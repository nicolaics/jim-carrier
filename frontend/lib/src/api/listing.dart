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
    required api}) async {
  final url = Uri.parse((baseUrl + api));
  String? token2 = await StorageService.getToken();
  // Create the request body as per your payload struct
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
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token2',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      // Handle successful response
      print('Listing added successfully');
      return "success";
    } else {
      // Handle errors, e.g. 400, 500, etc.
      print('Failed to addlisting: ${response.body}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> getMyListing({required String api}) async {
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
      print('response ${response.body}');
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

Future<dynamic> getAllListings({required String api}) async {
  print("inside");
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
      print('response ${response.body}');
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
