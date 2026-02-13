import 'package:animate_do/animate_do.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently/core/constants/app_dialogs.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/features/cubit/App_Cubit.dart';
import 'package:evently/data/web_services/app_auth.dart';
import 'package:evently/data/web_services/app_auth_state.dart';
import 'package:evently/features/widget/cupertino_btn.dart';
import 'package:evently/features/widget/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppAuth(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 10, left: 80),
              child: Text(
                context.locale.registerText2,
                style: TextStyle(fontSize: 25, color: AppColors.purple),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideInDown(
                        duration: Duration(seconds: 1),
                        child: Hero(
                          tag: 'SplashLogo',
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 135,
                            height: 140,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      SlideInUp(
                        duration: Duration(seconds: 1),
                        child: Hero(
                          tag: 'appname',
                          child: Text(
                            'Evently',
                            style: context.textTheme.headlineLarge!.copyWith(
                              color: AppColors.purple,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      BlocConsumer<AppAuth, AppAuthState>(
                        listener: (context, state) {
                          if (state is AppAuthError) {
                            AppDialogs.showMessage(
                              context,
                              state.message,
                              type: DialogType.error,
                            );
                          } else if (state is AppAuthSuccess) {
                            AppDialogs.showMessage(
                              context,
                              'Account Created Successfully , Please Login',
                              type: DialogType.success,
                            );
                            Navigator.pushNamed(context, AppStrings.login);
                          }
                        },

                        builder: (context, state) => Form(
                          key: context.read<AppAuth>().formKey,
                          child: Column(
                            children: [
                              TextFieldwidget(
                                label: context.locale.nameTextField,
                                style: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(Icons.person),
                                controller: context
                                    .read<AppAuth>()
                                    .nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              TextFieldwidget(
                                label: context.locale.emailTextField,
                                style: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(Icons.email),
                                controller: context
                                    .read<AppAuth>()
                                    .emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  if (!value.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              TextFieldwidget(
                                label: context.locale.passwordTextField,
                                style: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(Icons.lock),
                                isPassword: true,
                                controller: context
                                    .read<AppAuth>()
                                    .passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (!value.contains(RegExp(r'[0-9]'))) {
                                    return 'Password must contain at least one number';
                                  }
                                  if (!value.contains(RegExp(r'[A-Z]'))) {
                                    return 'Password must contain at least one uppercase letter';
                                  }
                                  if (!value.contains(RegExp(r'[a-z]'))) {
                                    return 'Password must contain at least one lowercase letter';
                                  }
                                  if (!value.contains(RegExp(r'[!@#$%^&*]'))) {
                                    return 'Password must contain at least one special character';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters long';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              TextFieldwidget(
                                label: context.locale.confirmPasswordTextField,
                                style: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(Icons.lock),
                                isPassword: true,
                                controller: context
                                    .read<AppAuth>()
                                    .confirmPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value !=
                                      context
                                          .read<AppAuth>()
                                          .passwordController
                                          .text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Cupertinobtn(
                                BTNName: context.locale.createAccountButton,
                                isExpanded: true,
                                isLoading: state is AppAuthLoading,
                                onPressed: () {
                                  context.read<AppAuth>().createAccount();
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: context.locale.registerText1,
                                  style: context.textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: context.locale.loginButton,
                                      style: context.textTheme.bodyLarge!
                                          .copyWith(color: AppColors.purple),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(
                                            context,
                                            AppStrings.login,
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              AnimatedToggleSwitch<String>.rolling(
                                current:
                                    context.appCubit.state.locale.languageCode,
                                values: ['en', 'ar'],
                                onChanged: (value) {
                                  context.appCubit.changeAppLanguage(value);
                                },
                                iconList: [
                                  Image.asset('assets/icons/en.png'),
                                  Image.asset('assets/icons/ar.png'),
                                ],
                                style: ToggleStyle(
                                  backgroundColor: Colors.transparent,
                                  borderColor: AppColors.purple,
                                  indicatorColor: AppColors.purple,
                                ),
                                indicatorIconScale: 0.7,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
