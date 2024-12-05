import 'dart:typed_data';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';
import 'package:jim/src/auth/secure_storage.dart';

Future<dynamic> login(
    {required String email,
    required String password,
    required String fcmToken,
    required String api}) async {
  Map<String, dynamic> body = {
    'email': email,
    'password': password,
    'fcmToken': fcmToken
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
    Uint8List? profilePicture,
    required String verification,
    required String fcmToken,
    required String api}) async {
      // TODO: check this one
  // Encode the profile picture as a base64 string
  // String profilePictureBase64 = '';

  // if (profilePicture != null) {
  //   profilePictureBase64 = base64Encode(profilePicture);
  // }

  // Create the request body as per your backend payload structure
  Map<String, dynamic> body = {
    'name': name,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'profilePicture': profilePicture,
    'verificationCode': verification,
    'fcmToken': fcmToken
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

Future<dynamic> resetPassword({required String email, required String newPassword, required String api}) async {
  Map<String, String> body = {
    'email': email,
    'newPassword': newPassword,
  };

  try {
    final response = await dio.patch(baseUrl + api, data: body);

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

Future<dynamic> updatePassword({required String oldPassword, required String newPassword, required String api}) async {
  Map<String, String> body = {
    'oldPassword': oldPassword,
    'newPassword': newPassword,
  };

  try {
    final response = await dio.patch(baseUrl + api, data: body);

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

Future<dynamic> updateProfilePicture(
    {Uint8List? img, required String api}) async {
  Map<String, dynamic> body = {
    'profilePicture': img
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

dynamic autoLogin({required String api}) async {
  String refreshToken = await StorageService.getRefreshToken();
  String fcmToken = await StorageService.getFcmToken();

  Map<String, dynamic> body = {
    "refreshToken": refreshToken,
    "fcmToken": fcmToken
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

Future<dynamic> verifyVerificationCode(
    {required String email, required String verificationCode, required String api}) async {
  Map<String, String> body = {
    'email': email,
    'verificationCode': verificationCode
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

Future<dynamic> updateProfile(
    {required String name, required String phoneNumber, required String api}) async {
  Map<String, String> body = {
    'name': name,
    'phoneNumber': phoneNumber
  };

  try {
    final response = await dio.patch(baseUrl + api, data: body);

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

