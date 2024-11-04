import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
const baseUrl ="http://ion-suhalim:9988/api/v1";

class ApiService{
  var client = http.Client();


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
        //return jsonDecode(response.body)['token'];

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
    required api
  }) async {
    final url = Uri.parse((baseUrl+api));

    // Create the request body as per your payload struct
    Map<String, String> body = {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
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
        // Handle errors, e.g. 400, 500, etc.
        print('Failed to register user: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
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
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHBpcmVkQXQiOjE3MzAwNTI3MTgsInRva2VuVXVpZCI6IjAxOTJjYzlhLTUzNzMtNzcyNy04OWFkLTQ4NjU1YjFjODYwZSIsInVzZXJJZCI6Mn0.bP30cVY9zKeNXIDRCnr2Wf6RW-KuNFt-_oMN2WLFF3w'
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
