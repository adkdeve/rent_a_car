import 'package:flutter/material.dart';

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
        title: const Text('Favorites', style: TextStyle(color: Colors.white)),
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
