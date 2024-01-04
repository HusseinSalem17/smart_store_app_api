import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

class ForgotPasswordRepository {
  final Dio dio = Dio();

  Future<Response> resetPassword(
    email,
  ) async {
    final response = await dio.post(
      '$BASE_URL/password_reset_email/',
      data: {
        'email': email,
      },
    );
    return response;
  }
}
