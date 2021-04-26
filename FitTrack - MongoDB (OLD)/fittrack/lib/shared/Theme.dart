import 'package:flutter/material.dart';

final theme = ThemeData(
  primaryColor: Colors.grey[50],
  accentColor: Colors.blue[900],
  primaryTextTheme: TextTheme(
    // AppBar Title
    headline6: TextStyle(
      color: Colors.grey[900],
      fontSize: 18.0,
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey[50],
    titleTextStyle: TextStyle(
      color: Colors.grey[900],
    ),
    contentTextStyle: TextStyle(
      color: Colors.grey[900],
    ),
  ),
  textTheme: TextTheme(
    // Main Text
    bodyText2: TextStyle(
      color: Colors.grey[900],
      fontSize: 15.0,
    ),
    // ListView Title Text
    subtitle1: TextStyle(
      color: Colors.grey[900],
      fontSize: 15.0,
    ),
    // ListView Subtitle Text
    caption: TextStyle(
      color: Colors.grey[800],
      fontSize: 13.0,
    ),
    // Buttons
    button: TextStyle(
      fontSize: 16.0,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.grey[500],
    selectedItemColor: Colors.blue[900],
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[900],
    textTheme: ButtonTextTheme.accent,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue[900],
    foregroundColor: Colors.grey[50],
  ),
  sliderTheme: SliderThemeData(
    inactiveTrackColor: Colors.grey[300],
    activeTrackColor: Colors.blue[900],
    thumbColor: Colors.blue[900],
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    color: Colors.grey[900],
    selectedColor: Colors.blue[900],
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: Colors.blue[900],
    selectionColor: Colors.blue[100],
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
