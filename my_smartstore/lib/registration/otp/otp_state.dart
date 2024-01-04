abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpVerifing extends OtpState {}

class OtpVerified extends OtpState {
  final String token;

  OtpVerified({required this.token});
}

class OtpVerificationFailed extends OtpState {
  final String message;

  OtpVerificationFailed({required this.message});
}
