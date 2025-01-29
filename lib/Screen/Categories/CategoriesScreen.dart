import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_a_car_project/Screen/Categories/CarByBrands.dart';
import 'package:rent_a_car_project/Screen/Categories/CarByTypes.dart';

class CategoriesScreen extends StatefulWidget {
  final String collectionPath; // Path to the Firestore collection
  final String title; // Screen title

  const CategoriesScreen({
    required this.collectionPath,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, dynamic>> items = []; // Items fetched from Firestore

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(widget.collectionPath)
          .get();

      setState(() {
        items = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  void _onCategoryTap(Map<String, dynamic> item) {
    if (item['brand'] != null) {
      // Navigate to CarByBrands if brand is selected
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarByBrands(brandName: item['brand']),
        ),
      );
    } else if (item['carType'] != null) {
      // Navigate to CarByTypes if carType is selected
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarByTypes(carType: item['carType']),
        ),
      );
    }
  }

  Widget _buildGridItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _onCategoryTap(item),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display item image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: _buildImage(item['imageUrl'] ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item['brand'] ?? item['carType'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
      );
    } else {
      return const Icon(Icons.broken_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: items.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns in GridView
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.8, // Adjust child aspect ratio
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildGridItem(items[index]);
        },
      ),
    );
  }
}
