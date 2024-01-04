import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:my_smartstore/registration/forgot_password/forgot_password_repository.dart';

import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  void resetPassword(email) async {
    emit(ForgotPasswordSubmitting());
    _repository
        .resetPassword(email)
        .then(
          (response) => emit(ForgotPasswordSuccess()),
        )
        .catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ForgotPasswordFailed(message: error.response!.data));
        } catch (e) {
          emit(ForgotPasswordFailed(message: error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.badResponse) {
          emit(ForgotPasswordFailed(
              message: "Please check your internet connection!"));
        } else {
          emit(ForgotPasswordFailed(message: error.message!));
        }
      }
    });
  }
}
