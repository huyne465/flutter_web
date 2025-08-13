import 'package:flutter/material.dart';

class CoreTheme {
  static Color textColor = Colors.black;
  static Color containerColor = Colors.white;
  static Color backgroundColor = const Color.fromRGBO(244, 246, 248, 1);
  static Color appBarColor = const Color.fromRGBO(44, 99, 200, 1);
  static Color titleColor = const Color.fromRGBO(99, 115, 129, 1);

  static themeColors() => const Color.fromRGBO(55, 120, 218, 1);
  static newColors() => const Color.fromRGBO(194, 35, 0, 1);
  static greyColors() => const Color.fromRGBO(219, 223, 228, 1);
  static void updateColors({
    required Color containerColor,
    required Color textColor,
    required Color backgroundColor,
    required Color appBarColor,
    required Color titleColor,
  }) {
    CoreTheme.containerColor = containerColor;
    CoreTheme.textColor = textColor;
    CoreTheme.backgroundColor = backgroundColor;
    CoreTheme.appBarColor = appBarColor;
    CoreTheme.titleColor = titleColor;
  }
}
