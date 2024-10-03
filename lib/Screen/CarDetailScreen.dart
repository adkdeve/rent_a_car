import 'package:flutter/material.dart';

// class CarDetailScreen extends StatelessWidget {
//   final Map<String, String> car;
//
//   const CarDetailScreen({Key? key, required this.car}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//         length: 3, // Three tabs: Details, Features, Reviews
//         child: Stack(
//           children: [
//             // Limit the Background Car Image to a fixed height
//             Container(
//               height: MediaQuery.of(context).size.height * 0.3, // Set it to 30% of the screen height
//               width: MediaQuery.of(context).size.width,
//               child: Image.network(
//                 'https://imgd.aeplcdn.com/600x337/n/cw/ec/42355/xuv700-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             // Gradient Overlay (should match the image height)
//             Container(
//               height: MediaQuery.of(context).size.height * 0.3, // Match the image height
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.7),
//                   ],
//                 ),
//               ),
//             ),
//             // Back Button (Positioned relative to the top)
//             Positioned(
//               top: 40,
//               left: 20,
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             // Scrollable Content with Tabs
//             Positioned(
//               top: MediaQuery.of(context).size.height * 0.25, // Start after the image
//               bottom: 0,
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.75, // Use the remaining 75% for content
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     // Car Info
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Tesla Model X',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             '\$150/day',
//                             style: TextStyle(
//                               fontSize: 24,
//                               color: Colors.green,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                         ],
//                       ),
//                     ),
//                     // Tab Bar
//                     const TabBar(
//                       labelColor: Colors.green,
//                       unselectedLabelColor: Colors.grey,
//                       indicatorColor: Colors.green,
//                       tabs: [
//                         Tab(text: 'Details'),
//                         Tab(text: 'Features'),
//                         Tab(text: 'Reviews'),
//                       ],
//                     ),
//                     // Tab Bar View
//                     const Expanded(
//                       child: TabBarView(
//                         children: [
//                           // Details Tab
//                           SingleChildScrollView(
//                             padding: EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Car Details',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   'The Tesla Model X is an electric SUV with high performance, long range, and advanced technology...',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Features Tab
//                           SingleChildScrollView(
//                             padding: EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Car Features:',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 16),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     FeatureItem(icon: Icons.speed, label: '300 mph'),
//                                     FeatureItem(icon: Icons.directions_car, label: 'Automatic'),
//                                     FeatureItem(icon: Icons.local_gas_station, label: 'Electric'),
//                                   ],
//                                 ),
//                                 SizedBox(height: 16),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     FeatureItem(icon: Icons.battery_full, label: '500 km Range'),
//                                     FeatureItem(icon: Icons.wifi, label: 'Wi-Fi Connectivity'),
//                                     FeatureItem(icon: Icons.airline_seat_recline_normal, label: '7 Seats'),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Reviews Tab
//                           SingleChildScrollView(
//                             padding: EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Customer Reviews:',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 ReviewItem(
//                                   reviewer: 'John Doe',
//                                   review:
//                                   'Amazing car! The performance and design are unmatched. Highly recommended.',
//                                   rating: 5,
//                                 ),
//                                 SizedBox(height: 16),
//                                 ReviewItem(
//                                   reviewer: 'Jane Smith',
//                                   review:
//                                   'Great experience! The Tesla Model X is comfortable, high-tech, and perfect for road trips.',
//                                   rating: 4,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Book Now Button
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           minimumSize: const Size(double.infinity, 50),
//                         ),
//                         child: const Text('Book Now'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import '../carsdata/Car.dart';

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

class CarDetailScreen extends StatelessWidget {
  final Car car; // Now using the Car model directly

  const CarDetailScreen({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name), // Display the car name in the AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                car.imageUrl,
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Car Name
                      Text(
                        car.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Car Name Plate (only displayed here)
                      Text(
                        'Name Plate: ${car.namePlate}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                  ),
                  // Rating and Rent
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          const SizedBox(width: 4),
                          Text(
                            car.rating,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
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
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Transmission, Fuel, and Passenger Capacity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCarDetailRow(Icons.speed, 'Transmission', car.transmission ?? 'Automatic'),
                      _buildCarDetailRow(Icons.local_gas_station, 'Fuel', car.fuelType ?? 'Petrol'),
                      _buildCarDetailRow(Icons.people, 'Passengers', '${car.passengerCapacity ?? 'Unknown'}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Car Features
                  Text(
                    'Features',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: car.features.map((feature) {
                      return FeatureItem(icon: Icons.check, label: feature);
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Car Reviews
                  Text(
                    'Reviews',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Book the car or perform another action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Book Now', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build car detail row for the info section
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
