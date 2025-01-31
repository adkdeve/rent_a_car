import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rent_a_car_project/providers/CarProvider.dart';
import 'package:rent_a_car_project/providers/CategoriesProvider.dart';
import 'package:rent_a_car_project/providers/NotificationProvider.dart';
import 'Screen/SplashScreen/SplashScreen.dart';
import 'globalContent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.light, // Light icons for dark theme
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const RentXApp());

}

class RentXApp extends StatelessWidget {
  const RentXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your providers here. You can add other providers as needed.
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
      ],
      child: MaterialApp(
        title: 'RentX',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system, // Automatically switch between light and dark themes
        home: SplashScreen(),
        debugShowCheckedModeBanner: false, // This hides the debug banner

      ),
    );
  }

}
