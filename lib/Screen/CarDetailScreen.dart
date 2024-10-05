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
              // Top image section
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3, // 30% height of the screen
                child: Image.network(
                  car.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 50);
                  },
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

// class CarDetailScreen extends StatelessWidget {
//   final Car car; // Now using the Car model directly
//
//   const CarDetailScreen({Key? key, required this.car}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(car.name,style: const TextStyle(color: Colors.white),), // Display the car name in the AppBar
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Car Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 car.imageUrl,
//                 fit: BoxFit.cover,
//                 height: 250,
//                 width: double.infinity,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Icon(Icons.broken_image);
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Car Name
//                       Text(
//                         car.name,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       // Car Name Plate (only displayed here)
//                       Text(
//                         'Name Plate: ${car.namePlate}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//
//                   ),
//                   // Rating and Rent
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(Icons.star, color: Colors.yellow),
//                           const SizedBox(width: 4),
//                           Text(
//                             car.rating,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         '₹${car.pricePerDay}/day',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 16),
//                   // Transmission, Fuel, and Passenger Capacity
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildCarDetailRow(Icons.speed, 'Transmission', car.transmission ?? 'Automatic'),
//                       _buildCarDetailRow(Icons.local_gas_station, 'Fuel', car.fuelType ?? 'Petrol'),
//                       _buildCarDetailRow(Icons.people, 'Passengers', '${car.passengerCapacity ?? 'Unknown'}'),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 16),
//                   // Car Features
//                   Text(
//                     'Features',
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Wrap(
//                     spacing: 10,
//                     children: car.features.map((feature) {
//                       return FeatureItem(icon: Icons.check, label: feature);
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 16),
//                   // Car Reviews
//                   Text(
//                     'Reviews',
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Column(
//                     children: car.reviews.map((review) {
//                       return ReviewItem(
//                         reviewer: review['reviewer'] as String,
//                         review: review['review'] as String,
//                         rating: review['rating'] as int,
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Book the car or perform another action
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text('Book Now', style: TextStyle(color: Colors.white)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Method to build car detail row for the info section
//   Widget _buildCarDetailRow(IconData icon, String title, String value) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.grey),
//         const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             const SizedBox(height: 2),
//             Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ],
//     );
//   }
// }
