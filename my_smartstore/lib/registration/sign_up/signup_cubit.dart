import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:my_smartstore/registration/sign_up/signup_repository.dart';
import 'package:my_smartstore/registration/sign_up/signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final SignUpRepository _repository = SignUpRepository();
  void requestOtp(email, phone) {
    emit(SignUpSubmiting());
    _repository
        .requestOtp(email, phone)
        .then(
          (value) => emit(SignUpSuccess()),
        )
        .catchError(
      (value) {
        DioError error = value;
        if (error.response != null) {
          emit(SignUpFailed(message: error.message!));
        } else {
          if (error.type == DioErrorType.badResponse) {
            emit(SignUpFailed(
                message: "Please check your internet connection!"));
          } else {
            emit(SignUpFailed(message: error.message!));
          }
        }
      },
    );
  }
}
