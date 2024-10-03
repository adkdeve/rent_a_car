import 'package:flutter/material.dart';
import 'package:rent_a_car_project/Screen/ProfileScreen.dart';
import 'package:rent_a_car_project/globalContent.dart';
import 'package:rent_a_car_project/Screen/CarDetailScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Map<String, String>> _categories = [
    {'name': 'SUVs', 'image': 'assets/suv.png'},
    {'name': 'Sedans', 'image': 'assets/sedan.png'},
    {'name': 'Sports', 'image': 'assets/sports_car.png'},
    {'name': 'Electric', 'image': 'assets/electric_car.png'},
  ];

  final List<Map<String, String>> _featuredCars = [
    {'name': 'Toyota Camry', 'type': 'Sedan', 'image': 'https://autos.hamariweb.com//images/carimages/car_5554_123307.jpg', 'price': '\R\s120/day'},
    {'name': 'Tesla Model 3', 'type': 'Electric', 'image': 'https://www.publicdomainpictures.net/pictures/130000/t2/bmw-i8-luxury-car.jpg', 'price': '\R\s150'},
    // Add more featured cars here
  ];

  final List<Map<String, String>> recentCars = [
    {
      'name': 'Tesla Model S',
      'price': '1200',
      'rating': '4.8',
      'transmission': 'Automatic',
      'fuel': 'Electric',
      'passengers': '5',
      'image': 'https://autos.hamariweb.com//images/carimages/car_5554_123307.jpg',
    },
    {
      'name': 'BMW X5',
      'price': '1500',
      'rating': '4.6',
      'transmission': 'Automatic',
      'fuel': 'Diesel',
      'passengers': '7',
      'image': 'https://www.publicdomainpictures.net/pictures/130000/t2/bmw-i8-luxury-car.jpg',
    },
    // Add more car data here
  ];

  String _searchQuery = "";


  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section, Categories Section code remains the same...
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [themeColor, themeColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location and Profile Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'New York, USA',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Hi, $fName',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // Navigate to Profile Page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(), // Replace with your ProfilePage widget
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: image != null
                                    ? FileImage(image!)
                                    : const AssetImage("assets/avatar.jpg"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Search Bar
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search for cars...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // Categories Section
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to Categories page or show more categories
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          ),
                          child: const Text('More', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the category page
                            },
                            child: Column(
                              children: [
                                Material(
                                  elevation: 5,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage("assets/category_default.png"),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  category['name']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Featured Cars Section with 'More' Button and Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: SingleChildScrollView( // Wrap with SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Cars Title and More Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Featured Cars",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to featured cars list
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => FeaturedCarsScreen()), // Replace with your navigation logic
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            ),
                            child: const Text('More', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Spacing between the row and the list
                      // Featured Cars Horizontal List
                      _buildFeaturedCarsList(_featuredCars), // Assuming featuredCars is a List of car data
                    ],
                  ),
                ),
              ),

              // Recent Cars Section with 'More' Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and 'More' button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Cars",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the full list of recent cars
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor, // Assuming themeColor is defined
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          ),
                          child: const Text('More', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12), // Space between title and cards
                    // Recent Car List
                    ListView.builder(
                      shrinkWrap: true, // Ensures the list takes only the required height
                      physics: const NeverScrollableScrollPhysics(), // Prevents internal scrolling
                      itemCount: recentCars.length, // Assuming recentCars is a list of cars
                      itemBuilder: (context, index) {
                        return _buildRecentCarCard(recentCars[index], context); // Use the recent car card
                      },
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  // Method to build individual featured car cards
  Widget _buildFeaturedCarCard(Map<String, String> car) {
    return SizedBox(
      width: 250,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Image with favorite button on top right
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        car['image']!,
                        fit: BoxFit.cover,
                        height: 120, // Adjust image height
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          // Handle favorite button tap
                        },
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Name
                      Text(
                        car['name']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Transmission type
                      Text(
                        car['type'] ?? 'Automatic', // Default to Automatic if not provided
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Rent Per Day
                      Text(
                        '₹${car['price']}/day',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // Highlight rent price
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// The horizontal scrollable layout
  Widget _buildFeaturedCarsList(List<Map<String, String>> cars) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scroll direction
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10), // Spacing between cards
            child: _buildFeaturedCarCard(cars[index]),
          );
        },
      ),
    );
  }

  Widget _buildRecentCarCard(Map<String, String> car, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to car details page
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Car Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    car['image']!,
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  ),
                ),
                // Rating in top left corner
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54, // Light transparent background
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          car['rating'] ?? '4.5',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                // Favorite Button in top right corner
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      // Handle favorite action
                    },
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Title and Rent/Day in a Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car['name']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${car['price']}/day',
                        style: const TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(), // Border line
                  const SizedBox(height: 8),
                  // Transmission, Fuel Type, and Passenger Capacity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car['transmission'] ?? 'Automatic',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        car['fuel'] ?? 'Petrol',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${car['passengers']} passengers',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
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


}



class Car {
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  Car({required this.title, required this.description, required this.imageUrl, required this.price});
}

List<Car> featuredCars = [
  Car(
    title: 'Tesla Model S',
    description: 'Electric car with top performance.',
    imageUrl: 'https://example.com/tesla.jpg',
    price: 100.0,
  ),
  Car(
    title: 'Ford Mustang',
    description: 'High performance sports car.',
    imageUrl: 'https://example.com/mustang.jpg',
    price: 150.0,
  ),
  // Add more cars here
];