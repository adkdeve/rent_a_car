import 'package:flutter/material.dart';
import 'package:rent_a_car_project/Screen/HomeScreenContent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Register',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        skipTextButton: const Text('Skip', style: TextStyle(color: Colors.grey)),
        trailing: const Text('Login', style: TextStyle(color: Colors.blueAccent)),
        background: [
          Image.asset('assets/slide_1.png', fit: BoxFit.cover),
          Image.asset('assets/slide_2.png', fit: BoxFit.cover),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          _buildPageContent(
            title: "Explore Cars",
            description: "Find your favorite car and book it instantly.",
            icon: Icons.car_rental,
          ),
          _buildPageContent(
            title: "Drive with Ease",
            description: "Get access to the best rental cars with just a few taps.",
            icon: Icons.drive_eta,
          ),
        ],
        onFinish: () async {
          // Set the flag to true after the user completes onboarding
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasSeenOnboarding', true);

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      ),
    );
  }

  // Helper method to create page content
  Widget _buildPageContent({required String title, required String description, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 100, color: Colors.blueAccent),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
