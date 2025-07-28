import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_car_project/Screen/Categories/CarByBrands.dart';
import 'package:rent_a_car_project/Screen/Categories/CarByTypes.dart';
import 'package:shimmer/shimmer.dart';
import '../../providers/CategoriesProvider.dart';

class CategoriesScreen extends StatefulWidget {
  final String collectionPath;
  final String title;

  const CategoriesScreen({
    required this.collectionPath,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset and fetch items when the collectionPath changes
    final provider = Provider.of<CategoriesProvider>(context, listen: false);
    provider.resetAndFetchItems(widget.collectionPath);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<CategoriesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingSkeleton(colorScheme, textTheme);
          } else {
            return ListView(
              children: [
                _buildSearchBar(provider, colorScheme, textTheme),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: provider.filteredItems.isEmpty ? 0 : provider.filteredItems.length,
                  itemBuilder: (context, index) {
                    return _buildGridItem(provider.filteredItems[index], context, colorScheme, textTheme);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSearchBar(CategoriesProvider provider, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: colorScheme.surfaceVariant,
          hintText: 'Search categories...',
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        onChanged: (value) {
          provider.updateSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildGridItem(Map<String, dynamic> item, BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        if (item['brand'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarByBrands(brandName: item['brand']),
            ),
          );
        } else if (item['carType'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarByTypes(carType: item['carType']),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.0),
        child: Card(
          elevation: 0, // Remove shadow by setting elevation to 0
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display item image with gradient overlay
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    children: [
                      // Image takes full width and height
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: _buildImage(item['imageUrl'] ?? ''),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['brand'] ?? item['carType'],
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item['carCount'] ?? 0} Cars Available',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover, // Ensure the image covers the entire container
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
      );
    } else {
      return const Icon(Icons.broken_image);
    }
  }

  Widget _buildLoadingSkeleton(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        // Shimmer effect for the search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: colorScheme.surfaceVariant,
            highlightColor: colorScheme.surface,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        // GridView for the skeleton cards
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.75,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder with gradient overlay
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Stack(
                          children: [
                            // Image placeholder with shimmer
                            Shimmer.fromColors(
                              baseColor: colorScheme.surfaceVariant,
                              highlightColor: colorScheme.surface,
                              child: Container(
                                color: colorScheme.surfaceVariant,
                              ),
                            ),
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Title and subtitle placeholders
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title placeholder with shimmer
                          Shimmer.fromColors(
                            baseColor: colorScheme.surfaceVariant,
                            highlightColor: colorScheme.surface,
                            child: Container(
                              width: 120,
                              height: 16,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Subtitle placeholder with shimmer
                          Shimmer.fromColors(
                            baseColor: colorScheme.surfaceVariant,
                            highlightColor: colorScheme.surface,
                            child: Container(
                              width: 80,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}