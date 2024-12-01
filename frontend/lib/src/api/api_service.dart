import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:jim/src/flutter_storage.dart';
import 'dart:convert';

// const baseUrl = "http://43.202.104.248:9988/api/v1";
const baseUrl = "http://ion-suhalim:9988/api/v1";
//const baseUrl = "http://pravass-macbook-air:9988/api/v1";

class ApiService {
  var client = http.Client();

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


}
