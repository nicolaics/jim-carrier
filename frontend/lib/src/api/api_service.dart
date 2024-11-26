import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:jim/src/flutter_storage.dart';
import 'dart:convert';


const baseUrl = "http://ion-suhalim:9988/api/v1";
//const baseUrl = "http://pravass-macbook-air:9988/api/v1";

class ApiService {
  var client = http.Client();

  Future<dynamic> updateProfile({required Uint8List img, required String api}) async {
    String? token2= await StorageService.getToken();
    final url = Uri.parse((baseUrl + api));

    Map<String, dynamic> body = {
      'profilePicture': img,
    };

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token2',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode.isSuccessfulHttpStatusCode) {
        print('Changed succesfully');
        print(response.body);
        return response.body;
      } else {
        print('Failed to update: ${response.body}');
        print(response.body);
        throw "failed";
        // return "failed";
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<dynamic> get({required String api}) async {
    String? token2= await StorageService.getToken();
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

  Future<dynamic> getListing({required String api}) async {
    print("inside");
    String? token2= await StorageService.getToken();
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

  Future<dynamic> getOrder({required String api}) async {
    String? token2= await StorageService.getToken();
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


  Future<dynamic> getOwnListing({required String api}) async {
    String? token2= await StorageService.getToken();
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

  Future<dynamic> review(
      {required int orderId,
        required String reviewName,
        required String? reviewContent,
        required int rating,
        required String api}) async {
    String? token2= await StorageService.getToken();
    final url = Uri.parse((baseUrl + api));

    Map<String, dynamic> body = {
      'orderId': orderId,
      'revieweeName': reviewName,
      'content': reviewContent,
      'rating': rating,
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
        print('Review successful.');
        return jsonDecode(response.body)['token'];
      } else {
        print('Failed to review: ${response.body}');
        return "failed";
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<dynamic> order(
      {required int listid,
        required double weight,
        required double price,
        required String currency,
        required String packageContent,
        required Uint8List? packageImage,
        required String api}) async {
    String? token2= await StorageService.getToken();
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


  Future<dynamic> myOrder(
      {required api}) async {
    final url = Uri.parse((baseUrl + api));
    String? token2= await StorageService.getToken();

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
    String? token2= await StorageService.getToken();
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
}

