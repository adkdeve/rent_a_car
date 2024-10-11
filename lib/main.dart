import 'package:flutter/material.dart';
import 'package:rent_a_car_project/Screen/HomeScreenContent.dart';
import 'globalContent.dart';
import 'Screen/SplashScreen.dart';

void main() {
  runApp(const RentXApp());
}

class RentXApp extends StatelessWidget {
  const RentXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RentX',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}








