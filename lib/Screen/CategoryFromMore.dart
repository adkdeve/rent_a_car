import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class CategoryFromMore extends StatelessWidget {
  final List<Map<String, String>> categories;

  CategoryFromMore({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns in the grid
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1, // Adjust this ratio as per your design
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // Handle category click
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: _getImageWidget(category['image']!), // Updated to use the widget method for images
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to get image widget based on the image type
  Widget _getImageWidget(String imageUrl) {
    if (imageUrl.endsWith('.svg')) {
      // Use flutter_svg package to load SVG images
      return SvgPicture.network(imageUrl, fit: BoxFit.cover);
    } else if (imageUrl.startsWith('http')) {
      // For network images (PNG, JPEG, etc.)
      return Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      // For local images
      return Image.file(File(imageUrl), fit: BoxFit.cover);
    }
  }
}
