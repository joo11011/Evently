import 'package:evently/data/web_services/auth_service.dart';
import 'package:evently/data/web_services/app_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AppAuth extends Cubit<AppAuthState> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  AppAuth() : super(AppAuthInitial());

  Future<void> createAccount() async {
    if (formKey.currentState!.validate()) {
      emit(AppAuthLoading());
      try {
        var res = await AuthService.createAccount(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
        );
        if (res != null) {
          emit(AppAuthSuccess(res));
        } else {
          emit(AppAuthError("Registration Failed"));
        }
      } catch (e) {
        emit(AppAuthError(e.toString()));
      }
    }
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(AppAuthLoading());
      try {
        var res = await AuthService.login(
          email: emailController.text,
          password: passwordController.text,
        );

        if (res != null) {
          if (res.user?.emailVerified == true) {
            emit(AppAuthSuccess(res));
          } else {
            emit(AppAuthError("Please Verify Your Email"));
          }
        } else {
          emit(AppAuthError('Incorrect email or password'));
        }
      } catch (e) {
        emit(AppAuthError(e.toString()));
      }
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AppAuthLoading());
    try {
      var res = await AuthService.signInWithGoogle();
      if (res != null) {
        emit(AppAuthSuccess(res));
      } else {
        emit(AppAuthError('Google Sign-In Cancelled'));
      }
    } catch (e) {
      emit(AppAuthError('Google Sign-In Failed : ${e.toString()}'));
    }
  }

  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      emit(AppAuthLoading());
      try {
        await AuthService.resetPassword(email: emailController.text);
        emit(AppAuthResetSent("Reset Password Link Sent"));
      } catch (e) {
        emit(AppAuthError(e.toString()));
      }
    }
  }
}
