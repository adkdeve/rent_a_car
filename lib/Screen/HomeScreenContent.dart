import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rent_a_car_project/Screen/ProfileScreen.dart';
import 'package:rent_a_car_project/globalContent.dart';
import 'package:rent_a_car_project/Screen/CarDetailScreen.dart';
import 'package:rent_a_car_project/Screen/CategoryScreen.dart';
import 'package:rent_a_car_project/Screen/CarAddScreen.dart';
import 'package:rent_a_car_project/Screen/SearchScreen.dart';
import 'package:rent_a_car_project/Screen/FeaturedCarScreen.dart';
import 'package:rent_a_car_project/Screen/FavouriteScreen.dart';
import 'package:rent_a_car_project/Screen/CategoryFromMore.dart';
import '../carsdata/CarRepository.dart';
import '../carsdata/Car.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:reveal_on_scroll/reveal_on_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    CategoryPage(),
    FavoriteScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const themeColor = AppColors.primarySwatch;
    final navColor = Theme.of(context).primaryColor;

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
        backgroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add, color: themeColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(navColor),
      body: _pages[_currentIndex],
    );
  }

  Widget _buildBottomNavBar(Color navColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
              backgroundColor: navColor,
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
                  activeColor: Colors.white,
                  inactiveColor: Colors.white70,
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.category),
                  title: const Text('Categories'),
                  activeColor: Colors.white,
                  inactiveColor: Colors.white70,
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.favorite),
                  title: const Text('Favorites'),
                  activeColor: Colors.white,
                  inactiveColor: Colors.white70,
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Profile'),
                  activeColor: Colors.white,
                  inactiveColor: Colors.white70,
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
  final CarRepository _carRepository = CarRepository();
  final ScrollController _scrollController = ScrollController(); // Scroll controller


  final List<Map<String, String>> _categories = [
    {'name': 'Toyota', 'image': 'https://upload.wikimedia.org/wikipedia/commons/e/ee/Toyota_logo_%28Red%29.svg'},
    // {'name': 'Honda', 'image': 'assets/honda.png'},
    // {'name': 'BMW', 'image': 'assets/bmw.png'},
    // {'name': 'Mercedes-Benz', 'image': 'assets/mercedes.png'},
    // {'name': 'Audi', 'image': 'assets/audi.png'},
    // {'name': 'Tesla', 'image': 'assets/tesla.png'},
    // {'name': 'Ford', 'image': 'assets/ford.png'},
    // {'name': 'Chevrolet', 'image': 'assets/chevrolet.png'},
    // {'name': 'Nissan', 'image': 'assets/nissan.png'},
    // {'name': 'Lexus', 'image': 'assets/lexus.png'},
    // {'name': 'Porsche', 'image': 'assets/porsche.png'},
    // {'name': 'Volkswagen', 'image': 'assets/volkswagen.png'},
  ];


  late List<Car> featuredCars;
  late List<Car> recentCars;
  String _location = "Fetching location...";

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
          controller: _scrollController, // Attach the scroll controller
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
            readOnly: true, // Prevents any text input
            onTap: () {
              // Navigate to SearchPage when the TextField is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
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
                  // Navigate to CategoryFromMore screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryFromMore(categories: _categories),
                    ),
                  );
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
                    // Handle category click
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _getImageWidget(category['image']!),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeaturedCarScreen()),
                  );
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
    return GestureDetector(
      onTap: () {
        // Navigate to CarDetailScreen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailScreen(car: car), // Pass the selected car
          ),
        );
      },
      child: SizedBox(
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
                  FavoriteButton(car: car), // Use the same global favorite button
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
              Text("Recent Cars", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
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
          ),
        ],
      ),
    );
  }

  // Individual Recent Car Card with RevealOnScroll applied
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
                FavoriteButton(car: car), // Use the same global favorite button
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
