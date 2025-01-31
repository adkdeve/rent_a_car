import 'package:flutter/material.dart';
import 'package:rent_a_car_project/Screen/Auth%20%7C%20Profile/LoginScreen.dart';
import 'package:rent_a_car_project/Screen/HomeScreenContent.dart';
import 'dart:async';
import 'package:rent_a_car_project/globalContent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../carModel/CarRepository.dart';
import '../Onboarding/OnboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Check if onboarding has been shown and if the user is logged in
  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    // Check if the user is logged in
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // If the user is logged in, navigate to the HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // If the user is not logged in, check if they've seen the onboarding
      if (hasSeenOnboarding) {
        // If the user has seen the onboarding, navigate to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // If the user hasn't seen the onboarding, navigate to the OnboardingScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, // Use the primary color from the current theme (light or dark)
      body: const Center(
        child: Text(
          'RentX',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Keep text color as white for contrast
          ),
        ),
      ),
    );
  }
}
