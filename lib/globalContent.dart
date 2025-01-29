import 'dart:io';
import 'package:flutter/material.dart';
import 'carModel/Car.dart';

class GlobalConfig {
  static String name = '';
  static String email = '';
  static String phoneNumber = '';
  static String newPassword = '';
  static String currentPassword = '';
  static File? image;
}

// Define the colors
const Color swatch1 = Color(0xFFeff2f5); // Light Blue color (swatch1)
const Color swatch2 = Color(0xFFa2d0de); // Light Cyan color (swatch2)
const Color swatch3 = Color(0xFF0f84b3); // Baby Blue color (swatch3)
const Color swatch4 = Color(0xFF99b7c0); // Grey color (swatch4)
const Color swatch5 = Color(0xFF1e2225); // Dark Grey color (swatch5)
const Color swatch6 = Color(0xFF0a6292); // Deep Blue color (swatch6)

class AppTheme {
  static final ThemeData light = ThemeData(
    primaryColor: swatch3,
    brightness: Brightness.light,
    scaffoldBackgroundColor: swatch1,
    appBarTheme: const AppBarTheme(
      backgroundColor: swatch3,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: swatch3,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: swatch5),
      bodyMedium: TextStyle(color: swatch4),
    ),
    iconTheme: const IconThemeData(color: swatch5),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: swatch6,
    scaffoldBackgroundColor: swatch5,
    appBarTheme: const AppBarTheme(
      backgroundColor: swatch6,
      foregroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: swatch6,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: swatch4),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );
}

class FavoriteManager {
  // Singleton instance
  static final FavoriteManager instance = FavoriteManager._internal();
  FavoriteManager._internal();

  final List<Car> _favoriteCars = [];
  final ValueNotifier<List<Car>> favoriteNotifier = ValueNotifier([]);

  // Getter for favorite cars
  List<Car> get favoriteCars => List.unmodifiable(_favoriteCars);

  // Add a car to favorites
  void addFavorite(Car car) {
    if (!_favoriteCars.contains(car)) {
      _favoriteCars.add(car);
      favoriteNotifier.value = List.unmodifiable(_favoriteCars); // Notify listeners
    }
  }

  // Remove a car from favorites
  void removeFavorite(Car car) {
    if (_favoriteCars.contains(car)) {
      _favoriteCars.remove(car);
      favoriteNotifier.value = List.unmodifiable(_favoriteCars); // Notify listeners
    }
  }

  // Check if a car is a favorite
  bool isFavorite(Car car) {
    return _favoriteCars.contains(car);
  }
}

class FavoriteButton extends StatefulWidget {
  final Car car;

  const FavoriteButton({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    // Initialize the favorite state
    _isFavorite = FavoriteManager.instance.isFavorite(widget.car);

    // Define the listener
    _listener = () {
      if (mounted) {
        setState(() {
          _isFavorite = FavoriteManager.instance.isFavorite(widget.car);
        });
      }
    };

    // Add the listener
    FavoriteManager.instance.favoriteNotifier.addListener(_listener);
  }

  // Toggle favorite status
  void _toggleFavorite() {
    if (_isFavorite) {
      FavoriteManager.instance.removeFavorite(widget.car);
    } else {
      FavoriteManager.instance.addFavorite(widget.car);
    }
    // _isFavorite is updated automatically via the listener
  }

  @override
  void dispose() {
    // Remove the listener to avoid memory leaks
    FavoriteManager.instance.favoriteNotifier.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: IconButton(
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : Colors.white,
        ),
        onPressed: _toggleFavorite,
      ),
    );
  }
}
