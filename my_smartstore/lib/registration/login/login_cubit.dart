import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:my_smartstore/registration/login/login_repository.dart';

import '../../constants.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository = LoginRepository();
  LoginCubit() : super(LoginInitial());

  void login(String email_phone, String password) async {
    String? email, phone;
    emit(LoginSubmitting());
    if (RegExp(EMAIL_REGEX).hasMatch(email_phone)) {
      email = email_phone;
    } else {
      phone = email_phone;
    }

    _loginRepository
        .login(email, phone, password)
        .then(
          (response) => emit(LoginSuccess(token: response.data['token'])),
        )
        .catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(LoginFailed(message: error.response!.data));
        } catch (e) {
          emit(LoginFailed(message: error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.badResponse) {
          emit(LoginFailed(message: "Please check your internet connection!"));
        } else {
          emit(LoginFailed(message: error.message!));
        }
      }
    });
  }
}
