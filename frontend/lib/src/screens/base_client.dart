import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'all_datas.dart';

const baseUrl ="http://ion-suhalim:9988/api/v1";

class ApiService{
  var client = http.Client();


  Future<dynamic> update_profile({required Uint8List img, required String api}) async {
    String token2 = Get.find<UserController>().token;
    print("Token in api get: $token2");
    final url = Uri.parse((baseUrl + api));

    Map<String, dynamic> body = {
      'profilePicture': img,
    };


    try {
      final response = await http.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token2',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print('Changed succesfully');
        return 'sucess';

      } else {
        print('Failed to update: ${response.body}');
        return "failed";
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }


  Future<dynamic> get({required String api}) async {
    String token2 = Get.find<UserController>().token;
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

      if (response.statusCode == 200) {
        print('response ${response.body}');
        return jsonDecode(response.body);
      } else {
        //print('Error: ${response.body}');
        return {"status": "failed"};  // Returning a consistent response format
      }
    } catch (e) {
      print('Error occurred: $e');
      return {"status": "error", "message": e.toString()};  // Return an error object
    }
  }

  Future<dynamic> getListing({required String api}) async {
    String token2 = Get.find<UserController>().token;
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

      if (response.statusCode == 200) {
        print('response ${response.body}');
        return jsonDecode(response.body);
      } else {
        //print('Error: ${response.body}');
        return {"status": "failed"};  // Returning a consistent response format
      }
    } catch (e) {
      print('Error occurred: $e');
      return {"status": "error", "message": e.toString()};  // Return an error object
    }
  }

  Future<dynamic> login({required String email, required String password, required String api}) async{
    final url = Uri.parse((baseUrl+api));

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('User login successfully');
        return jsonDecode(response.body)['token'];

      } else {
        print('Failed to register user: ${response.body}');
        return "failed";
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<dynamic> registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required Uint8List profilePicture,
    required String verification,
    required String api,
  }) async {
    final url = Uri.parse(baseUrl + api);

    // Encode the profile picture as a base64 string
    String profilePictureBase64 = base64Encode(profilePicture);

    // Create the request body as per your backend payload structure
    Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePictureBase64,
      'verificationCode': verification,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // Handle successful response
        print('User registered successfully');
        return "success";
      } else {
        // Handle errors (e.g., 400, 500, etc.)
        print('Failed to register user: ${response.body}');
        return "error";
      }
    } catch (e) {
      print('Error occurred: $e');
      return "exception";
    }
  }


  Future<dynamic> addListing({
    required String destination,
    required double weight,
    required double price,
    required String currency,
    required String date,
    required String lastDate,
    required String additionalInfo,
    required api
  }) async {
    final url = Uri.parse((baseUrl+api));
    String token2 = Get.find<UserController>().token;
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

      if (response.statusCode == 201) {
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



  Future<dynamic> forgotPw({
    required String email,
    required api
  }) async {
    final url = Uri.parse((baseUrl+api));
    // Create the request body as per your payload struct
    Map<String, String> body = {
      'email': email,
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        return "success";
      } else {
        // Handle errors, e.g. 400, 500, etc.
        print('Failed to get code: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<dynamic> otpCode({
    required String email,
    required api
  }) async {
    final url = Uri.parse((baseUrl+api));
    // Create the request body as per your payload struct
    Map<String, String> body = {
      'email': email,
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        // Handle successful response
        return "success";
      } else {
        // Handle errors, e.g. 400, 500, etc.
        print('Failed to get code: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

}



  Future<dynamic> put(String api) async{

  }

  Future<dynamic> delete(String api) async{

  }
