import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import '../Auth | Profile/LoginScreen.dart';
import '../Auth | Profile/SignUpScreen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return MaterialApp(
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Support for dark mode
      themeMode: ThemeMode.system, // System-based theme selection
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.transparent,
        finishButtonText: 'Register',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        skipTextButton: Text(
          'Skip',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
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
              color: Colors.blueAccent,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 100,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor, // Adjust based on theme
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
