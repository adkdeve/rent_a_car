import 'package:flutter/material.dart';
import 'package:rent_a_car_project/carsdata/CarRepository.dart';
import 'package:rent_a_car_project/carsdata/Car.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'SUV', 'icon': Icons.directions_car},  // Use 'SUV' to match carType
      {'name': 'Sedan', 'icon': Icons.directions_car},  // Use 'Sedan'
      {'name': 'Electric', 'icon': Icons.battery_charging_full},  // 'Electric'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Categories', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // AppBar color
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

  Widget _buildCategoryCard(BuildContext context, String categoryName, IconData categoryIcon) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // Retrieve cars based on the category (carType) using the repository
        final carRepository = CarRepository();
        final filteredCars = carRepository.getCarsByCategory(categoryName); // Filter by carType

        // Navigate to CategoryItemsPage and pass the filtered cars
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryItemsPage(
              categoryName: categoryName,
              cars: filteredCars, // Pass filtered cars based on category
            ),
          ),
        );
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

class CategoryItemsPage extends StatelessWidget {
  final String categoryName;
  final List<Car> cars; // List of cars for this category

  const CategoryItemsPage({
    Key? key,
    required this.categoryName,
    required this.cars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Cars', style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Image.network(car.imageUrl.first, width: 100, height: 100, fit: BoxFit.cover),
                title: Text(car.name),
                subtitle: Text(car.details),
                onTap: () {
                  // Handle car item click, you could navigate to a car detail page here
                },
              ),
            );
          },
        ),
      ),
    );
  }
}