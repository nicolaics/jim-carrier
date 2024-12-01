import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';
import 'package:jim/src/flutter_storage.dart';

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
