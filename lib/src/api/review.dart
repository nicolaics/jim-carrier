import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';
import 'package:jim/src/flutter_storage.dart';

Future<dynamic> createReview(
    {required int orderId,
    required String reviewName,
    required String? reviewContent,
    required int rating,
    required String api}) async {
  String? token2 = await StorageService.getAccessToken();
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
      return jsonDecode(response.body)['access_token'];
    } else {
      print('Failed to review: ${response.body}');
      return "failed";
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
