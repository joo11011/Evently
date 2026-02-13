import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/core/constants/app_strings.dart';
import 'package:evently/features/cubit/App_Cubit.dart';
import 'package:evently/features/cubit/Layout_Cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:evently/core/Extension.dart';
import 'package:evently/features/widget/elevated_btn.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appCubit = context.read<AppCubit>();
    return SafeArea(
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          final layoutCubit = context.read<LayoutCubit>();
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 10,
                  top: 50,
                  right: 10,
                  bottom: 25,
                ),
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(64),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(360),
                            bottomLeft: Radius.circular(360),
                            bottomRight: Radius.circular(360),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.only(
                            bottomRight: Radius.circular(360),
                            bottomLeft: Radius.circular(360),
                            topRight: Radius.circular(360),
                          ),
                          child: Image.asset(
                            'assets/images/profile_image.jpg',
                            fit: BoxFit.cover,
                            width: 125,
                            height: 125,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            layoutCubit.user!.displayName ??
                                context.locale.nameNotFound,
                            style: context.textTheme.titleLarge!.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            layoutCubit.user!.email ??
                                context.locale.emailNotFound,
                            style: context.textTheme.titleMedium!.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.language,
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: appCubit.state.themeMode == ThemeMode.light
                            ? AppColors.black
                            : AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Elevatedbtn(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor:
                                appCubit.state.themeMode == ThemeMode.light
                                ? AppColors.white
                                : AppColors.black,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile<String>(
                                  title: Text(
                                    context.locale.english,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  value: 'en',
                                  activeColor: AppColors.purple,
                                  groupValue: appCubit.state.locale.toString(),
                                  onChanged: (value) {
                                    appCubit.changeAppLanguage(value!);
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text(
                                    context.locale.arabic,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  value: 'ar',
                                  activeColor: AppColors.purple,
                                  groupValue: appCubit.state.locale.toString(),
                                  onChanged: (value) {
                                    appCubit.changeAppLanguage(value!);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            appCubit.state.locale == 'ar'
                                ? context.locale.arabic
                                : context.locale.english,
                            style: context.textTheme.bodyMedium,
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            size: 35,
                            color: AppColors.purple,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      context.locale.theme,
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: appCubit.state.themeMode == ThemeMode.light
                            ? AppColors.black
                            : AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Elevatedbtn(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor:
                                appCubit.state.themeMode == ThemeMode.light
                                ? AppColors.white
                                : AppColors.black,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile<ThemeMode>(
                                  title: Text(
                                    context.locale.light,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  value: ThemeMode.light,
                                  activeColor: AppColors.purple,
                                  groupValue: appCubit.state.themeMode,
                                  onChanged: (value) {
                                    appCubit.changeAppTheme(value!);
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile<ThemeMode>(
                                  title: Text(
                                    context.locale.dark,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  value: ThemeMode.dark,
                                  groupValue: appCubit.state.themeMode,
                                  onChanged: (value) {
                                    appCubit.changeAppTheme(value!);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            context.appCubit.state.themeMode == ThemeMode.light
                                ? context.locale.light
                                : context.locale.dark,
                            style: context.textTheme.bodyMedium,
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            size: 35,
                            color: AppColors.purple,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 200),
                    CupertinoButton(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffFF5659),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            context.locale.logout,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(
                          context,
                          AppStrings.login,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
