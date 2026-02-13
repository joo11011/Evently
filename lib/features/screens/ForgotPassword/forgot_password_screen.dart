import 'package:evently/core/constants/app_dialogs.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/features/cubit/App_Cubit.dart';
import 'package:evently/data/web_services/app_auth.dart';
import 'package:evently/data/web_services/app_auth_state.dart';
import 'package:evently/core/widgets/custom_button.dart';
import 'package:evently/core/widgets/text_form_field.dart';
import 'package:evently/features/widget/cupertino_btn.dart';
import 'package:evently/features/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return BlocProvider(
      create: (context) => AppAuth(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(top: 15, left: 30),
                child: Text(
                  context.locale.forgetPassword,
                  style: TextStyle(fontSize: 25, color: AppColors.purple),
                ),
              ),
            ),
            body: SafeArea(
              child: BlocConsumer<AppAuth, AppAuthState>(
                listener: (context, state) {
                  if (state is AppAuthError) {
                    AppDialogs.showMessage(
                      context,
                      state.message,
                      type: DialogType.error,
                    );
                  } else if (state is AppAuthResetSent) {
                    AppDialogs.showMessage(
                      context,
                      state.message,
                      type: DialogType.success,
                    );
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  final authCubit = context.read<AppAuth>();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: authCubit.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Image.asset(
                            'assets/images/forgetPasswordIMG.png',
                            width: 350,
                            height: 350,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          TextFieldwidget(
                            label: context.locale.email,
                            icon: Icon(Icons.email),
                            controller: authCubit.emailController,
                            validator: (String? p1) {
                              if (p1 == null || p1.isEmpty) {
                                return context.locale.pleaseEnterEmail;
                              }
                              if (!emailRegex.hasMatch(p1)) {
                                return context.locale.pleaseEnterValidEmail;
                              }
                              return null;
                            },
                            style: null,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Cupertinobtn(
                            BTNName: context.locale.resetPasswordButton,
                            isLoading: state is AppAuthLoading,
                            onPressed: () {
                              authCubit.resetPassword();
                            },
                            isExpanded: true,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
