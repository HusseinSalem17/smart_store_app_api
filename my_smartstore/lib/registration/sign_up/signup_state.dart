abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpSubmiting extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailed extends SignUpState {
  final String message;

  SignUpFailed({required this.message});
}
