import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:jim/src/flutter_storage.dart';
import 'dart:convert';

const baseUrl = "http://ion-suhalim:9988/api/v1";
//const baseUrl = "http://pravass-macbook-air:9988/api/v1";

class ApiService {
  var client = http.Client();

  Future<dynamic> updateProfile(
      {required Uint8List img, required String api}) async {
    String? token2 = await StorageService.getToken();
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

  Future<dynamic> review(
      {required int orderId,
      required String reviewName,
      required String? reviewContent,
      required int rating,
      required String api}) async {
    String? token2 = await StorageService.getToken();
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
}
