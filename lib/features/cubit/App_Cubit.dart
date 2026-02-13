import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppState {
  final ThemeMode themeMode;
  final Locale locale;

  AppState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
  });

  AppState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState());

  void changeAppTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void changeAppLanguage(String langCode) {
    emit(state.copyWith(locale: Locale(langCode)));
  }
}
