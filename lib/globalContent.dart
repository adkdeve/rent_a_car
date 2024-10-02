import 'dart:io';
import 'package:flutter/material.dart';

String fName = "John";
String lName = "Doe";
String email = "john.doe@example.com";
String phoneNumber = "03121234567";
String nPassword = '';
String currentPassword = 'ali123';
File? image;

List<Map<String, String>> cars = [
  {
    "name": "Tesla Model S",
    "price": "\$80,000",
    "imageUrl": "https://link_to_tesla_image.com",
  },
  {
    "name": "Ford Mustang",
    "price": "\$55,000",
    "imageUrl": "https://link_to_mustang_image.com",
  },
  {
    "name": "BMW M4",
    "price": "\$65,000",
    "imageUrl": "https://link_to_bmw_image.com",
  },
  {
    "name": "Audi A8",
    "price": "\$75,000",
    "imageUrl": "https://link_to_audi_image.com",
  },
  {
    "name": "Mercedes G-Class",
    "price": "\$120,000",
    "imageUrl": "https://link_to_mercedes_image.com",
  },
  {
    "name": "Porsche 911",
    "price": "\$100,000",
    "imageUrl": "https://link_to_porsche_image.com",
  },
  {
    "name": "Chevrolet Camaro",
    "price": "\$45,000",
    "imageUrl": "https://link_to_camaro_image.com",
  },
  {
    "name": "Lamborghini Aventador",
    "price": "\$400,000",
    "imageUrl": "https://link_to_lamborghini_image.com",
  },
];

// Define the colors using the swatches
const Color swatch1 = Color(0xFFeff2f5);
const Color swatch2 = Color(0xFFa2d0de);
const Color swatch3 = Color(0xFF0f84b3);
const Color swatch4 = Color(0xFF99b7c0);
const Color swatch5 = Color(0xFF1e2225);
const Color swatch6 = Color(0xFF0a6292);

class AppColors {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF4477C3,
    <int, Color>{
      50: Color(0xFFE4F0FF),
      100: Color(0xFFB2D8FF),
      200: Color(0xFF80BFFF),
      300: Color(0xFF4DA3FF),
      400: Color(0xFF2598FF),
      500: Color(0xFF4477C3),
      600: Color(0xFF2E5B9E),
      700: Color(0xFF1F4678),
      800: Color(0xFF0F2D54),
      900: Color(0xFF001B33),
    },
  );
}


final ThemeData lightTheme = ThemeData(
  primaryColor: swatch3, // Swatch 3 for primary color
  brightness: Brightness.light,
  scaffoldBackgroundColor: swatch1, // Swatch 1 for background
  appBarTheme: const AppBarTheme(
    backgroundColor: swatch3, // Swatch 3 for AppBar background
    foregroundColor: Colors.white, // AppBar title color
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: swatch3, // Swatch 3 for FAB background
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: swatch5), // Swatch 5 for text color
    bodyMedium: TextStyle(color: swatch4), // Swatch 4 for grey text
  ),
  iconTheme: const IconThemeData(color: swatch5), // Swatch 5 for icon color
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: swatch6, // Swatch 6 for primary color
  scaffoldBackgroundColor: swatch5, // Swatch 5 for background
  appBarTheme: const AppBarTheme(
    backgroundColor: swatch6, // Swatch 6 for AppBar background
    foregroundColor: Colors.black, // Black AppBar title
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: swatch6, // Swatch 6 for FAB background
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // White text
    bodyMedium: TextStyle(color: swatch4), // Swatch 4 for light grey text
  ),
  iconTheme: const IconThemeData(color: Colors.black), // Black Icons
);