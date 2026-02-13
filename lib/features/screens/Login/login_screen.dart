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
import 'package:evently/features/widget/elevated_btn.dart';
import 'package:evently/features/widget/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // email regex for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return BlocProvider(
      create: (context) => AppAuth(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: SingleChildScrollView(
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
                              'Login Success',
                              type: DialogType.success,
                            );
                            Navigator.pushReplacementNamed(
                              context,
                              AppStrings.layout,
                            );
                          }
                        },
                        builder: (context, state) {
                          final authCubit = BlocProvider.of<AppAuth>(context);
                          return Form(
                            key: authCubit.formKey,
                            child: Column(
                              children: [
                                TextFieldwidget(
                                  label: context.locale.emailTextField,
                                  style: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  icon: Icon(Icons.email),
                                  controller: authCubit.emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter valid email';
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
                                  controller: authCubit.passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppStrings.forgotPassword,
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      context.locale.forgotPasswordTextField,
                                      style: context.textTheme.bodyLarge!
                                          .copyWith(color: AppColors.purple),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                Cupertinobtn(
                                  BTNName: context.locale.loginButton,
                                  isLoading: state is AppAuthLoading,
                                  onPressed: () {
                                    authCubit.login();
                                  },
                                  isExpanded: true,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: context.locale.loginText1,
                                    style: context.textTheme.bodyMedium,
                                    children: [
                                      TextSpan(
                                        text:
                                            context.locale.createAccountButton,
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(color: AppColors.purple),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                              context,
                                              AppStrings.register,
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        indent: 26,
                                        color: AppColors.purple,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Text(
                                        context.locale.or,
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(color: AppColors.purple),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        endIndent: 26,
                                        color: AppColors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                Elevatedbtn(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/google.png',
                                        width: 25,
                                        height: 25,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.error),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        context.locale.googleButton,
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    authCubit.signInWithGoogle();
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),

                                AnimatedToggleSwitch<String>.rolling(
                                  current: context
                                      .appCubit
                                      .state
                                      .locale
                                      .languageCode,
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
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
