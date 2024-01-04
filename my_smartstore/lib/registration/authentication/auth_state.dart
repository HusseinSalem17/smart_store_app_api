import 'package:my_smartstore/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {
  final UserModel userdata;
  Authenticated({required this.userdata});
}

class AuthenticationFailed extends AuthState {
  String message;
  AuthenticationFailed({required this.message});
}

class LoggedOut extends AuthState {}
