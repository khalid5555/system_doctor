// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'constants.dart';

// *  MY THEME.........................
class AppTheme {
  static final dk = ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white38,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.symmetric(
            vertical: AppConst.defaultPadding * 1.2,
            horizontal: AppConst.defaultPadding)),
    scaffoldBackgroundColor: AppColors.kBlACK,
    buttonTheme: const ButtonThemeData(buttonColor: AppColors.kTheFirstAPP),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // fontFamily: 'Molhim',
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.kBlACK,
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppColors.kTheFirstAPP))),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: AppColors.kTheFirstAPP),
    ),
    // bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.kBlue),
  );
  static final themeLight = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal, primary: Colors.deepPurple),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white38,
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.white),
      contentPadding: EdgeInsets.symmetric(
          vertical: AppConst.defaultPadding * 1.2,
          horizontal: AppConst.defaultPadding),
    ),
    scaffoldBackgroundColor: AppColors.kWhite,
    buttonTheme: const ButtonThemeData(buttonColor: AppColors.kTheFirstAPP),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppColors.kTheFirstAPP))),
    // fontFamily: 'Molhim',
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme:
        const TextTheme(labelLarge: TextStyle(color: AppColors.kTheFirstAPP)),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.teal),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    ),
    // primaryColor: AppColors.kPrColor,
    // bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.kBlue),
  );
}

TextStyle get inPutStyle {
  return const TextStyle(
    fontFamily: 'Molhim',
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
}

TextStyle get subheading {
  return const TextStyle(
    fontFamily: 'Molhim',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
}

TextStyle get headingStyle {
  return const TextStyle(
    fontSize: 25,
    fontFamily: 'Molhim',
    fontWeight: FontWeight.bold,
  );
}

//!   Variable const
const kProductsCollection = 'Products';
const kUserCollection = 'users';
const kImageTenderCollection = 'tenderImages';
const kImageCarouselCollection = "image_Carousel";
const LinearGradient mainButton = LinearGradient(colors: [
  Color.fromRGBO(236, 60, 3, 1),
  Color.fromRGBO(234, 60, 3, 1),
  Color.fromRGBO(216, 78, 16, 1),
], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);
