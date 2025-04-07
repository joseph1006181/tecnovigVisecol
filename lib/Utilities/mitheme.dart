import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  primaryColor: Color(0xFFD93644),
  scaffoldBackgroundColor: Color(0xFFF2F2F2),
  colorScheme: ColorScheme(
    primary: Color(0xFFD93644), // Rojo principal
    secondary: Color(0xFFA63856), // Rojo oscuro
    surface: Color(0xFFF2F2F2), // Azul oscuro (puedes ajustarlo)
    error: Colors.red,
    onPrimary: Colors.white, // Color del texto sobre el primario
    onSecondary: Colors.white, // Color del texto sobre el secundario
    onSurface: Colors.black, // Color del texto sobre el fondo
    onError: Colors.white, // Texto sobre errores
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF375CA6),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF53518C), fontSize: 18),
    bodyMedium: TextStyle(color: Color(0xFFA63856), fontSize: 16),
    bodySmall: TextStyle(color: Color(0xFF375CA6), fontSize: 14),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFFD93644),
    textTheme: ButtonTextTheme.primary,
  ),

  
);