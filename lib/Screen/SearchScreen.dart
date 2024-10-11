import 'dart:io';
import 'package:flutter/material.dart';
import '../carsdata/Car.dart';
import '../carsdata/CarRepository.dart';
import 'CarDetailScreen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Car> _allCars = [];
  List<Car> _filteredCars = [];
  final CarRepository _carRepository = CarRepository();

  @override
  void initState() {
    super.initState();
    _allCars = _carRepository.getCars(); // Fetch cars from the repository
    _filteredCars = _allCars; // Initially display all cars
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Cars',
          style: TextStyle(color: Colors.white), // White text for contrast
        ),
      ),
      body: Column(
        children: [
          // Search bar for filtering cars
          _buildSearchBar(),
          const SizedBox(height: 10),
          // Display search results
          _filteredCars.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No Cars Found",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          )
              : Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display cars in 2 columns
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
                        builder: (context) => CarDetailScreen(car: car),
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
                        // Image background with error handling
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildImage(car.imageUrl.isNotEmpty ? car.imageUrl[0] : ''),
                        ),
                        // Text overlay at the bottom
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: const BorderRadius.vertical(
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
  Widget _buildSearchBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white, // Set a background color for the search bar
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            blurRadius: 5, // Soft shadow
            offset: const Offset(0, 3), // Shadow offset
          ),
        ],
      ),
      child: TextField(
        style: const TextStyle(color: Colors.black), // Text color
        decoration: InputDecoration(
          hintText: "Search for cars...",
          hintStyle: const TextStyle(color: Colors.grey), // Hint text color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent, // Make the fill color transparent
          suffixIcon: const Icon(
            Icons.search,
            color: Colors.grey, // Search icon color
          ),
        ),
        onChanged: (query) {
          _filterCars(query); // Call search filter function on input change
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
          return const Icon(Icons.broken_image, size: 50); // Fallback for broken images
        },
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50); // Fallback for broken images
        },
      );
    } else {
      return const Icon(Icons.broken_image, size: 50); // Fallback for missing image URL
    }
  }
}
