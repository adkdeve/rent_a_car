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

// Define a modern color scheme
const Color primaryColorLight = Color(0xFF6200EE); // Purple
const Color secondaryColorLight = Color(0xFF03DAC6); // Teal
const Color backgroundColorLight = Color(0xFFF5F5F5); // Light Grey
const Color surfaceColorLight = Color(0xFFFFFFFF); // White
const Color errorColorLight = Color(0xFFB00020); // Red
const Color onPrimaryColorLight = Color(0xFFFFFFFF); // White
const Color onSecondaryColorLight = Color(0xFF000000); // Black
const Color onBackgroundColorLight = Color(0xFF000000); // Black
const Color onSurfaceColorLight = Color(0xFF000000); // Black
const Color onErrorColorLight = Color(0xFFFFFFFF); // White

const Color primaryColorDark = Color(0xFFBB86FC); // Light Purple
const Color secondaryColorDark = Color(0xFF03DAC6); // Teal
const Color backgroundColorDark = Color(0xFF121212); // Dark Grey
const Color surfaceColorDark = Color(0xFF1E1E1E); // Dark Surface
const Color errorColorDark = Color(0xFFCF6679); // Light Red
const Color onPrimaryColorDark = Color(0xFF000000); // Black
const Color onSecondaryColorDark = Color(0xFF000000); // Black
const Color onBackgroundColorDark = Color(0xFFFFFFFF); // White
const Color onSurfaceColorDark = Color(0xFFFFFFFF); // White
const Color onErrorColorDark = Color(0xFF000000); // Black

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    colorScheme: const ColorScheme.light(
      primary: primaryColorLight,
      secondary: secondaryColorLight,
      background: backgroundColorLight,
      surface: surfaceColorLight,
      error: errorColorLight,
      onPrimary: onPrimaryColorLight,
      onSecondary: onSecondaryColorLight,
      onBackground: onBackgroundColorLight,
      onSurface: onSurfaceColorLight,
      onError: onErrorColorLight,
    ),
    scaffoldBackgroundColor: backgroundColorLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColorLight,
      foregroundColor: onPrimaryColorLight,
      elevation: 0,
      iconTheme: IconThemeData(color: onPrimaryColorLight),
      titleTextStyle: TextStyle(
        color: onPrimaryColorLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColorLight,
      foregroundColor: onPrimaryColorLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: onBackgroundColorLight),
      bodyMedium: TextStyle(color: onSurfaceColorLight),
      headlineMedium: TextStyle(color: onBackgroundColorLight),
      headlineSmall: TextStyle(color: onBackgroundColorLight),
    ),
    iconTheme: const IconThemeData(color: onBackgroundColorLight),
    cardTheme: const CardTheme(
      color: surfaceColorLight,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColorLight,
      textTheme: ButtonTextTheme.primary,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: surfaceColorLight,
      titleTextStyle: TextStyle(color: onSurfaceColorLight, fontSize: 20),
      contentTextStyle: TextStyle(color: onSurfaceColorLight),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColorDark,
      secondary: secondaryColorDark,
      background: backgroundColorDark,
      surface: surfaceColorDark,
      error: errorColorDark,
      onPrimary: onPrimaryColorDark,
      onSecondary: onSecondaryColorDark,
      onBackground: onBackgroundColorDark,
      onSurface: onSurfaceColorDark,
      onError: onErrorColorDark,
    ),
    scaffoldBackgroundColor: backgroundColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColorDark,
      foregroundColor: onPrimaryColorDark,
      elevation: 0,
      iconTheme: IconThemeData(color: onPrimaryColorDark),
      titleTextStyle: TextStyle(
        color: onPrimaryColorDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColorDark,
      foregroundColor: onPrimaryColorDark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: onBackgroundColorDark),
      bodyMedium: TextStyle(color: onSurfaceColorDark),
      headlineMedium: TextStyle(color: onBackgroundColorDark),
      headlineSmall: TextStyle(color: onBackgroundColorDark),
    ),
    iconTheme: const IconThemeData(color: onBackgroundColorDark),
    cardTheme: const CardTheme(
      color: surfaceColorDark,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColorDark,
      textTheme: ButtonTextTheme.primary,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: surfaceColorDark,
      titleTextStyle: TextStyle(color: onSurfaceColorDark, fontSize: 20),
      contentTextStyle: TextStyle(color: onSurfaceColorDark),
    ),
  );
}
