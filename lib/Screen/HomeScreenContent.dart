import 'package:flutter/material.dart';
import 'package:rent_a_car_project/Screen/ProfileScreen.dart';
import 'package:rent_a_car_project/globalContent.dart';
import 'package:rent_a_car_project/Screen/CarDetailScreen.dart';

import '../carsdata/CarRepository.dart';
import '../carsdata/Car.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarRepository _carRepository = CarRepository(); // Initialize CarRepository

  final List<Map<String, String>> _categories = [
    {'name': 'SUVs', 'image': 'assets/category_default.png'},
    {'name': 'Sedans', 'image': 'assets/category_default.png'},
    {'name': 'Sports', 'image': 'assets/category_default.png'},
    {'name': 'Electric', 'image': 'assets/category_default.png'},
  ];

  late List<Car> featuredCars; // To store featured cars from the repository
  late List<Car> recentCars; // To store recent cars from the repository
  String _location = "Fetching location..."; // To store the user's real-time location
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch location when the screen starts
    featuredCars = _carRepository.getFeaturedCars(); // Get featured cars
    recentCars = _carRepository.getRecentCars(); // Get recent cars
  }

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If not, show a dialog to guide the user to enable it
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Location Services Disabled"),
            content: const Text(
              "Location services are disabled. Please enable location services to use this feature.",
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  await Geolocator.openLocationSettings(); // Open location settings
                },
                child: const Text("Open Settings"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Check for location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location = "Location permissions are permanently denied.";
      });
      return;
    }

    // Fetch the current position with high accuracy
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Use reverse geocoding to get the address from the coordinates
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        setState(() {
          // Prioritize locality (city) and administrative area (region), else fallback to the country
          String city = place.locality ?? 'Unknown City';
          String region = place.administrativeArea ?? 'Unknown Region';
          String country = place.country ?? 'Unknown Country';

          // Combine these for a more readable location
          _location = "$city, $region, $country";
        });
      } else {
        // If reverse geocoding returns no result, fallback to coordinates
        setState(() {
          _location = "${position.latitude}, ${position.longitude}";
        });
      }
    } catch (e) {
      // If reverse geocoding fails, display the coordinates as a fallback
      setState(() {
        _location = "${position.latitude}, ${position.longitude}";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(context, themeColor),

              // Categories Section
              _buildCategoriesSection(themeColor),

              // Featured Cars Section
              _buildFeaturedCarsSection(themeColor),

              // Recent Cars Section
              _buildRecentCarsSection(themeColor),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the Header Section (Location, Profile, Search)
// UI Display:
  Widget _buildHeaderSection(BuildContext context, Color themeColor) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    _location, // Displays the updated location (either area name or coordinates)
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
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
    );
  }
  // Builds the Categories Section
  Widget _buildCategoriesSection(Color themeColor) {
    return Padding(
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
                  // Navigate to Categories page
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
                    // Navigate to category page
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
                            image: DecorationImage(
                              image: AssetImage(category['image']!),
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
    );
  }

  // Builds the Featured Cars Section
  Widget _buildFeaturedCarsSection(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 10),
          _buildFeaturedCarsList(featuredCars),
        ],
      ),
    );
  }

  // Horizontal scrollable layout for featured cars
  Widget _buildFeaturedCarsList(List<Car> cars) {
    return SizedBox(
      height: 220, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _buildFeaturedCarCard(cars[index]), // Call individual car card builder
          );
        },
      ),
    );
  }

  // Individual Featured Car Card
  Widget _buildFeaturedCarCard(Car car) {
    return SizedBox(
      width: 220, // Card width for featured cars
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners for the card
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image with a favorite button on top right
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: _buildCarImage(car.imageUrl), // Helper function to load the car image
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
                  Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    car.transmission ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${car.pricePerDay}/day',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the Recent Cars Section
  Widget _buildRecentCarsSection(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Cars",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentCars.length,
            itemBuilder: (context, index) {
              return _buildRecentCarCard(recentCars[index], context);
            },
          ),
        ],
      ),
    );
  }

  // Individual Recent Car Card
  Widget _buildRecentCarCard(Car car, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to car details page using the Car object
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
                  child: _buildCarImage(car.imageUrl),
                ),
                // Rating in top left corner
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          car.rating,
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
                        car.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${car.pricePerDay}/day',
                        style: const TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car.transmission ?? 'Unknown',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        car.fuelType ?? 'Unknown',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${car.passengerCapacity} passengers',
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

  // Method to build car image widget (handles both local and network images)
  Widget _buildCarImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      // If it's a network image, load via Image.network
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: 120, // Adjust the height as needed
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image); // Fallback for broken images
        },
      );
    } else {
      // If it's a local image, use Image.file
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        height: 120, // Adjust the height as needed
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image); // Fallback for broken images
        },
      );
    }
  }
}
