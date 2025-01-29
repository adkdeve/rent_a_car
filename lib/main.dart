import 'package:flutter/material.dart';
import 'package:rent_a_car_project/providers/NotificationProvider.dart';
import 'Screen/SplashScreen/SplashScreen.dart';
import 'globalContent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
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
      ],
      child: MaterialApp(
        title: 'RentX',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: SplashScreen(),
        debugShowCheckedModeBanner: false, // This hides the debug banner

      ),
    );
  }

}
