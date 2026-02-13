import 'package:firebase_auth/firebase_auth.dart';

abstract class AppAuthState {}

class AppAuthInitial extends AppAuthState {}

class AppAuthLoading extends AppAuthState {}

class AppAuthSuccess extends AppAuthState {
  final UserCredential userCredential;

  AppAuthSuccess(this.userCredential);
}

class AppAuthResetSent extends AppAuthState {
  final String message;
  AppAuthResetSent(this.message);
}

class AppAuthError extends AppAuthState {
  final String message;

  AppAuthError(this.message);
}
