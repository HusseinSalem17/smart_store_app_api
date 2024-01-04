import 'package:dio/dio.dart';

import '../../constants.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<Response> getUserData({required String token}) async {
    final response = await _dio.get(
      "$BASE_URL/userdata/",
      options: Options(
        headers: {"authorization": "Bearer $token"},
      ),
    );
    print('responsssssssse: ${response.statusCode}');
    return response;
  }
}
