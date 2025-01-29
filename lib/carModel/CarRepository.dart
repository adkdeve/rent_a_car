import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_a_car_project/carModel/Car.dart';

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_a_car_project/carModel/Car.dart';

class CarRepository {
  // Singleton pattern for a single instance
  static final CarRepository _instance = CarRepository._internal();
  factory CarRepository() => _instance;
  CarRepository._internal();

  // Get all cars directly from Firestore
  Future<List<Car>> getAllCars() async => await getCars();

  // Get a single car by ID directly from Firestore
  Future<Car?> getCarById(String id) async {
    try {
      final cars = await getCars();
      return cars.firstWhere((car) => car.id == id, orElse: () {
        throw Exception("Car with ID $id not found.");
      });
    } catch (e) {
      print("Error retrieving car: $e");
      return null;
    }
  }

  // Get featured cars directly from Firestore
  Future<List<Car>> getFeaturedCars() async {
    final cars = await getCars();
    return cars.where((car) => car.isFeatured).toList();
  }

  // Get cars by brand directly from Firestore
  Future<List<Car>> getCarByBrand(String brandName) async {
    final cars = await getCars();
    return cars.where((car) => car.brand == brandName).toList();
  }

  // Get cars by type directly from Firestore
  Future<List<Car>> getCarByType(String carType) async {
    final cars = await getCars();
    return cars.where((car) => car.carType == carType).toList();
  }

  // Get recent cars (based on the 'dateAdded' attribute) directly from Firestore
  Future<List<Car>> getRecentCars() async {
    final cars = await getCars();
    final sortedCars = List<Car>.from(cars)
      ..sort((a, b) {
        final dateA = a.dateAdded ?? DateTime(1970);
        final dateB = b.dateAdded ?? DateTime(1970);
        return dateB.compareTo(dateA); // Descending order
      });
    return sortedCars;
  }

  // Get cars by category directly from Firestore
  Future<List<Car>> getCarsByCategory(String category) async {
    final cars = await getCars();
    return cars.where((car) => car.carType?.toLowerCase() == category.toLowerCase()).toList();
  }

  // Add a new car to Firestore
  Future<void> addCar(Car car) async {
    try {
      await addCarToFirestore(car);
      print("Car added successfully!");
    } catch (e) {
      print("Error adding car: $e");
    }
  }

  // Function to add a new car to Firestore
  Future<void> addCarToFirestore(Car car) async {
    try {
      CollectionReference carsRef = FirebaseFirestore.instance.collection('cars');
      await carsRef.add(car.toFirestore());
      print("Car added successfully!");
    } catch (e) {
      print("Error adding car: $e");
      rethrow;
    }
  }

  // Fetch cars directly from Firestore
  Future<List<Car>> getCars() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('cars').get();

      if (snapshot.docs.isEmpty) {
        print("No cars found in the database.");
        return [];
      }

      List<Future<Car>> carFutures = snapshot.docs.map((doc) async {
        var carData = doc.data() as Map<String, dynamic>;

        // Handle image URLs or Base64 strings
        List<String> imagePaths = [];
        var imageUrls = carData['imageUrl'] as List<dynamic>?;
        if (imageUrls != null && imageUrls.isNotEmpty) {
          for (var imageUrl in imageUrls) {
            if (imageUrl.startsWith('data:image/')) {
              // Directly add base64 string to the list without conversion
              imagePaths.add(imageUrl);
            } else {
              imagePaths.add(imageUrl);
            }
          }
        } else {
          print("No images found for car: ${doc.id}");
        }

        return Car.fromFirestore({
          ...carData,
          'imageUrls': imagePaths,
        }, doc.id);
      }).toList();

      List<Car> carList = await Future.wait(carFutures);

      print("Fetched ${carList.length} cars successfully!");
      return carList;
    } catch (e) {
      print('Error fetching cars: $e');
      return [];
    }
  }

  Future<void> addReview(String carId, String reviewer, int rating, String comment) async {
    try {
      // Get a reference to the car document
      DocumentReference carRef = FirebaseFirestore.instance.collection('cars').doc(carId);

      // Create the new review map
      Map<String, dynamic> newReview = {
        'reviewer': reviewer, // Correct field name: 'reviewer'
        'rating': rating,
        'review': comment, // 'review' field for the review text
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Update the reviews field (append the new review to the list)
      await carRef.update({
        'reviews': FieldValue.arrayUnion([newReview]),
      });

      print("Review added successfully!");
    } catch (e) {
      print("Error adding review: $e");
    }
  }

  Future<void> updateReview(String carId, String userId, int newRating, String newComment) async {
    try {
      DocumentReference carRef = FirebaseFirestore.instance.collection('cars').doc(carId);

      // Fetch the current reviews to find the one to update
      DocumentSnapshot carSnapshot = await carRef.get();
      List<dynamic> reviews = carSnapshot['reviews'];

      // Find and remove the existing review by userID
      var oldReviewIndex = reviews.indexWhere((review) => review['userId'] == userId);
      if (oldReviewIndex != -1) {
        // Remove old review
        reviews.removeAt(oldReviewIndex);

        // Add updated review with timestamp
        Map<String, dynamic> updatedReview = {
          'userId': userId,
          'userName': 'User Name',  // Replace with actual user name logic
          'rating': newRating,
          'comment': newComment,
          'timestamp': FieldValue.serverTimestamp(),  // Correctly setting the server timestamp
        };

        // Update reviews array with the modified review
        await carRef.update({
          'reviews': FieldValue.arrayUnion([updatedReview]),
        });

        print("Review updated successfully!");
      } else {
        print("Review not found for this user.");
      }
    } catch (e) {
      print("Error updating review: $e");
    }
  }

  Future<void> deleteReview(String carId, String reviewer) async {
    try {
      DocumentReference carRef = FirebaseFirestore.instance.collection('cars').doc(carId);

      // Fetch the current reviews to find the one to delete
      DocumentSnapshot carSnapshot = await carRef.get();
      List<dynamic> reviews = carSnapshot['reviews'];

      // Find and remove the review by reviewer
      var reviewToDelete = reviews.firstWhere((review) => review['reviewer'] == reviewer, orElse: () => null);
      if (reviewToDelete != null) {
        await carRef.update({
          'reviews': FieldValue.arrayRemove([reviewToDelete]),
        });

        print("Review deleted successfully!");
      } else {
        print("Review not found for this reviewer.");
      }
    } catch (e) {
      print("Error deleting review: $e");
    }
  }
}
