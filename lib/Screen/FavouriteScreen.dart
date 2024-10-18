import 'package:flutter/material.dart';
import 'package:rent_a_car_project/carsdata/Car.dart';
import 'package:rent_a_car_project/globalContent.dart';
import 'package:rent_a_car_project/Screen/CarDetailScreen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.white)),
        backgroundColor: theme.primaryColor,
      ),
      body: ValueListenableBuilder<List<Car>>(
        valueListenable: FavoriteManager().favoriteNotifier,
        builder: (context, favoriteCars, child) {
          return favoriteCars.isEmpty
              ? _buildEmptyFavorites(theme)
              : _buildFavoritesList(favoriteCars, context);
        },
      ),
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

  // Method to display a list of favorite cars
  Widget _buildFavoritesList(List<Car> favoriteCars, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteCars.length,
      itemBuilder: (context, index) {
        final car = favoriteCars[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4, // Add shadow for depth
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(car.imageUrl.isNotEmpty
                  ? car.imageUrl[0] // Display the first car image
                  : 'https://via.placeholder.com/100'),
            ),
            title: Text(
              car.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Price: ₹${car.pricePerDay}/day'), // Display the car price
            trailing: const Icon(
              Icons.favorite,
              color: Colors.red, // Favorite icon in red
            ),
            onTap: () {
              // Navigate to the car detail page on tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(car: car),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

