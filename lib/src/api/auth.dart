import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';
import 'package:jim/src/flutter_storage.dart';

Future<dynamic> getBankDetails({required int carrierID, required api}) async {
  print("inside");
  print(carrierID);
  final url = Uri.parse((baseUrl + api));
  String? token = await StorageService.getAccessToken();

  Map<String, int> body = {
    'carrierId': carrierID,
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
      if (jsonDecode(response.body)['status'] == 'exist') {
        return {"status": "success", "response": jsonDecode(response.body)};
      } else {
        return {"status": "error", "response": jsonDecode(response.body)};
      }
    } else {
      if (jsonDecode(response.body)['error'].contains("access token expired")) {
        return {
          "status": "error",
          "response": "access token expired"
        }; // Returning a consistent response format
      }
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> login(
    {required String email,
    required String password,
    required String fcmToken,
    required String api}) async {
  final url = Uri.parse((baseUrl + api));
  
  Map<String, String> body = {
    'email': email,
    'password': password,
    'fcmToken': fcmToken,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      return {
        "status": "success",
        "response": jsonDecode(response.body)
        };
    } else {
      return {
        "status": "error",
        "response": jsonDecode(response.body)['error']
        };
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> registerUser(
    {required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required Uint8List profilePicture,
    required String verification,
    required String fcmToken,
    required String api}) async {
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
    'fcmToken': fcmToken,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode.isSuccessfulHttpStatusCode) {
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

Future<dynamic> logout({required api}) async {
  final url = Uri.parse((baseUrl + api));
  String? token = await StorageService.getAccessToken();

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode.isSuccessfulHttpStatusCode) {
      // Handle successful response
      return "logged out";
    } else {
      // Handle errors, e.g. 400, 500, etc.
      print('Failed to get code: ${response.body}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> forgotPassword({required String email, required api}) async {
  final url = Uri.parse((baseUrl + api));
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

    if (response.statusCode.isSuccessfulHttpStatusCode) {
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

Future<dynamic> loginWithGoogle(
    {required Map userInfo, required String api}) async {
  final url = Uri.parse((baseUrl + api));

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userInfo),
    );

    dynamic responseDecode = jsonDecode(response.body);

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      return {"status": "success", "response": responseDecode};
    } else {
      if (responseDecode['error'].contains("to registration")) {
        return {"status": "error", "response": "toRegist"};
      }

      return {"status": "error", "response": responseDecode['error']};
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> registerWithGoogle(
    {required Map userInfo, required String api}) async {
  final url = Uri.parse((baseUrl + api));

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userInfo),
    );

    dynamic responseDecode = jsonDecode(response.body);

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      return {"status": "success", "response": responseDecode};
    } else {
      return {"status": "error", "response": responseDecode['error']};
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<dynamic> requestVerificationCode(
    {required String email, required api}) async {
  final url = Uri.parse((baseUrl + api));
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
    if (response.statusCode.isSuccessfulHttpStatusCode) {
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
