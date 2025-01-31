import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rent_a_car_project/Screen/BookingProcessScreen.dart';
import '../carModel/Car.dart';
import '../carModel/CarRepository.dart';
import 'dart:typed_data';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary), // Use onPrimary color for icon
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            car.name,
            style: TextStyle(color: colorScheme.onPrimary), // Use onPrimary color for text
          ),
          backgroundColor: colorScheme.primary, // Use primary color for app bar background
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top image section with PageView for multiple images
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3, // 30% height of the screen
                  child: GestureDetector(
                    onTap: () => _showFullScreenImages(context, car.imageUrl),
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
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground, // Use onBackground color for text
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Name Plate: ${car.namePlate}',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurface.withOpacity(0.6), // Use onSurface color for text
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
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
                TabBar(
                  labelColor: colorScheme.primary, // Use primary color for selected tab text
                  unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6), // Use onSurface color for unselected tab text
                  indicatorColor: colorScheme.primary, // Use primary color for indicator
                  tabs: const [
                    Tab(text: 'Description'),
                    Tab(text: 'Features'),
                    Tab(text: 'Reviews'),
                  ],
                ),

                // Tab View Section
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6, // Provide fixed height for TabBarView
                  child: TabBarView(
                    children: [
                      _buildDescriptionTab(context, colorScheme),
                      _buildFeaturesTab(colorScheme),
                      _buildReviewsTab(colorScheme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingProcessScreen(car: car),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary, // Use primary color for button background
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "Book Now",
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onPrimary, // Use onPrimary color for button text
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Updated image builder to handle both network and local images
  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for broken images
      );
    } else if (imageUrl.startsWith('data:image/')) {
      try {
        final String base64Data = imageUrl.split(',').last; // Extract base64 string after the comma
        print("Base64 Data: $base64Data"); // Log the base64 data for debugging
        final Uint8List bytes = base64Decode(base64Data);  // Decode base64 string into bytes
        print("Decoded base64 image data length: ${bytes.length}"); // Log the length of the byte array

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

  // Build the Description tab content
  Widget _buildDescriptionTab(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Car Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground, // Use onBackground color for text
            ),
          ),
          const SizedBox(height: 8),
          Text(
            car.description,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onBackground, // Use onBackground color for text
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          // Transmission, Fuel, and Passenger Capacity
          Wrap(
            spacing: 16,
            children: [
              _buildCarDetailRow(Icons.speed, 'Transmission', car.transmission ?? 'Automatic', colorScheme),
              _buildCarDetailRow(Icons.local_gas_station, 'Fuel', car.fuelType ?? 'Petrol', colorScheme),
            ],
          ),
        ],
      ),
    );
  }

  // Build the Features tab content
  Widget _buildFeaturesTab(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Car Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground, // Use onBackground color for text
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: car.features.map((feature) {
              return FeatureItem(icon: Icons.check, label: feature);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Build the Reviews tab content
  Widget _buildReviewsTab(ColorScheme colorScheme) {
    CarRepository repository = CarRepository();

    // Define the delete review logic
    void _deleteReview(String carId, String reviewerName) async {
      try {
        // Call the deleteReview function with the carId and reviewerName to delete the review
        await repository.deleteReview(carId, reviewerName);
        print("Review deleted successfully!");
      } catch (e) {
        print("Error deleting review: $e");
      }
    }

    // Define the modify review logic
    void _modifyReview(String carId, String reviewerName, String newReview, int newRating) async {
      try {
        // Call the updateReview function with the carId, reviewerName, and updated review details
        await repository.updateReview(carId, reviewerName, newRating, newReview);
        print("Review updated successfully!");
      } catch (e) {
        print("Error modifying review: $e");
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground, // Use onBackground color for text
            ),
          ),
          const SizedBox(height: 10),
          // Check if there are reviews, else show a message
          if (car.reviews.isEmpty)
            Text(
              "No reviews yet.",
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6), // Use onSurface color for text
              ),
            )
          else
          // Display the list of reviews
            Column(
              children: car.reviews.map((review) {
                return ReviewItem(
                  reviewer: review['reviewer'],   // Use 'reviewer' for the display name
                  review: review['review'],      // The actual review text
                  rating: review['rating'],      // Rating (integer value)
                  onDelete: () => _deleteReview(car.id, review['reviewer']),  // Deletion callback
                  onModify: (newReview, newRating) => _modifyReview(car.id, review['reviewer'], newReview, newRating),  // Modification callback
                );
              }).toList(),
            )
        ],
      ),
    );
  }

  // Helper method to build car detail row for info section
  Widget _buildCarDetailRow(IconData icon, String title, String value, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for icon
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.6), // Use onSurface color for text
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground, // Use onBackground color for text
              ),
            ),
          ],
        ),
      ],
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
  final Function onDelete;
  final Function(String, int) onModify;

  const ReviewItem({
    super.key,
    required this.reviewer,
    required this.review,
    required this.rating,
    required this.onDelete,
    required this.onModify,
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
        const SizedBox(height: 8),
        // Row(
        //   children: [
        //     // Modify Button
        //     TextButton(
        //       onPressed: () {
        //         _showModifyDialog(context);
        //       },
        //       child: const Text("Modify"),
        //     ),
        //     // Delete Button
        //     TextButton(
        //       onPressed: () {
        //         onDelete(); // Triggers the delete logic
        //       },
        //       child: const Text("Delete"),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  // Show a dialog to modify the review
  void _showModifyDialog(BuildContext context) {
    final TextEditingController reviewController = TextEditingController(text: review);
    int newRating = rating;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modify Review"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(labelText: "Review"),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(
                  5,
                      (index) => IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < newRating ? Colors.orange : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      newRating = index + 1;
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onModify(reviewController.text, newRating); // Calls the modify function
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
