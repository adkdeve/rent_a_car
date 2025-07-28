import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../carModel/Car.dart';
import '../providers/CarProvider.dart';
import 'CarDetailScreen.dart';


class FeaturedCarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Featured Cars'),
        ),
        body: Consumer<CarProvider>(
          builder: (context, carProvider, child) {
            if (carProvider.filteredCars.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                _buildFilterBar(context),
                Expanded(
                  child: carProvider.isGridView
                      ? GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: carProvider.filteredCars.length,
                    itemBuilder: (context, index) {
                      return _buildCarCard(carProvider.filteredCars[index], context);
                    },
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: carProvider.filteredCars.length,
                    itemBuilder: (context, index) {
                      return _buildCarCard(carProvider.filteredCars[index], context);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: carProvider.selectedSort,
            items: <String>['Price', 'Rating'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text('Sort by $value'),
              );
            }).toList(),
            onChanged: (value) {
              carProvider.setSortCriteria(value!);
            },
          ),
          IconButton(
            icon: Icon(carProvider.isGridView ? Icons.list : Icons.grid_view),
            onPressed: carProvider.toggleLayout,
          ),
        ],
      ),
    );
  }

// Builds a car card (used for both ListView and GridView)
  Widget _buildCarCard(Car car, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground, // Use onBackground color for text
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
                        style: const TextStyle(fontSize: 14, color: Colors.green),
                      ),
                      // Rating with star icon
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 16),
                          Text(
                            car.rating,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground, // Use onBackground color for text
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
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for text
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          car.fuelType ?? 'Unknown',
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for text
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

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for broken images
      );
    } else if (imageUrl.startsWith('data:image/')) {
      // Handle base64 encoded images
      try {
        final String base64Data = imageUrl.split(',').last; // Extract base64 string after the comma
        final Uint8List bytes = base64Decode(base64Data);  // Decode base64 string into bytes

        // Log the base64 string length for debugging purposes
        print("Decoded base64 image data length: ${bytes.length}");

        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for broken images
        );
      } catch (e) {
        print("Error decoding base64 image: $e");
        return const Icon(Icons.broken_image); // Fallback in case of error
      }
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