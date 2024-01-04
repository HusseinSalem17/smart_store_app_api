import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'otp_repository.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());
  OptRepository _repository = OptRepository();
  void verifyOtp({
    required String email,
    required String name,
    required String password,
    required String phone,
    required String otp,
  }) async {
    emit(OtpVerifing());
    _repository.verifyOtp(phone, otp).then(
      (response) {
        _createAccount(
          email: email,
          phone: phone,
          name: name,
          password: password,
        );
      },
    ).catchError(
      (value) {
        DioError error = value;
        if (error.response != null) {
          emit(OtpVerificationFailed(message: error.response!.data));
        } else {
          if (error.type == DioErrorType.badResponse) {
            emit(OtpVerificationFailed(
                message: "Please check your internet connection!"));
          } else {
            emit(OtpVerificationFailed(message: error.message!));
          }
        }
      },
    );
  }

  void _createAccount({
    required String email,
    required String phone,
    required String name,
    required String password,
  }) async {
    emit(OtpVerifing());
    _repository
        .createAccount(
      email: email,
      phone: phone,
      name: name,
      password: password,
    )
        .then(
      (response) {
        emit(OtpVerified(token: response.data['token']));
      },
    ).catchError(
      (value) {
        DioError error = value;
        if (error.response != null) {
          emit(OtpVerificationFailed(message: error.response!.data));
        } else {
          if (error.type == DioErrorType.badResponse) {
            emit(OtpVerificationFailed(
                message: "Please check your internet connection!"));
          } else {
            emit(OtpVerificationFailed(message: error.message!));
          }
        }
      },
    );
  }

  void resendOtp(phone) {
    _repository.resendOtp(phone);
  }
}
