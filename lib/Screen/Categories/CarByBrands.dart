import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_car_project/carModel/Car.dart';
import '../../providers/CategoriesProvider.dart';
import '../car/CarDetailScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cars by Brand',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: Consumer<CategoriesProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<List<Car>>(
            future: provider.getCarsByBrand(widget.brandName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading cars.',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No cars available.',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                  ),
                );
              } else {
                List<Car> cars = provider.sortCars(snapshot.data!, selectedSort);
                return Column(
                  children: [
                    // Filter Bar
                    _buildFilterBar(provider, colorScheme, textTheme),
                    // Car List/Grid
                    Expanded(
                      child: isGridView
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
                          return _buildCarCard(cars[index], context, colorScheme, textTheme);
                        },
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          return _buildCarCard(cars[index], context, colorScheme, textTheme);
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  // Build filter bar
  Widget _buildFilterBar(CategoriesProvider provider, ColorScheme colorScheme, TextTheme textTheme) {
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
                child: Text(
                  'Sort by $value',
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSort = value!;
              });
            },
          ),
          // Toggle between ListView and GridView
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  // Builds a car card (used for both ListView and GridView)
  Widget _buildCarCard(Car car, BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
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
        color: colorScheme.surface,
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
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
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
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      // Rating with star icon
                      Row(
                        children: [
                          Icon(Icons.star, color: colorScheme.secondary, size: 16),
                          Text(
                            car.rating,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
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
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          car.fuelType ?? 'Unknown',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
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
}
