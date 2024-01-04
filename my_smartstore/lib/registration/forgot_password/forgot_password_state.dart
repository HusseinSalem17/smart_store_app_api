abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordSubmitting extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordFailed extends ForgotPasswordState {
  final String message;

  ForgotPasswordFailed({required this.message});
}
