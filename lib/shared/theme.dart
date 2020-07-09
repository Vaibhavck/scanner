import 'package:flutter/material.dart';

// currently not used in the app
class AppTheme {
  static const Color _lightPrimaryTextColor = Colors.black;
  static const Color _lightSecondaryTextColor = Colors.black;
  static const Color _lightIconColor = Colors.black;
  static const Color _lightTextColor = Colors.red;
  static Color _lightBackgroundColor = Colors.white;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryTextColor = Colors.white;
  static const Color _darkSecondaryTextColor = Colors.white;
  static const Color _darkIconColor = Colors.red;
  static const Color _darkTextColor = Colors.red;
  static Color _darkBackgroundColor = Colors.black;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightBackgroundColor,
    appBarTheme: AppBarTheme(
      color: _lightBackgroundColor,
      iconTheme: IconThemeData(
        color: _lightIconColor,
      ),
      textTheme: TextTheme(
        headline5: TextStyle(color: _lightTextColor),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryTextColor,
      secondary: _lightSecondaryTextColor,
      onPrimary: _lightOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _lightIconColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: AppBarTheme(
      color: _darkBackgroundColor,
      textTheme: TextTheme(
        headline5: TextStyle(color: _darkTextColor),
      ),
      iconTheme: IconThemeData(
        color: _darkIconColor,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: _darkPrimaryTextColor,
      secondary: _darkSecondaryTextColor,
      onPrimary: _darkOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _darkIconColor,
    ),
  );
}
