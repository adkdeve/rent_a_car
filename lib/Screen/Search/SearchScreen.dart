import 'dart:io';
import 'package:flutter/material.dart';

import '../../carModel/Car.dart';
import '../../carModel/CarRepository.dart';
import '../CarDetailScreen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Car> _allCars = [];
  List<Car> _filteredCars = [];
  final CarRepository _carRepository = CarRepository();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCars(); // Fetch cars from the repository
  }

  // Fetch cars asynchronously
  bool _isFetching = false;

  Future<void> _fetchCars() async {
    if (_isFetching) return; // Prevent duplicate calls
    _isFetching = true;

    try {
      final cars = await _carRepository.getAllCars(); // Fetch cars
      setState(() {
        _allCars = cars; // Ensure _allCars is not appended multiple times
        _filteredCars = cars;
      });
    } catch (e) {
      print('Error fetching cars: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
      _isFetching = false;
    }
  }

  // Filters the list of cars based on the search query
  void _filterCars(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCars = _allCars;
      } else {
        _filteredCars = _allCars
            .where((car) => car.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Cars',
          style: TextStyle(color: colorScheme.onPrimary), // Use onPrimary color for text
        ),
        backgroundColor: colorScheme.primary, // Use primary color for app bar background
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary), // Use primary color for progress indicator
        ),
      )
          : Column(
        children: [
          _buildSearchBar(colorScheme),
          const SizedBox(height: 10),
          _filteredCars.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "No Cars Found",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground, // Use onBackground color for text
                ),
              ),
            ),
          )
              : Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _filteredCars.length,
              itemBuilder: (context, index) {
                final car = _filteredCars[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to CarDetailScreen when a car is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CarDetailScreen(car: car),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildImage(
                              car.imageUrl.isNotEmpty
                                  ? car.imageUrl[0]
                                  : ''),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius:
                              const BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              car.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build Search bar
  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface, // Use surface color for background
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
        decoration: InputDecoration(
          hintText: "Search for cars...",
          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for hint text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurface.withOpacity(0.6), // Use onSurface color for icon
          ),
        ),
        onChanged: (query) {
          _filterCars(query);
        },
      ),
    );
  }

  // Method to handle both local and network images
  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50);
        },
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50);
        },
      );
    } else {
      return const Icon(Icons.broken_image, size: 50);
    }
  }
}