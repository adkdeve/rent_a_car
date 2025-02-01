import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../carModel/Car.dart';
import '../carModel/CarRepository.dart';

class CategoriesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final CarRepository _repository = CarRepository();

  List<Map<String, dynamic>> get items => _items;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Reset state and fetch new data
  Future<void> resetAndFetchItems(String collectionPath) async {
    _items = []; // Reset items
    _isLoading = true; // Set loading state
    _searchQuery = ''; // Reset search query
    notifyListeners(); // Notify listeners to update the UI

    await fetchItems(collectionPath); // Fetch new data
  }

  // Fetch categories and their car counts
  Future<void> fetchItems(String collectionPath) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionPath) // Use the provided collectionPath
          .get();

      List<Map<String, dynamic>> itemsWithCount = [];

      for (var doc in querySnapshot.docs) {
        final item = doc.data() as Map<String, dynamic>;
        final brand = item['brand'];
        final carType = item['carType'];

        // Fetch cars for this brand or car type
        List<Car> cars;
        if (brand != null) {
          cars = await _repository.getCarByBrand(brand);
        } else if (carType != null) {
          cars = await _repository.getCarByType(carType);
        } else {
          cars = [];
        }

        // Add the count to the item
        itemsWithCount.add({
          ...item,
          'carCount': cars.length, // Number of cars in this category
        });
      }

      _items = itemsWithCount;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching items: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Get filtered items based on search query
  List<Map<String, dynamic>> get filteredItems {
    if (_searchQuery.isEmpty) {
      return _items;
    } else {
      return _items.where((item) {
        final name = item['brand'] ?? item['carType'];
        return name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  // Fetch cars by brand
  Future<List<Car>> getCarsByBrand(String brandName) async {
    return await _repository.getCarByBrand(brandName);
  }

  // Fetch cars by type
  Future<List<Car>> getCarsByType(String carType) async {
    return await _repository.getCarByType(carType);
  }

  // Sort cars by price or rating
  List<Car> sortCars(List<Car> cars, String criteria) {
    if (criteria == 'Price') {
      cars.sort((a, b) {
        double priceA = double.tryParse(a.pricePerDay.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        double priceB = double.tryParse(b.pricePerDay.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (criteria == 'Rating') {
      cars.sort((a, b) {
        double ratingA = double.tryParse(a.rating) ?? 0;
        double ratingB = double.tryParse(b.rating) ?? 0;
        return ratingB.compareTo(ratingA); // Sort by rating in descending order
      });
    }
    return cars;
  }
}
