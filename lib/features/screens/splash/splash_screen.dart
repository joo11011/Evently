import 'package:animate_do/animate_do.dart';
import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/core/Extension.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
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
              onFinish: (direction) {
                Future.delayed(Duration(seconds: 2), () {
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, AppStrings.intro);
                  }
                });
              },
              child: Hero(
                tag: 'appname',
                child: Text(
                  'Evently',
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
    );
  }
}
