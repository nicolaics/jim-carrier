import 'dart:convert';
import 'dart:typed_data';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';

Future<dynamic> getBankDetails({required int carrierID, required api}) async {
  Map<String, int> body = {
    'carrierId': carrierID,
  };

  try {
    final response = await dio.post(baseUrl + api, data: body);

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
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> login(
    {required String email,
    required String password,
    required String fcmToken,
    required String api}) async {
  // final url = Uri.parse((baseUrl + api));

  Map<String, String> body = {
    'email': email,
    'password': password,
    'fcmToken': fcmToken,
  };

  try {
    final response = await dio.post((baseUrl + api), data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
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
    final response = await dio.post(baseUrl + api, data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> logout({required api}) async {
  try {
    final response = await dio.post(baseUrl + api);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> forgotPassword({required String email, required api}) async {
  Map<String, String> body = {
    'email': email,
  };

  try {
    final response = await dio.post(baseUrl + api, data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> loginWithGoogle(
    {required Map userInfo, required String api}) async {
  try {
    final response = await dio.post(baseUrl + api, data: userInfo);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      if (response.data['error'].contains("to registration")) {
        return writeToRegistResponse();
      }

      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> registerWithGoogle(
    {required Map userInfo, required String api}) async {
  try {
    final response = await dio.post(baseUrl + api, data: userInfo);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> requestVerificationCode(
    {required String email, required api}) async {
  Map<String, String> body = {
    'email': email,
  };

  try {
    final response = await dio.post(baseUrl + api, data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> getCurrentUser({required String api}) async {
  try {
    final response = await dio.get((baseUrl + api));

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

Future<dynamic> updateProfile(
    {required Uint8List img, required String api}) async {
  Map<String, dynamic> body = {
    'profilePicture': img,
  };

  try {
    final response = await dio.patch((baseUrl + api), data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}

dynamic autoLogin({required String refreshToken, required String api}) async {
  Map<String, String> body = {
    "refreshToken": refreshToken,
  };

  try {
    final response = await dio.post((baseUrl + api), data: body);

    if (response.statusCode!.isSuccessfulHttpStatusCode) {
      return writeSuccessResponse(response: response);
    } else {
      return writeErrorResponse(response: response);
    }
  } on DioException catch (e) {
    print('Error occurred: ${e.response?.data['error']}');
    return writeErrorResponse(response: e.response);
  }
}
