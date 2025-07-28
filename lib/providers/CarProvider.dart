import 'package:flutter/material.dart';

import '../carModel/Car.dart';
import '../carModel/CarRepository.dart';

class CarProvider with ChangeNotifier {
  bool _isGridView = true;
  String _selectedSort = 'Rating';
  List<Car> _filteredCars = [];
  final CarRepository _repository = CarRepository();

  bool get isGridView => _isGridView;
  String get selectedSort => _selectedSort;
  List<Car> get filteredCars => _filteredCars;

  CarProvider() {
    _loadFeaturedCars();
  }

  Future<void> _loadFeaturedCars() async {
    _filteredCars = await _repository.getFeaturedCars();
    _applySort(_selectedSort);
  }

  void _applySort(String criteria) {
    if (criteria == 'Price') {
      _filteredCars.sort((a, b) {
        double priceA = double.tryParse(a.pricePerDay.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        double priceB = double.tryParse(b.pricePerDay.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (criteria == 'Rating') {
      _filteredCars.sort((a, b) {
        double ratingA = double.tryParse(a.rating) ?? 0;
        double ratingB = double.tryParse(b.rating) ?? 0;
        return ratingB.compareTo(ratingA);
      });
    }
    notifyListeners();
  }

  void toggleLayout() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  void setSortCriteria(String criteria) {
    _selectedSort = criteria;
    _applySort(criteria);
  }
}