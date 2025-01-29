import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rent_a_car_project/carModel/Car.dart';
import 'package:rent_a_car_project/carModel/CarRepository.dart';
import '../CarDetailScreen.dart';

class CarByBrands extends StatefulWidget {
  final String brandName;

  const CarByBrands({
    required this.brandName,
    Key? key,
  }) : super(key: key);

  @override
  _CarByBrandsState createState() => _CarByBrandsState();
}

class _CarByBrandsState extends State<CarByBrands> {
  bool isGridView = true; // Toggle between grid and list view
  String selectedSort = 'Price'; // Default filter option
  late Future<List<Car>> filteredCars; // Now it's a Future<List<Car>>
  final CarRepository repository = CarRepository();

  @override
  void initState() {
    super.initState();
    filteredCars = repository.getCarByBrand(widget.brandName); // Initialize filteredCars with all cars
  }

  // Method to sort cars by price or rating
  void _applySort(String criteria) {
    setState(() {
      filteredCars = filteredCars.then((carsList) {
        if (criteria == 'Price') {
          // Remove non-numeric characters from price and convert to double for sorting
          carsList.sort((a, b) {
            double priceA = double.tryParse(a.pricePerDay.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
            double priceB = double.tryParse(b.pricePerDay.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
            return priceA.compareTo(priceB);
          });
        } else if (criteria == 'Rating') {
          // Convert rating to double for sorting
          carsList.sort((a, b) {
            double ratingA = double.tryParse(a.rating) ?? 0;
            double ratingB = double.tryParse(b.rating) ?? 0;
            return ratingB.compareTo(ratingA); // Sort by rating in descending order
          });
        }
        return carsList;
      });
    });
  }

  // Method to toggle between grid and list view
  void _toggleLayout() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  // Builds a car card (used for both ListView and GridView)
  Widget _buildCarCard(Car car, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to CarDetailScreen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarDetailScreen(car: car)),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrapping the image in AspectRatio to prevent overflow
            AspectRatio(
              aspectRatio: 16 / 9, // Adjust this ratio as needed for your images
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: _buildImage(car.imageUrl.isNotEmpty ? car.imageUrl[0] : ''), // Using the updated image handling
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car name with ellipsis overflow handling
                  Text(
                    car.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price per day
                      Text(
                        '₹${car.pricePerDay}/day',
                        style: const TextStyle(fontSize: 14, color: Colors.green),
                      ),
                      // Rating with star icon
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 16),
                          Text(
                            car.rating,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Transmission, Fuel Type, Passenger Capacity Row with Flexible and Ellipsis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          car.transmission ?? 'Unknown',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          car.fuelType ?? 'Unknown',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated method to handle both network and local images
  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for broken images
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for broken images
      );
    } else {
      return const Icon(Icons.broken_image); // Display broken image icon if image URL is empty
    }
  }

  // Build filter bar
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sort Dropdown
          DropdownButton<String>(
            value: selectedSort,
            items: <String>['Price', 'Rating'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text('Sort by $value'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSort = value!;
                _applySort(selectedSort);
              });
            },
          ),
          // Toggle between ListView and GridView
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: _toggleLayout,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars by Brand', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Filter Bar
          _buildFilterBar(),

          // Car List/Grid
          Expanded(
            child: FutureBuilder<List<Car>>(
              future: filteredCars,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading cars.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No cars available.'));
                } else {
                  List<Car> cars = snapshot.data!;
                  return isGridView
                      ? GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns in GridView
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7, // Adjust child aspect ratio to prevent overflow
                    ),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return _buildCarCard(cars[index], context);
                    },
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return _buildCarCard(cars[index], context);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

