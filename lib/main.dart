import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'globalContent.dart';
import 'Screen/ProfileScreen.dart';
import 'Screen/CategoryScreen.dart';
import 'Screen/FavouriteScreen.dart';
import 'Screen/CarAddScreen.dart';
import 'Screen/SplashScreen.dart';
import 'Screen/HomeScreenContent.dart';

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
      themeMode: ThemeMode.system, // Adjust theme based on system settings
      home: const SplashScreen(),
    );
  }
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CategoryPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const themeColor = AppColors.primarySwatch; // Use the custom color
    final navColor = Theme.of(context).primaryColor;

    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarAddScreen()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add, color: themeColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: FlashyTabBar(
                backgroundColor: navColor,
                selectedIndex: _currentIndex,
                showElevation: true,
                onItemSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  FlashyTabBarItem(
                    icon: const Icon(Icons.home),
                    title: const Text('Home'),
                    activeColor: Colors.white,
                    inactiveColor: Colors.white70,
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(Icons.category),
                    title: const Text('Categories'),
                    activeColor: Colors.white,
                    inactiveColor: Colors.white70,
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(Icons.favorite),
                    title: const Text('Favorites'),
                    activeColor: Colors.white,
                    inactiveColor: Colors.white70,
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(Icons.person),
                    title: const Text('Profile'),
                    activeColor: Colors.white,
                    inactiveColor: Colors.white70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}







