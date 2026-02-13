import 'package:evently/core/app_localizations.dart';
import 'package:evently/features/cubit/App_Cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension AppExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  AppCubit get appCubit => BlocProvider.of<AppCubit>(this);

  AppLocalizations get locale => AppLocalizations.of(this)!;
}
