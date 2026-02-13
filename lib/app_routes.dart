import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/data/model/event.dart';
import 'package:evently/features/screens/Event/Add_Event_Screen.dart';
import 'package:evently/features/screens/Event/Edit_Event_Screen.dart';
import 'package:evently/features/screens/Event/Event_Details_Screen.dart';
import 'package:evently/features/screens/ForgotPassword/forgot_password_screen.dart';
import 'package:evently/features/screens/Layout/Tabs/home_screen.dart';
import 'package:evently/features/screens/Layout/layout_screen.dart';
import 'package:evently/features/screens/Login/login_screen.dart';
import 'package:evently/features/screens/SignUp/sign_up.dart';
import 'package:evently/features/screens/splash/splash_screen.dart';
import 'package:evently/features/screens/onboarding/intro_screen.dart';
import 'package:evently/features/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppStrings.splash:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SplashScreen(),
        );
      case AppStrings.intro:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 3),
          pageBuilder: (context, animation, secondaryAnimation) =>
              IntroScreen(),
        );
      case AppStrings.onBoarding:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 3),
          pageBuilder: (context, animation, secondaryAnimation) =>
              OnBoardingScreen(),
        );
      case AppStrings.login:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
        );

      case AppStrings.forgotPassword:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ForgotPasswordScreen(),
        );

      case AppStrings.register:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SignUp(),
        );

      case AppStrings.home:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
        );

      case AppStrings.layout:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LayoutScreen(),
        );

      case AppStrings.addEvent:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AddEventScreen(),
        );

      case AppStrings.editEvent:
        var event = settings.arguments as Event;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              EditEventScreen(event: event),
        );

      case AppStrings.eventDetails:
        var event = settings.arguments as Event;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              EventDetailsScreen(event: event),
        );

      // case AppStrings.EventMap:
      // final bloc = settings.arguments as EventBloc;
      // return PageRouteBuilder(
      //   pageBuilder: (context, animation, secondaryAnimation) =>
      //       EventMapScreen(bloc: bloc),
      // );

      // case AppStrings.EventMapinAddEvent:
      //   try {
      //     final eventCubit = settings.arguments as EventCubit;
      //     return PageRouteBuilder(
      //       pageBuilder: (context, animation, secondaryAnimation) =>
      //           MapWidget(eventCubit: eventCubit),
      //     );
      //   } catch (e) {
      //     return PageRouteBuilder(
      //       pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
      //         backgroundColor: myColors.gray,
      //         appBar: AppBar(title: Text('Error')),
      //         body: Center(child: Text('Error loading map: $e')),
      //       ),
      //     );
      //   }

      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
            backgroundColor: AppColors.gray,
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
