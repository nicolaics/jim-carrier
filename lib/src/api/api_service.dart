import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jim/src/auth/secure_storage.dart';
import 'package:dio/dio.dart';

final baseUrl = dotenv.env['BASE_URL'] ?? 'http://ion-suhalim:9988/api/v1';

Map<String, dynamic> writeSuccessResponse({required dynamic response}) {
  return {"status": "success", "message": response.data};
}

Map<String, dynamic> writeErrorResponse({required dynamic response}) {
  print("response data: ${response.data}");
  return {"status": "error", "message": response.data['error']};
}

Map<String, String> writeToRegistResponse() {
  return {"status": "registration", "message": "toRegist"};
}

final Dio dio = Dio();

void setupInterceptors() {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final accessToken = await StorageService.getAccessToken();
      print("INTERCEPTED!!! Access Token: $accessToken");
      
      if (accessToken != "") {
        options.headers["Authorization"] = "Bearer $accessToken";
        options.headers["Content-Type"] = "application/json";
      }
      
      handler.next(options); // Continue with the request
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401 && error.response?.data['error'].contains("access token expired")) {
        final refreshed = await _refreshToken();

        if (refreshed) {
          // Retry the original request with the new token
          final options = error.requestOptions;
          final retryResponse = await dio.request(
            options.path,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
            data: options.data,
            queryParameters: options.queryParameters,
          );
          handler.resolve(retryResponse); // Return the retried response
        } else {
          handler.next(error); // Pass the error forward if refresh fails
        }
      } else {
        handler.next(error); // Forward other errors
      }
    },
  ));
}

Future<bool> _refreshToken() async {
  try {
    final refreshToken = await StorageService.getRefreshToken();
    if (refreshToken == "") {
      return false;
    }

    final response = await dio.post(
      "$baseUrl/user/refresh",
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200) {
      final newAccessToken = response.data['access_token'];
      await StorageService.storeAccessToken(newAccessToken);
      return true;
    }
  } catch (e) {
    print('Token refresh failed: $e');
  }
  return false;
}
