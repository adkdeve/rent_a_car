import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';


void main() {
  runApp(const RentXApp());
}

String fName = "John";
String lName = "Doe";
String email = "john.doe@example.com";
String phoneNumber = "03121234567";
String nPassword = '';
String currentPassword = 'ali123';
File? _image;

List<Map<String, String>> cars = [
  {
    "name": "Tesla Model S",
    "price": "\$80,000",
    "imageUrl": "https://link_to_tesla_image.com",
  },
  {
    "name": "Ford Mustang",
    "price": "\$55,000",
    "imageUrl": "https://link_to_mustang_image.com",
  },
  {
    "name": "BMW M4",
    "price": "\$65,000",
    "imageUrl": "https://link_to_bmw_image.com",
  },
  {
    "name": "Audi A8",
    "price": "\$75,000",
    "imageUrl": "https://link_to_audi_image.com",
  },
  {
    "name": "Mercedes G-Class",
    "price": "\$120,000",
    "imageUrl": "https://link_to_mercedes_image.com",
  },
  {
    "name": "Porsche 911",
    "price": "\$100,000",
    "imageUrl": "https://link_to_porsche_image.com",
  },
  {
    "name": "Chevrolet Camaro",
    "price": "\$45,000",
    "imageUrl": "https://link_to_camaro_image.com",
  },
  {
    "name": "Lamborghini Aventador",
    "price": "\$400,000",
    "imageUrl": "https://link_to_lamborghini_image.com",
  },
];

// Define the colors using the swatches
const Color swatch1 = Color(0xFFeff2f5);
const Color swatch2 = Color(0xFFa2d0de);
const Color swatch3 = Color(0xFF0f84b3);
const Color swatch4 = Color(0xFF99b7c0);
const Color swatch5 = Color(0xFF1e2225);
const Color swatch6 = Color(0xFF0a6292);

class AppColors {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF4477C3,
    <int, Color>{
      50: Color(0xFFE4F0FF),
      100: Color(0xFFB2D8FF),
      200: Color(0xFF80BFFF),
      300: Color(0xFF4DA3FF),
      400: Color(0xFF2598FF),
      500: Color(0xFF4477C3),
      600: Color(0xFF2E5B9E),
      700: Color(0xFF1F4678),
      800: Color(0xFF0F2D54),
      900: Color(0xFF001B33),
    },
  );
}


final ThemeData lightTheme = ThemeData(
  primaryColor: swatch3, // Swatch 3 for primary color
  brightness: Brightness.light,
  scaffoldBackgroundColor: swatch1, // Swatch 1 for background
  appBarTheme: const AppBarTheme(
    backgroundColor: swatch3, // Swatch 3 for AppBar background
    foregroundColor: Colors.white, // AppBar title color
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: swatch3, // Swatch 3 for FAB background
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: swatch5), // Swatch 5 for text color
    bodyMedium: TextStyle(color: swatch4), // Swatch 4 for grey text
  ),
  iconTheme: const IconThemeData(color: swatch5), // Swatch 5 for icon color
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: swatch6, // Swatch 6 for primary color
  scaffoldBackgroundColor: swatch5, // Swatch 5 for background
  appBarTheme: const AppBarTheme(
    backgroundColor: swatch6, // Swatch 6 for AppBar background
    foregroundColor: Colors.black, // Black AppBar title
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: swatch6, // Swatch 6 for FAB background
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // White text
    bodyMedium: TextStyle(color: swatch4), // Swatch 4 for light grey text
  ),
  iconTheme: const IconThemeData(color: Colors.black), // Black Icons
);



class RentXApp extends StatelessWidget {
  const RentXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RentX',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Adjust theme based on system settings
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primarySwatch, // Using custom color swatch
      body: Center(
        child: Text(
          'RentX',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CategoryPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const themeColor = AppColors.primarySwatch; // Use the custom color

    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarAddScreen()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: themeColor,
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
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
                    activeColor: themeColor,
                    inactiveColor: Colors.grey,
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(Icons.category),
                    title: const Text('Categories'),
                    activeColor: themeColor,
                    inactiveColor: Colors.grey,
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(Icons.favorite),
                    title: const Text('Favorites'),
                    activeColor: themeColor,
                    inactiveColor: Colors.grey,
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(Icons.person),
                    title: const Text('Profile'),
                    activeColor: themeColor,
                    inactiveColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SwipeableCardSectionController _cardController = SwipeableCardSectionController();

  final List<Map<String, String>> _categories = [
    {'name': 'SUVs', 'image': 'assets/suv.png'},
    {'name': 'Sedans', 'image': 'assets/sedan.png'},
    {'name': 'Sports', 'image': 'assets/sports_car.png'},
    {'name': 'Electric', 'image': 'assets/electric_car.png'},
  ];

  final List<Map<String, String>> _featuredCars = [
    {'name': 'Toyota Camry', 'type': 'Sedan', 'image': 'https://autos.hamariweb.com//images/carimages/car_5554_123307.jpg', 'price': '\$120/day'},
    {'name': 'Tesla Model 3', 'type': 'Electric', 'image': 'https://www.publicdomainpictures.net/pictures/130000/t2/bmw-i8-luxury-car.jpg', 'price': '\$150/day'},
    // Add more featured cars here
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
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage("assets/avatar.jpg"),
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
                            backgroundColor: Colors.black,
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

              // Featured Cars Section with 'More' Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Row(
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
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      ),
                      child: const Text('More', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),

              // Swipeable Card Stack for Featured Cars
              SizedBox(
                height: 300, // Adjust height based on your design
                child: SwipeableCardsSection(
                  cardController: _cardController,
                  context: context,
                  items: _featuredCars.map((car) => _buildFeaturedCarCard(car)).toList(),
                  onCardSwiped: (dir, index, widget) {
                    // Handle swipe direction and card removal here
                    print("Card at index $index swiped in direction $dir");
                  },
                  enableSwipeUp: false, // Set to true if you want swipe up to be allowed
                  enableSwipeDown: false, // Set to true if you want swipe down to be allowed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build individual featured car cards
  Widget _buildFeaturedCarCard(Map<String, String> car) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              car['image']!,
              fit: BoxFit.cover,
              height: 180, // Adjust image height for better display
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image);
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Name and Type
                Text(
                  car['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  car['type']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                // Rent/Day
                Text(
                  car['price']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Update color for better visual
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}









class CarAddScreen extends StatefulWidget {
  const CarAddScreen({super.key});

  @override
  _CarAddScreenState createState() => _CarAddScreenState();
}

class _CarAddScreenState extends State<CarAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _carModel;
  String? _carPrice;
  String? _carDescription;
  String? _carImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Car'),
        backgroundColor: const Color(0xFF4CAF50), // Green color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Car Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Car Model Field
              _buildTextField(
                label: 'Car Model',
                hint: 'Enter the car model',
                onSaved: (value) => _carModel = value,
              ),

              const SizedBox(height: 16),

              // Car Price Field
              _buildTextField(
                label: 'Car Price',
                hint: 'Enter the price of the car',
                onSaved: (value) => _carPrice = value,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Car Description Field
              _buildTextField(
                label: 'Car Description',
                hint: 'Enter a brief description',
                onSaved: (value) => _carDescription = value,
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              // Car Image URL Field
              _buildTextField(
                label: 'Car Image URL',
                hint: 'Enter the image URL',
                onSaved: (value) => _carImageUrl = value,
              ),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFF4CAF50), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Add Car',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build text fields with common styling
  Widget _buildTextField({
    required String label,
    required String hint,
    required FormFieldSetter<String> onSaved,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      onSaved: onSaved,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        labelStyle: const TextStyle(color: Colors.black54),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  // Method to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here, you can add the code to upload the car details
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car added successfully!')),
      );
      Navigator.pop(context); // Navigate back to the previous screen
    }
  }
}





class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy car category data (replace with actual categories)
    final List<Map<String, dynamic>> categories = [
      {'name': 'SUVs', 'icon': Icons.directions_car},
      {'name': 'Sedans', 'icon': Icons.directions_car},
      {'name': 'Hatchbacks', 'icon': Icons.directions_car},
      {'name': 'Convertibles', 'icon': Icons.directions_car},
      {'name': 'Coupes', 'icon': Icons.directions_car},
      {'name': 'Electric', 'icon': Icons.battery_charging_full},
      {'name': 'Hybrids', 'icon': Icons.battery_std},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Categories'),
        backgroundColor: Theme.of(context).primaryColor, // Primary color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 categories per row
            crossAxisSpacing: 16, // Spacing between columns
            mainAxisSpacing: 16, // Spacing between rows
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(context, category['name'], category['icon']);
          },
        ),
      ),
    );
  }

  // Method to build the category card with icon and title
  Widget _buildCategoryCard(BuildContext context, String categoryName, IconData categoryIcon) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // Navigate to category-specific page (Implement navigation logic here)
      },
      child: Card(
        elevation: 4, // Adds shadow to the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categoryIcon,
              size: 48,
              color: theme.primaryColor, // Use theme's primary color for the icon
            ),
            const SizedBox(height: 16),
            Text(
              categoryName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, // Bold text for category name
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    final theme = Theme.of(context);

    // Dummy data for favorite items (replace with your actual data)
    final List<String> favoriteItems = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: theme.primaryColor, // Use the app's primary color
      ),
      body: favoriteItems.isEmpty
          ? _buildEmptyFavorites(theme) // If no favorites, show the empty state
          : _buildFavoritesList(favoriteItems), // Else, show the list of favorites
    );
  }

  // Method to display the empty state when no favorites are added
  Widget _buildEmptyFavorites(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: theme.primaryColor.withOpacity(0.6), // Faded primary color
            ),
            const SizedBox(height: 24),
            Text(
              'No favorites yet!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your favorite items will be displayed here. Start adding your favorites now!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600], // Softer color for description
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to display a list of favorite items
  Widget _buildFavoritesList(List<String> favoriteItems) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteItems.length,
      itemBuilder: (context, index) {
        final item = favoriteItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4, // Add shadow for depth
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://via.placeholder.com/100'), // Replace with the actual image URL
            ),
            title: Text(
              item,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Movie description goes here.'), // Replace with actual description
            trailing: const Icon(
              Icons.favorite,
              color: Colors.red, // Favorite icon in red
            ),
            onTap: () {
              // Navigate to detail page or handle tap
            },
          ),
        );
      },
    );
  }
}




class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const  Center(child: Text('Profile')),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile header with avatar and name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage("assets/avatar.jpg"),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$fName $lName', // Display full name
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email, // Display email
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Profile options and actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ProfileOption(
                      icon: Icons.person,
                      title: 'Edit Profile',
                      onTap: () async {
                        final updatedData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              firstName: fName,
                              lastName: lName,
                              email: email,
                              currentImage: _image,
                            ),
                          ),
                        );

                        // Update state with new data if available
                        if (updatedData != null) {
                          setState(() {
                            fName = updatedData['firstName'];
                            lName = updatedData['lastName'];
                            email = updatedData['email'];
                            _image = updatedData['image'];
                          });
                        }
                      },
                    ),
                    ProfileOption(
                      icon: Icons.lock,
                      title: 'Change Password',
                      onTap: () {
                        // Navigate to Change Password screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                        );
                      },
                    ),
                    ProfileOption(
                      icon: Icons.settings,
                      title: 'Account Settings',
                      onTap: () {
                        // Navigate to Account Settings screen
                      },
                    ),
                    ProfileOption(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () {
                        // Navigate to Notifications settings
                      },
                    ),
                    ProfileOption(
                      icon: Icons.info,
                      title: 'About App',
                      onTap: () {
                        // Show About App information
                      },
                    ),
                    ProfileOption(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      onTap: () {
                        // Handle sign-out
                      },
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
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Retrieve the current theme

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: theme.primaryColor), // Primary color icon
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 18,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final File? currentImage;

  const EditProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.currentImage,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Edit Profile",
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality here
            },
          ),
        ],
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with a blurred background effect
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: _image == null
                          ? const AssetImage("assets/avatar.jpg")
                          : FileImage(_image!) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image from the gallery
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                          if (pickedFile != null) {
                            setState(() {
                              _image = File(pickedFile.path);
                            });
                          } else {
                            print('No image selected.');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // First Name Field
                TextFormField(
                  initialValue: fName,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter your first name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    fName = value;
                  },
                ),
                const SizedBox(height: 16),

                // Last Name Field
                TextFormField(
                  initialValue: lName,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter your last name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    lName = value;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  initialValue: email,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // Adjusted validation to handle empty and format
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                    }
                    return null; // No error if empty
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number Field
                TextFormField(
                  initialValue: phoneNumber,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                        return "Please enter a valid phone number";
                      }
                    }
                    return null; // No error if empty
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                const SizedBox(height: 16),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save changes: Only save fields that are not empty
                      if (fName.isNotEmpty || lName.isNotEmpty || email.isNotEmpty || phoneNumber.isNotEmpty || nPassword.isNotEmpty) {
                        // Implement save functionality
                        // Here you can send updated data to your backend or local storage
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile Updated!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No changes detected.')),
                        );
                      }
                    }
                    if (_formKey.currentState!.validate()) {
                      // Return updated data
                      Navigator.pop(context, {
                        'firstName': fName,
                        'lastName': lName,
                        'email': email,
                        'image': _image,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Current Password Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your current password";
                    }
                    //Optionally: You can check if the entered current password matches the stored password
                    if (value != currentPassword) {
                      return "Current password is incorrect";
                    }
                    return null; // No error if provided
                  },
                  onChanged: (value) {
                  },
                ),
                const SizedBox(height: 16),

                // New Password Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    // Check if the current password field is empty
                    if (currentPassword.isEmpty) {
                      return "Please enter your current password first";
                    }

                    // Validate the new password
                    if (value != null && value.isNotEmpty) {
                      if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                    }
                    return null; // No error if empty
                  },
                  onChanged: (value) {
                    nPassword = value; // Store the new password value
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value != nPassword) {
                        return "Passwords do not match";
                      }
                    }
                    return null; // No error if empty
                  },
                ),
                const SizedBox(height: 16),

                // Change Password Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password Changed Successfully!')),
                      );
                      currentPassword = nPassword;
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Change Password", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





// A layout to be testes

import 'package:flutter/material.dart';
import 'package:rent_a_car_project/Screen/ProfileScreen.dart';
import 'package:rent_a_car_project/globalContent.dart';
import 'package:rent_a_car_project/Screen/CarDetailScreen.dart';
import 'package:rent_a_car_project/Screen/CategoryScreen.dart';
import 'package:rent_a_car_project/Screen/CarAddScreen.dart';
import 'package:rent_a_car_project/Screen/FavouriteScreen.dart';
import '../carsdata/CarRepository.dart';
import '../carsdata/Car.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CategoryPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const themeColor = AppColors.primarySwatch; // Use the custom color
    final navColor = Theme.of(context).primaryColor;

    return Scaffold(
      extendBody: true,
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
      bottomNavigationBar: Container(
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
      ),
      body: _pages[_currentIndex],
    );
  }
}



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

