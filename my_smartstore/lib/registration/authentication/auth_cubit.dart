import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_smartstore/registration/authentication/auth_repository.dart';

import '../../models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static String token = "";
  final AuthRepository authRepository;
  final FlutterSecureStorage storage;
  AuthCubit({required this.storage, required this.authRepository})
      : super(AuthInitial());

  Future<AuthState> authenticate() async {
    AuthState newState;
    if (token.isEmpty) {
      try {
        var tokenValue = await _getToken();
        if (tokenValue == null) {
          print('token0: $tokenValue');
          newState = LoggedOut();
          emit(newState);
        } else {
          token = tokenValue;
          print('token: $tokenValue');
          newState = await _fetchUserData();
        }
      } catch (e) {
        print('token1: $token');
        print(e);
        newState = LoggedOut();
        emit(newState);
      }
    } else {
      newState = await _fetchUserData();
    }
    return newState;
  }

  void loggedIN(String tokenValue) {
    emit(Authenticating());
    token = tokenValue;
    print('token2: $token');
    _setToken(token).then((value) {
      _fetchUserData();
    });
  }

  Future<AuthState> _fetchUserData() async {
    AuthState newState;
    try {
      print('HERRREEEEE');
      var response = await authRepository.getUserData(token: token);
      print('response: ${response.data}');
      newState = Authenticated(userdata: UserModel.fromJson(response.data));
      emit(newState);
    } catch (e) {
      DioException error = e as DioException;
      print('errorrr: ${error.message}');
      if (error.response != null) {
        newState = await removeToken();
      } else {
        if (error.type == DioErrorType.connectionError) {
          newState = AuthenticationFailed(message: "Connection Timeout");
          emit(newState);
        } else {
          newState = AuthenticationFailed(message: error.message!);
          emit(newState);
        }
      }
    }
    return newState;
  }

  Future<AuthState> removeToken() async {
    AuthState newState;
    try {
      await _deleteToken();
    } catch (e) {
      // nothing to do
    }
    newState = LoggedOut();
    emit(newState);
    return newState;
  }

  Future<void> _setToken(token) async {
    print('token5: $token');
    await storage.write(key: "token", value: token);
  }

  Future<String?> _getToken() async {
    String? value = await storage.read(key: "token");
    print('token4: $value');
    return value;
  }

  Future<void> _deleteToken() async {
    print('token6: $token');
    await storage.delete(key: "token");
  }
}
