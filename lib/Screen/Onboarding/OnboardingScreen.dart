import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

import '../Auth/LoginScreen.dart';
import '../Auth/SignUpScreen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return MaterialApp(
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Support for dark mode
      themeMode: ThemeMode.system, // System-based theme selection
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.transparent,
        finishButtonText: 'Register',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: colorScheme.primary, // Use primary color for button background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        skipTextButton: Text(
          'Skip',
          style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
        ),
        trailing: InkWell(
          onTap: () {
            // Navigate to LoginScreen when 'Login' is clicked
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text(
            'Login',
            style: TextStyle(
              color: colorScheme.primary, // Use primary color for text
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        background: [
          Container(color: Colors.transparent),
          Container(color: Colors.transparent),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          _buildPageContent(
            context,
            title: "Explore Cars",
            description: "Find your favorite car and book it instantly.",
            icon: Icons.car_rental,
          ),
          _buildPageContent(
            context,
            title: "Drive with Ease",
            description: "Get access to the best rental cars with just a few taps.",
            icon: Icons.drive_eta,
          ),
        ],
        onFinish: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasSeenOnboarding', true);

          // Navigate to SignUpScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
        },
      ),
    );
  }

  // Helper method to create page content
  Widget _buildPageContent(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onBackground; // Use onBackground color for text

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 100,
            color: colorScheme.primary, // Use primary color for icon
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor, // Use onBackground color for text
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.7), // Subtle text for description
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}