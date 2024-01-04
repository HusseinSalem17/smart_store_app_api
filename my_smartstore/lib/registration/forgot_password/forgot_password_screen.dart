import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_smartstore/registration/forgot_password/forgot_password_cubit.dart';
import 'package:my_smartstore/registration/forgot_password/forgot_password_state.dart';

import '../../constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  late String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordFailed) {
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
                        state is ForgotPasswordSuccess
                            ? 'assets/images/inbox.png'
                            : 'assets/images/forgot_password.png',
                        height: 100,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        state is ForgotPasswordSuccess
                            ? 'Check your inbox'
                            : 'Forgot Password?',
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(state is ForgotPasswordSuccess
                          ? 'Password reset email has been sent successfully to your registered email address, so please check your inbox to set your new password.'
                          : "Don't worry we just need your registered email address and its done."),
                      const SizedBox(
                        height: 48,
                      ),
                      _emailField(
                        (state is! ForgotPasswordSubmitting) &&
                            (state is! ForgotPasswordSuccess),
                        state is ForgotPasswordFailed ? state.message : null,
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      if (state is ForgotPasswordSubmitting)
                        const CircularProgressIndicator(),
                      const SizedBox(
                        height: 48,
                      ),
                      if (state is! ForgotPasswordSuccess)
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
                          onPressed: (state is ForgotPasswordSubmitting)
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<ForgotPasswordCubit>(
                                            context)
                                        .resetPassword(
                                      _email,
                                    );
                                  }
                                },
                          child: const Text("Reset Password"),
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

  Widget _emailField(enableForm, error) {
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
        hintText: "Enter your registered Email Address",
        labelText: "Email Address",
        suffixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (!RegExp(EMAIL_REGEX).hasMatch(value!)) {
          return "Please enter a valid email";
        }
        _email = value;
      },
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}
