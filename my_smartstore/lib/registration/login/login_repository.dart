import 'package:dio/dio.dart';
import 'package:my_smartstore/constants.dart';

class LoginRepository {
  final Dio dio = Dio();

  Future<Response> login(email, phone, password) async {
    final response = await dio.post(
      '$BASE_URL/login/',
      data: {
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    print(response.statusCode);
    print(response.data);
    return response;
  }
}
