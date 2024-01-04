import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/home/home_screen.dart';
import 'package:my_smartstore/registration/authentication/auth_cubit.dart';
import 'package:my_smartstore/registration/forgot_password/forgot_password_cubit.dart';
import 'package:my_smartstore/registration/login/login_cubit.dart';

import '../../constants.dart';
import '../forgot_password/forgot_password_screen.dart';
import 'login_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();
  late String email_phone, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    print(state.token + "token");
                    BlocProvider.of<AuthCubit>(context).loggedIN(state.token);
                    Navigator.pop(context);
                  }
                  if (state is LoginFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      _emailPhoneField(
                        state is! LoginSubmitting,
                        (state is LoginFailed)
                            ? state.message == "Incorrect password"
                                ? null
                                : state.message
                            : null,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      _passwordField(
                        state is! LoginSubmitting,
                        (state is LoginFailed)
                            ? state.message == "Incorrect password"
                                ? null
                                : state.message
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: state is LoginSubmitting
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BlocProvider<ForgotPasswordCubit>(
                                        create: (_) => ForgotPasswordCubit(),
                                        child: ForgotPasswordScreen(),
                                      ),
                                    ),
                                  );
                                },
                          child: Text(
                            "Forgot Password?",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      if (state is LoginSubmitting)
                        const CircularProgressIndicator(),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          fixedSize: MaterialStateProperty.all(
                            const Size(
                              double.maxFinite,
                              60,
                            ),
                          ),
                        ),
                        onPressed: (state is LoginSubmitting)
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<LoginCubit>(context).login(
                                    email_phone,
                                    password,
                                  );
                                }
                              },
                        child: const Text("Login"),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Don't have an account? Sign Up!"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailPhoneField(enableForm, error) {
    return TextFormField(
      enabled: enableForm,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: ERROR_BORDER,
        errorText: error,
        errorStyle: const TextStyle(
          height: 1,
        ),
        hintText: "Email or Phone no.",
        labelText: "Enter your email or phone no.",
        suffixIcon: const Icon(Icons.account_circle),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        if (value.length < 4) {
          return "Invalid Credntials!";
        }
        email_phone = value;
      },
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  Widget _passwordField(enableForm, error) {
    return TextFormField(
      enabled: enableForm,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: ENABLED_BORDER,
        focusedBorder: FOCUSED_BORDER,
        errorBorder: ERROR_BORDER,
        focusedErrorBorder: ERROR_BORDER,
        errorText: error,
        errorStyle: const TextStyle(
          height: 1,
        ),
        hintText: "Password",
        labelText: "Password",
        suffixIcon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Required!";
        }
        if (value.length < 8) {
          return "Invalid Credntials!";
        }
        password = value;
      },
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }
}
