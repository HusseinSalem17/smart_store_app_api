import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_smartstore/home/fragments/home_fragment/home_fragment_cubit.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';
import 'package:my_smartstore/registration/authentication/auth_repository.dart';
import 'package:my_smartstore/registration/authentication/auth_state.dart';
import 'package:my_smartstore/registration/authentication/authenticating_screen.dart';
import 'package:my_smartstore/registration/sign_up/signup_cubit.dart';
import 'package:my_smartstore/registration/sign_up/signup_screen.dart';

import 'constants.dart';
import 'home/home_screen.dart';

const storage = FlutterSecureStorage();
final AuthRepository authRepository = AuthRepository();
final AuthCubit authCubit = AuthCubit(
  storage: storage,
  authRepository: authRepository,
);

void main() async {
  // This is to ensure that the app is initialized before the runApp() method is called
  WidgetsFlutterBinding.ensureInitialized();
  if (authCubit.state is AuthInitial) {
    await authCubit.authenticate();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => authCubit,
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            //primaryswatch is a color that is used by many widgets
            primarySwatch: PRIMARY_SWATCH,
          ),
          home: state is Authenticated
              ? MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => HomeFragmentCubit()),
                  ],
                  child: HomeScreen(),
                )
              : state is AuthenticationFailed || state is Authenticating
                  ? const AuthenticatingScreen()
                  : BlocProvider<SignUpCubit>(
                      create: (_) => SignUpCubit(),
                      child: SignUpScreen(),
                    ),
        );
      }),
    );
  }
}
