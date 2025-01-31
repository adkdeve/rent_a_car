import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rent_a_car_project/Screen/Categories/CategoriesScreen.dart';
import 'package:rent_a_car_project/globalContent.dart';
import 'package:rent_a_car_project/Screen/CarDetailScreen.dart';
import 'package:rent_a_car_project/Screen/CarAddScreen.dart';
import 'package:rent_a_car_project/Screen/FeaturedCarScreen.dart';
import 'package:rent_a_car_project/Screen/FavouriteScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../carModel/CarRepository.dart';
import '../carModel/Car.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:reveal_on_scroll/reveal_on_scroll.dart';
import 'Auth | Profile/ProfileScreen.dart';
import 'package:fade_shimmer/fade_shimmer.dart';

import 'Categories/CarByBrands.dart';
import 'Search/SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    CategoriesScreen(
      collectionPath: 'categories/doc2/categoriesByType',
      title: 'Cars by Type',
    ),
    const FavoriteScreen(),
    const ProfilePage(),
  ];

  // Fetch user data from shared preferences
  Future<void> _loadUserDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');
    String? password = prefs.getString('currentPassword');
    String? avatarPath = prefs.getString('avatarPath');

    if (name != null) {
      GlobalConfig.name = name;
      GlobalConfig.email = email!;
      GlobalConfig.currentPassword = password!;
    }
    if (avatarPath != null) {
      GlobalConfig.image = File(avatarPath);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserDataFromLocalStorage(); // Load data when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false, // Prevents resizing when keyboard appears
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarAddScreen()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: colorScheme.surface, // Use surface color for FAB background
        elevation: 6,
        child: Icon(Icons.add, color: colorScheme.primary), // Use primary color for FAB icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(colorScheme),
      body: _pages[_currentIndex],
    );
  }

  Widget _buildBottomNavBar(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface, // Use surface color for bottom nav bar background
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: FlashyTabBar(
              backgroundColor: colorScheme.primary, // Use primary color for tab bar background
              selectedIndex: _currentIndex,
              showElevation: true,
              onItemSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                FlashyTabBarItem(
                  icon: const Icon(Icons.home),
                  title: const Text('Home'),
                  activeColor: colorScheme.onPrimary, // Use onPrimary color for active tab
                  inactiveColor: colorScheme.onPrimary.withOpacity(0.7), // Use onPrimary with opacity for inactive tab
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.category),
                  title: const Text('Categories'),
                  activeColor: colorScheme.onPrimary,
                  inactiveColor: colorScheme.onPrimary.withOpacity(0.7),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.favorite),
                  title: const Text('Favorites'),
                  activeColor: colorScheme.onPrimary,
                  inactiveColor: colorScheme.onPrimary.withOpacity(0.7),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Profile'),
                  activeColor: colorScheme.onPrimary,
                  inactiveColor: colorScheme.onPrimary.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController(); // Scroll controller
  late Future<List<Map<String, String>>> _categoriesFuture;
  CarRepository repository = CarRepository();
  late Future<List<Car>> featuredCars = repository.getFeaturedCars();
  late Future<List<Car>> recentCars = repository.getRecentCars();
  String _location = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
    _getCurrentLocation(); // Fetch location when the screen starts
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  Future<List<Map<String, String>>> fetchCategories() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc('doc1') // Document inside the categories collection
          .collection('categoriesByBrand') // Use 'categoriesByBrand' as defined in your Firestore rules
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'brand': doc['brand'] as String,   // Ensure it's a String
          'imageUrl': doc['imageUrl'] as String, // Ensure it's a String
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            controller: _scrollController, // Attach the scroll controller
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(context, colorScheme),

                // Categories Section
                _buildCategoriesSection(colorScheme),

                // Featured Cars Section
                _buildFeaturedCarsSection(colorScheme),

                // Recent Cars Section
                _buildRecentCarsSection(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the Header Section (Location, Profile, Search)
  Widget _buildHeaderSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location and Profile Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _location, // Displays the updated location (either area name or coordinates)
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Profile and Notification Badge
              Row(
                children: [
                  // Profile Avatar
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
                      backgroundImage: GlobalConfig.image != null
                          ? FileImage(GlobalConfig.image!)
                          : const AssetImage("assets/avatar.jpg") as ImageProvider,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Greeting Text
          const Text(
            'Welcome Back,',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            GlobalConfig.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          // Floating Search Bar
          GestureDetector(
            onTap: () {
              // Navigate to SearchPage when the search bar is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface, // Use surface color for search bar background
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for icon
                  const SizedBox(width: 8),
                  Text(
                    'Search for cars...',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.6), // Use onSurface color for text
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the Categories Section
  Widget _buildCategoriesSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground, // Use onBackground color for text
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesScreen(collectionPath: 'categories/doc1/categoriesByBrand',
                        title: 'Cars by Brand',),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary, // Use primary color for text
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, String>>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found'));
              }

              final categories = snapshot.data!;

              return SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarByBrands(brandName: category['brand']!),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface, // Use surface color for background
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: _getImageWidget(category['imageUrl']!),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category['brand']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onBackground, // Use onBackground color for text
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Builds the Featured Cars Section
  Widget _buildFeaturedCarsSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured Cars",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground, // Use onBackground color for text
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeaturedCarScreen(),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary, // Use primary color for text
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeaturedCarsList(featuredCars),
        ],
      ),
    );
  }

  // Horizontal scrollable layout for featured cars
  Widget _buildFeaturedCarsList(Future<List<Car>> cars) {
    return FutureBuilder<List<Car>>(
      future: cars, // Pass the Future here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading spinner
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Show error if any
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No featured cars available.')); // Handle no data
        } else {
          List<Car> featuredCars = snapshot.data!; // Get the list of cars
          return SizedBox(
            height: 220, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredCars.length, // Use the length of the list
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildFeaturedCarCard(featuredCars[index]), // Call individual car card builder
                );
              },
            ),
          );
        }
      },
    );
  }

  // Individual Featured Car Card
  Widget _buildFeaturedCarCard(Car car) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailScreen(car: car),
          ),
        );
      },
      child: SizedBox(
        width: 220,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image with Gradient Overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.darken,
                      child: _buildCarImage(car.imageUrl),
                    ),
                  ),
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(car: car),
                  ),
                  // Car Name and Rating
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              car.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Car Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                        const SizedBox(width: 4),
                        Text(
                          car.transmission ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.local_gas_station, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                        const SizedBox(width: 4),
                        Text(
                          car.fuelType ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${car.pricePerDay}/day',
                      style: const TextStyle(
                        fontSize: 16,
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
      ),
    );
  }

  // Builds the Recent Cars Section
  Widget _buildRecentCarsSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Cars",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground, // Use onBackground color for text
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Car>>(
            future: repository.getRecentCars(), // Pass the Future to FutureBuilder
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Show loading spinner
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Show error if any
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No recent cars available.')); // Handle no data
              } else {
                List<Car> recentCars = snapshot.data!; // Get the list of cars
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentCars.length,
                  itemBuilder: (context, index) {
                    return ScrollToReveal.withAnimation(
                      label: 'RecentCar$index',
                      scrollController: _scrollController, // Use the defined ScrollController
                      reflectPosition: 0, // Trigger animation on reaching this point
                      animationType: AnimationType.findInLeft, // Corrected animation type
                      child: _buildRecentCarCard(recentCars[index], context),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Individual Recent Car Card with RevealOnScroll applied
  Widget _buildRecentCarCard(Car car, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            // Car Image with Gradient Overlay and Rating
            Stack(
              children: [
                // Car Image with rounded corners and gradient overlay
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.darken,
                    child: _buildCarImage(car.imageUrl),
                  ),
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
                  child: FavoriteButton(car: car), // Use the same global favorite button
                ),
              ],
            ),
            // Car Details Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Name and Price Per Day
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${car.pricePerDay}/day',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Divider
                  const Divider(),
                  const SizedBox(height: 8),
                  // Transmission, Fuel Type, Mileage, and Seating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Transmission
                      _buildDetailWithIcon(
                        icon: Icons.settings,
                        text: car.transmission ?? 'Unknown',
                      ),
                      // Fuel Type
                      _buildDetailWithIcon(
                        icon: Icons.local_gas_station,
                        text: car.fuelType ?? 'Unknown',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mileage
                      _buildDetailWithIcon(
                        icon: Icons.speed,
                        text: '${car.brand} km',
                      ),
                      // Seating Capacity
                      _buildDetailWithIcon(
                        icon: Icons.people,
                        text: '${car.brand} Seats',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Call-to-Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailScreen(car: car),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary, // Use primary color for button background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary, // Use onPrimary color for button text
                        ),
                      ),
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

  // Helper function to build a detail row with an icon
  Widget _buildDetailWithIcon({required IconData icon, required String text}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  // Method to build car image widget (handles both local and network images)
  Widget _buildCarImage(List<String> imageUrls) {
    if (imageUrls.isNotEmpty) {
      String imageUrl = imageUrls.first; // Use the first image for display

      // Check if it's a network image or local file path
      if (imageUrl.startsWith('http')) {
        // For network images
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 120, // Adjust height as needed
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 50); // Fallback for broken images
          },
        );
      } else {
        // For local file images
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 120, // Adjust height as needed
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 50); // Fallback for broken images
          },
        );
      }
    } else {
      // Fallback when there are no images
      return const Icon(Icons.broken_image, size: 50);
    }
  }

  Widget _getImageWidget(String imageUrl) {
    if (imageUrl.endsWith('.svg')) {
      // Use SvgPicture to load SVG images
      return SvgPicture.network(imageUrl, fit: BoxFit.cover);
    } else if (imageUrl.startsWith('http')) {
      // For network images (PNG, JPEG, etc.)
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image); // Fallback for broken images
        },
      );
    } else {
      // For local images
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image); // Fallback for broken images
        },
      );
    }
  }
}

class FirestorePopulator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Populate categoriesByBrand collection
  Future<void> populateCategoryByBrand() async {
    List<Map<String, String>> brands = [
      {'brand': 'Toyota', 'imageUrl': 'https://static.vecteezy.com/system/resources/thumbnails/020/927/378/small_2x/toyota-brand-logo-car-symbol-with-name-black-design-japan-automobile-illustration-free-vector.jpg'},
      {'brand': 'BMW', 'imageUrl': 'https://thumbs.dreamstime.com/b/bmw-logo-editorial-illustrative-white-background-eps-download-vector-jpeg-banner-bmw-logo-editorial-illustrative-white-208329178.jpg'},
      {'brand': 'Mercedes', 'imageUrl': 'https://example.com/mercedes.jpg'},
      {'brand': 'Tesla', 'imageUrl': 'https://example.com/tesla.jpg'},
      {'brand': 'Ford', 'imageUrl': 'https://example.com/ford.jpg'},
    ];

    for (var brand in brands) {
      try {
        // Correct path: categories/documentId/categoriesByBrand
        await _firestore.collection('categories').doc('doc1').collection('categoriesByBrand').add(brand);
        print('Added brand: ${brand['brand']}');
      } catch (e) {
        print('Failed to add brand: ${brand['brand']}, error: $e');
      }
    }
  }

  // Populate categoriesByType collection
  Future<void> populateCategoryByType() async {
    List<Map<String, String>> carTypes = [
      {'carType': 'SUV', 'imageUrl': 'https://example.com/suv.jpg'},
      {'carType': 'Sedan', 'imageUrl': 'https://example.com/sedan.jpg'},
      {'carType': 'Hatchback', 'imageUrl': 'https://example.com/hatchback.jpg'},
      {'carType': 'Convertible', 'imageUrl': 'https://example.com/convertible.jpg'},
      {'carType': 'Pickup', 'imageUrl': 'https://example.com/pickup.jpg'},
    ];

    for (var carType in carTypes) {
      try {
        // Correct path: categories/documentId/categoriesByType
        await _firestore.collection('categories').doc('doc2').collection('categoriesByType').add(carType);
        print('Added car type: ${carType['carType']}');
      } catch (e) {
        print('Failed to add car type: ${carType['carType']}, error: $e');
      }
    }
  }

  Future<void> populateCars() async {
    List<Map<String, dynamic>> carEntries = [
      {
        'name': 'BMW 7 Series',
        'brand': 'BMW',
        'imageUrl': [
          "https://www.premiercarriage.co.uk/uploads/2024/04/19/blue-bmw-7-series-wedding-car-hire.jpg"
        ],
        'rating': '4.9',
        'pricePerDay': 'Rs350',
        'description': 'A luxury sedan with cutting-edge technology and performance.',
        'features': ['Automatic', 'Diesel', 'Luxury'],
        'reviews': [
          {
            'reviewer': 'John Doe',
            'rating': 5,
            'review': 'An amazing ride, smooth and luxurious!',
          },
          {
            'reviewer': 'Alice Smith',
            'rating': 4,
            'review': 'Great car, but the interior could be more spacious.',
          }
        ],
        'namePlate': 'BMW7SER123',
        'transmission': 'Automatic',
        'fuelType': 'Diesel',
        'carType': 'Sedan',
        'airConditioning': true,
        'sunroof': true,
        'bluetoothConnectivity': true,
        'color': 'Red',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': true,
        'ownerID': 'owner123',
      },
      {
        'name': 'Lexus RX',
        'brand': 'Lexus',
        'imageUrl': [
          "https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Lexus_RX_500h_F_SPORT%2B_%28V%29_%E2%80%93_f_14072024.jpg/640px-Lexus_RX_500h_F_SPORT%2B_%28V%29_%E2%80%93_f_14072024.jpg"
        ],
        'rating': '4.9',
        'pricePerDay': 'Rs240',
        'description': 'A luxury SUV with a comfortable ride and premium features.',
        'features': ['SUV', 'Automatic', 'Gasoline', 'Luxury'],
        'reviews': [
          {
            'reviewer': 'Sarah Lee',
            'rating': 5,
            'review': 'Perfect for long drives, extremely comfortable!',
          },
          {
            'reviewer': 'Michael Brown',
            'rating': 4,
            'review': 'Great car but a bit too expensive.',
          }
        ],
        'namePlate': 'LEXRX123',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'SUV',
        'airConditioning': true,
        'sunroof': true,
        'bluetoothConnectivity': true,
        'color': 'Black',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': true,
        'ownerID': 'owner456',
      },
      {
        'name': 'Mazda CX-5',
        'brand': 'Mazda',
        'imageUrl': [
          "https://www.cmhmazda.co.za/wp-content/uploads/2023/10/prepare-for-holidays-with-the-mazda-cx-5-dynamic-auto-social-sharing-image.webp"
        ],
        'rating': '4.8',
        'pricePerDay': 'Rs200',
        'description': 'A stylish and fun-to-drive compact SUV.',
        'features': ['SUV', 'Automatic', 'Gasoline', 'Sporty'],
        'reviews': [
          {
            'reviewer': 'Emma Wilson',
            'rating': 5,
            'review': 'Fantastic driving experience, handles like a dream.',
          },
          {
            'reviewer': 'James Smith',
            'rating': 4,
            'review': 'Nice car, but the interior could use some improvement.',
          }
        ],
        'namePlate': 'MAZCX5',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'SUV',
        'airConditioning': true,
        'sunroof': true,
        'bluetoothConnectivity': true,
        'color': 'Blue',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': false,
        'ownerID': 'owner789',
      },
      {
        'name': 'Honda Accord',
        'brand': 'Honda',
        'imageUrl': [
          "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/2023_Honda_Accord_LX%2C_front_left%2C_07-13-2023.jpg/640px-2023_Honda_Accord_LX%2C_front_left%2C_07-13-2023.jpg"
        ],
        'rating': '4.7',
        'pricePerDay': 'Rs180',
        'description': 'A reliable sedan with excellent fuel economy.',
        'features': ['Sedan', 'Automatic', 'Gasoline', 'Economical'],
        'reviews': [
          {
            'reviewer': 'Laura Green',
            'rating': 5,
            'review': 'Incredible fuel efficiency and great comfort!',
          },
          {
            'reviewer': 'David Clark',
            'rating': 4,
            'review': 'Good car, but the design could be more modern.',
          }
        ],
        'namePlate': 'HONDA123',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'Sedan',
        'airConditioning': true,
        'sunroof': false,
        'bluetoothConnectivity': true,
        'color': 'White',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': false,
        'ownerID': 'owner101',
      },
      {
        'name': 'Mercedes-Benz G-Class',
        'brand': 'Mercedes-Benz',
        'imageUrl': [
          "https://hips.hearstapps.com/hmg-prod/images/2025-mercedes-benz-g550-exterior-101-6602bc5e12338.jpg?crop=0.832xw:0.702xh;0.139xw,0.0986xh&resize=2048:*"
        ],
        'rating': '4.9',
        'pricePerDay': 'Rs500',
        'description': 'A luxurious off-road vehicle with unmatched performance.',
        'features': ['SUV', 'Automatic', 'Gasoline', 'Luxury'],
        'reviews': [
          {
            'reviewer': 'Chris Black',
            'rating': 5,
            'review': 'Best off-road vehicle I have ever driven!',
          },
          {
            'reviewer': 'Monica Ray',
            'rating': 4,
            'review': 'Fantastic performance but very pricey.',
          }
        ],
        'namePlate': 'MERCGCLASS',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'SUV',
        'airConditioning': true,
        'sunroof': true,
        'bluetoothConnectivity': true,
        'color': 'Silver',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': true,
        'ownerID': 'owner202',
      },
      {
        'name': 'Nissan Rogue',
        'brand': 'Nissan',
        'imageUrl': [
          "https://cdn.jdpower.com/JDPA_2020%20Nissan%20Rogue%20SL%20Gray%20Front%20Quarter.jpg"
        ],
        'rating': '4.5',
        'pricePerDay': 'Rs220',
        'description': 'A compact SUV with great handling and comfort.',
        'features': ['SUV', 'Automatic', 'Gasoline', 'Compact'],
        'reviews': [
          {
            'reviewer': 'Rachel Green',
            'rating': 4,
            'review': 'Very comfortable and handles well.',
          },
          {
            'reviewer': 'John Wayne',
            'rating': 5,
            'review': 'Perfect for city driving and weekend getaways!',
          }
        ],
        'namePlate': 'NISSROGUE',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'SUV',
        'airConditioning': true,
        'sunroof': false,
        'bluetoothConnectivity': true,
        'color': 'Green',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': false,
        'ownerID': 'owner303',
      },
      {
        'name': 'Hyundai Elantra',
        'brand': 'Hyundai',
        'imageUrl': [
          "https://di-uploads-pod32.dealerinspire.com/wolfchasehyundai/uploads/2024/01/2024-Hyundai-Elantra-Rear-Angle.jpg"
        ],
        'rating': '4.6',
        'pricePerDay': 'Rs150',
        'description': 'An affordable sedan with solid performance and comfort.',
        'features': ['Sedan', 'Automatic', 'Gasoline', 'Economical'],
        'reviews': [
          {
            'reviewer': 'Olivia Walker',
            'rating': 4,
            'review': 'Great value for the money, smooth drive.',
          },
          {
            'reviewer': 'Ethan King',
            'rating': 5,
            'review': 'Incredible gas mileage and very comfortable.',
          }
        ],
        'namePlate': 'HYUNDAI123',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'Sedan',
        'airConditioning': true,
        'sunroof': false,
        'bluetoothConnectivity': true,
        'color': 'Gray',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': false,
        'ownerID': 'owner404',
      },
      {
        'name': 'Kia Seltos',
        'brand': 'Kia',
        'imageUrl': [
          "https://stimg.cardekho.com/images/carexteriorimages/630x420/Kia/Seltos-2023/8709/1688465684023/front-left-side-47.jpg"
        ],
        'rating': '4.7',
        'pricePerDay': 'Rs250',
        'description': 'A compact SUV with modern features and comfort.',
        'features': ['SUV', 'Automatic', 'Gasoline', 'Sporty'],
        'reviews': [
          {
            'reviewer': 'Lily White',
            'rating': 5,
            'review': 'Absolutely love the design and comfort!',
          },
          {
            'reviewer': 'Daniel Scott',
            'rating': 4,
            'review': 'Good performance, but I wish it had better fuel economy.',
          }
        ],
        'namePlate': 'KIA123',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'SUV',
        'airConditioning': true,
        'sunroof': true,
        'bluetoothConnectivity': true,
        'color': 'Yellow',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': false,
        'ownerID': 'owner505',
      },
      {
        'name': 'Ford F-150',
        'brand': 'Ford',
        'imageUrl': [
          "https://images.jazelc.com/uploads/chastangford-m2en/2024-F-150-Platinum.jpg"
        ],
        'rating': '4.8',
        'pricePerDay': 'Rs350',
        'description': 'A powerful pickup truck with high towing capacity.',
        'features': ['Truck', 'Automatic', 'Gasoline', 'Heavy Duty'],
        'reviews': [
          {
            'reviewer': 'James Cole',
            'rating': 5,
            'review': 'Towing power is amazing, and it drives like a dream.',
          },
          {
            'reviewer': 'Sophie Harris',
            'rating': 4,
            'review': 'Great truck, but the fuel consumption could be better.',
          }
        ],
        'namePlate': 'FORDF150',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'Truck',
        'airConditioning': true,
        'sunroof': false,
        'bluetoothConnectivity': true,
        'color': 'Blue',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': true,
        'ownerID': 'owner606',
      },
      {
        'name': 'Chevrolet Camaro',
        'brand': 'Chevrolet',
        'imageUrl': [
          "https://media.drive.com.au/obj/tx_rs:auto:1920:1080:1/caradvice/private/baa94fd41d8a551a57ea687342603354"
        ],
        'rating': '4.7',
        'pricePerDay': 'Rs400',
        'description': 'A high-performance sports car with powerful engine options.',
        'features': ['Sports Car', 'Automatic', 'Gasoline', 'Performance'],
        'reviews': [
          {
            'reviewer': 'David Cooper',
            'rating': 5,
            'review': 'Incredible acceleration and handling!',
          },
          {
            'reviewer': 'Sophia Martin',
            'rating': 4,
            'review': 'Great car for speed lovers but can be tough on the wallet.',
          }
        ],
        'namePlate': 'CHEVY123',
        'transmission': 'Automatic',
        'fuelType': 'Gasoline',
        'carType': 'Sports Car',
        'airConditioning': true,
        'sunroof': true,
        'bluetoothConnectivity': true,
        'color': 'Yellow',
        'dateAdded': FieldValue.serverTimestamp(),
        'isFeatured': true,
        'ownerID': 'owner707',
      }
    ];

    for (var car in carEntries) {
      try {
        // Update the reviews array to add a timestamp manually
        if (car.containsKey('reviews')) {
          car['reviews'] = (car['reviews'] as List).map((review) {
            return {
              ...review,
              'timestamp': Timestamp.now(),
            };
          }).toList();
        }

        // Add the car document to Firestore
        await _firestore.collection('cars').add(car);
        print('Car added successfully: ${car['name']}');
      } catch (e) {
        print('Failed to add car: ${car['name']}, error: $e');
      }
    }
  }

}

