import 'package:flutter/material.dart';

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
        title: const Text('Car Categories',style: TextStyle(color: Colors.white)),
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
