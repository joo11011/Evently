import 'package:animate_do/animate_do.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/features/cubit/App_Cubit.dart';
import 'package:evently/features/widget/cupertino_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = context.appCubit;
        return Scaffold(
          backgroundColor: context.theme.brightness == Brightness.dark
              ? AppColors.darkPurple
              : Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'SplashLogo',
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 48,
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 10),
                        Material(
                          color: Colors.transparent,
                          child: Hero(
                            tag: 'appname',
                            child: Text(
                              context.locale.logo,
                              style: context.textTheme.headlineLarge?.copyWith(
                                color: AppColors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FadeIn(
                      delay: Duration(seconds: 2),
                      duration: Duration(seconds: 1),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Image.asset(
                              'assets/images/light_Image1.png',
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            context.locale.onBoardingTitle1,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Expanded(
                            child: Text(
                              context.locale.onBoardingDesc1,
                              style: context.textTheme.bodySmall?.copyWith(
                                color:
                                    context.theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.locale.language,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.purple,
                                    fontSize: 18,
                                  ),
                                ),
                                AnimatedToggleSwitch<String>.rolling(
                                  current: state.locale.languageCode,
                                  values: ['en', 'ar'],
                                  onChanged: (value) {
                                    cubit.changeAppLanguage(value);
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
                          SizedBox(height: 10),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.locale.theme,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.purple,
                                    fontSize: 18,
                                  ),
                                ),
                                AnimatedToggleSwitch<ThemeMode>.rolling(
                                  textDirection: TextDirection.ltr,
                                  current: state.themeMode,
                                  values: [ThemeMode.light, ThemeMode.dark],
                                  onChanged: (value) {
                                    cubit.changeAppTheme(value);
                                  },
                                  iconList: [
                                    Image.asset('assets/icons/light.png'),
                                    Image.asset(
                                      'assets/icons/dark.png',
                                      color: state.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : null,
                                    ),
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
                          SizedBox(height: 15),
                          Cupertinobtn(
                            BTNName: context.locale.startButton,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppStrings.onBoarding,
                              );
                            },
                            isExpanded: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
