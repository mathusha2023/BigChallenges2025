import 'package:flutter/material.dart';

abstract class BaseTheme {
  Color get backgroundColor;
  Color get primaryContent;
  Color get primaryAccent;
  Color get secondaryColor;
  Color get cardColor;
  Brightness get brightness;
  ThemeData get themeData => ThemeData(
    fontFamily: 'Huninn',
    primaryColor: primaryContent,
    cardColor: cardColor,
    textTheme: TextTheme(
      displaySmall: TextStyle(color: backgroundColor, fontSize: 12),
      displayMedium: TextStyle(color: primaryContent, fontSize: 13),
      displayLarge: TextStyle(color: primaryContent, fontSize: 14),
      bodySmall: TextStyle(color: secondaryColor),
      bodyMedium: TextStyle(color: primaryContent, fontSize: 16),
      bodyLarge: TextStyle(color: secondaryColor),
      titleSmall: TextStyle(color: secondaryColor),
      titleMedium: TextStyle(color: secondaryColor),
      titleLarge: TextStyle(color: secondaryColor),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: secondaryColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: secondaryColor, fontSize: 14),
      prefixIconColor: secondaryColor,
    ),

    cardTheme: CardThemeData(color: cardColor, shadowColor: Colors.transparent),
    buttonTheme: ButtonThemeData(
      buttonColor: cardColor,
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: primaryAccent,
      onPrimary: primaryAccent,
      secondary: secondaryColor,
      onSecondary: secondaryColor,
      error: Colors.black,
      onError: Colors.black,
      surface: backgroundColor,
      onSurface: primaryContent,
    ),
  );
}
