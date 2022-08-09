import 'package:flutter/material.dart';

class textStyles {
  static headerText(BuildContext context,
      {Color color = Colors.black, bool italic = false, double size = 24}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: color == Colors.black
          ? Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : color
          : color,
    );
  }

  static subHeaderText(BuildContext context,
      {Color color = Colors.black, bool italic = false, double size = 20}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color == Colors.black
          ? Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : color
          : color,
    );
  }

  static titleText(BuildContext context,
      {Color color = Colors.black, bool italic = false, double size = 18}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w300,
      color: color == Colors.black
          ? Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : color
          : color,
    );
  }

  static bodyText(BuildContext context,
      {Color color = Colors.black, bool italic = false, double size = 15}) {
    return TextStyle(
      fontSize: size,
      color: color == Colors.black
          ? Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : color
          : color,
    );
  }

  static courseTitleText(BuildContext context,
      {Color color = Colors.black, bool italic = false, double size = 16}) {
    return TextStyle(
      fontSize: size,
      fontStyle: italic ? FontStyle.italic : null,
      color: color == Colors.black
          ? Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : color
          : color,
    );
  }

  static onboardingTitleText(BuildContext context,
      {Color color = Colors.black, bool italic = false, double size = 16}) {
    return TextStyle(
      fontSize: size,
      fontStyle: italic ? FontStyle.italic : null,
      color: color == Colors.black
          ? Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : color
          : color,
    );
  }
}
