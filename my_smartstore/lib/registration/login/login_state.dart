abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSubmitting extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  LoginSuccess({required this.token});
}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed({required this.message});
}
