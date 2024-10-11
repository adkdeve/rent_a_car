import 'dart:io';
import 'package:flutter/material.dart';
import '../carsdata/Car.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            car.name,
            style: const TextStyle(color: Colors.white), // White title text
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image section with PageView for multiple images
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3, // 30% height of the screen
                child: GestureDetector(
                  onTap: () => _showFullScreenImages(context, car.imageUrl), // On tap, show full screen images
                  child: PageView.builder(
                    itemCount: car.imageUrl.length, // Number of images
                    itemBuilder: (context, index) {
                      return _buildImage(car.imageUrl[index]); // Display each image
                    },
                  ),
                ),
              ),

              // Title Section: Car Name, Name Plate, and Price/Day
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name Plate: ${car.namePlate}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '₹${car.pricePerDay}/day',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Tab Section (Description, Features, Reviews)
              const TabBar(
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
                tabs: [
                  Tab(text: 'Description'),
                  Tab(text: 'Features'),
                  Tab(text: 'Reviews'),
                ],
              ),

              // Tab View Section (Changes with tabs)
              Expanded(
                child: TabBarView(
                  children: [
                    _buildDescriptionTab(context),
                    _buildFeaturesTab(),
                    _buildReviewsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the Description tab content
  Widget _buildDescriptionTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Car Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            car.details,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Divider(),
          // Transmission, Fuel, and Passenger Capacity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCarDetailRow(Icons.speed, 'Transmission', car.transmission ?? 'Automatic'),
              _buildCarDetailRow(Icons.local_gas_station, 'Fuel', car.fuelType ?? 'Petrol'),
              _buildCarDetailRow(Icons.people, 'Passengers', '${car.passengerCapacity ?? 'Unknown'}'),
            ],
          ),
        ],
      ),
    );
  }

  // Build the Features tab content
  Widget _buildFeaturesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Car Features',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: car.features.map((feature) {
              return FeatureItem(icon: Icons.check, label: feature);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Build the Reviews tab content
  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: car.reviews.map((review) {
              return ReviewItem(
                reviewer: review['reviewer'] as String,
                review: review['review'] as String,
                rating: review['rating'] as int,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Helper method to build car detail row for info section
  Widget _buildCarDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  // Updated image builder to handle both network and local images
  Widget _buildImage(String imageUrl) {
    return Center(
      child: imageUrl.startsWith('http')
          ? Image.network(
        imageUrl,
        fit: BoxFit.contain, // Ensure the image scales properly
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50); // Fallback icon for broken images
        },
      )
          : Image.file(
        File(imageUrl),
        fit: BoxFit.contain, // Ensure the image scales properly
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50); // Fallback icon for broken images
        },
      ),
    );
  }

  // Full-screen image view for multiple images
  void _showFullScreenImages(BuildContext context, List<String> imageUrls) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog on tap
          },
          child: Dialog(
            backgroundColor: Colors.black, // Set background to black for full-screen feel
            insetPadding: EdgeInsets.zero, // Remove padding
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: PageView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return _buildImage(imageUrls[index]); // Full-screen image with scaling
                },
              ),
            ),
          ),
        );
      },
    );
  }

}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String reviewer;
  final String review;
  final int rating;

  const ReviewItem({
    super.key,
    required this.reviewer,
    required this.review,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reviewer,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(review),
        const SizedBox(height: 4),
        Row(
          children: List.generate(
            5,
                (index) => Icon(
              Icons.star,
              color: index < rating ? Colors.orange : Colors.grey,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
