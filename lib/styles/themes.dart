import 'package:books/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: mainColor, // Your accent color
  ),
  fontFamily: 'Tajawal-Regular',
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: mainColor,
    titleSpacing: SizeConfig.getW(20),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: mainColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: mainColor, // navigation bar color
      systemNavigationBarDividerColor: mainColor,
    ),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: SizeConfig.getFontSize(16),
      fontWeight: FontWeight.bold,
      fontFamily: 'Tajawal-Regular',
    ),
    iconTheme: const IconThemeData(color: white),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: mainColor,
    elevation: 5,
    // selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
    backgroundColor: Colors.transparent,
  ),
  textTheme: TextTheme(
    headline3: TextStyle(
      color: dark,
      fontSize: SizeConfig.getFontSize(14),
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      color: mainColor,
      fontSize: SizeConfig.getFontSize(20),
      fontFamily: 'NeoSansArabic',
    ),
    headline5: TextStyle(
      fontSize: SizeConfig.getFontSize(18.0),
      fontWeight: FontWeight.bold,
      color: mainColor,
    ),
    headline2: TextStyle(
      fontSize: SizeConfig.getFontSize(18.0),
      fontWeight: FontWeight.bold,
      color: dark,
    ),
    bodyText1: TextStyle(
      fontSize: SizeConfig.getFontSize(16.0),
      fontWeight: FontWeight.bold,
      color: dark,
    ),
  ),
  iconTheme: const IconThemeData(color: mainColor),
);
