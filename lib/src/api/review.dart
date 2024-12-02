import 'package:dio/dio.dart';
import 'package:http_status/http_status.dart';
import 'package:jim/src/api/api_service.dart';

Future<dynamic> createReview(
    {required int orderId,
    required String reviewName,
    required String? reviewContent,
    required int rating,
    required String api}) async {
  Map<String, dynamic> body = {
    'orderId': orderId,
    'revieweeName': reviewName,
    'content': reviewContent,
    'rating': rating,
  };

  try {
    final response = await dio.post(
      (baseUrl + api),
      data: body
    );

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
