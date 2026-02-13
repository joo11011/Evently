import 'package:evently/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static final ThemeData LightTheme = ThemeData(
    fontFamily: GoogleFonts.inter().fontFamily,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.purple),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(color: AppColors.purple, fontSize: 25),
    ),
    inputDecorationTheme: InputDecorationTheme(
      iconColor: AppColors.gray,
      prefixIconColor: AppColors.gray,
      suffixIconColor: AppColors.gray,
      hintStyle: TextStyle(color: AppColors.gray),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.gray),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.gray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.gray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.purple),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.purple,
      type: BottomNavigationBarType.fixed,
      unselectedIconTheme: IconThemeData(color: AppColors.white),
      selectedIconTheme: IconThemeData(color: AppColors.white),
      unselectedLabelStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      selectedLabelStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.purple,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(360),
        side: BorderSide(color: AppColors.white, width: 4),
      ),
      iconSize: 35,
      foregroundColor: AppColors.white,
    ),
    dividerColor: AppColors.purple,
    dividerTheme: DividerThemeData(color: AppColors.purple),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.purple,
        fontFamily: GoogleFonts.jockeyOne().fontFamily,
        fontSize: 36,
      ),
      bodyMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.purple,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.purple,
      ),
      bodySmall: TextStyle(fontSize: 16, color: AppColors.black),
      headlineMedium: TextStyle(
        fontSize: 20,
        color: AppColors.black,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.offWhite,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      displayLarge: TextStyle(fontSize: 16, color: AppColors.gray),
      displaySmall: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.purple,
        fontSize: 16,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.purple,
      ),
    ),
  );
  static final ThemeData DarkTheme = ThemeData(
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.purple,
      secondary: AppColors.darkPurple,
    ),
    scaffoldBackgroundColor: AppColors.darkPurple,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(color: AppColors.purple, fontSize: 20),
    ),
    inputDecorationTheme: InputDecorationTheme(
      iconColor: AppColors.purple,
      prefixIconColor: AppColors.purple,
      suffixIconColor: AppColors.purple,
      hintStyle: TextStyle(color: AppColors.purple),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.purple),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.purple),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.purple),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.purple),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkPurple,
      type: BottomNavigationBarType.fixed,
      unselectedIconTheme: IconThemeData(color: AppColors.offWhite),
      selectedIconTheme: IconThemeData(color: AppColors.offWhite),
      unselectedLabelStyle: TextStyle(
        color: AppColors.offWhite,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      selectedLabelStyle: TextStyle(
        color: AppColors.offWhite,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      selectedItemColor: AppColors.offWhite,
      unselectedItemColor: AppColors.offWhite,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPurple,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(360),
        side: BorderSide(color: AppColors.offWhite, width: 4),
      ),
      iconSize: 35,
      foregroundColor: AppColors.offWhite,
    ),
    dividerColor: AppColors.purple,
    dividerTheme: DividerThemeData(color: AppColors.purple),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.purple,
        fontFamily: GoogleFonts.jockeyOne().fontFamily,
        fontSize: 36,
      ),
      bodyMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.purple,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.offWhite,
      ),
      bodySmall: TextStyle(fontSize: 16, color: AppColors.offWhite),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.offWhite,
      ),
      displayLarge: TextStyle(fontSize: 16, color: AppColors.gray),
    ),
  );
}
