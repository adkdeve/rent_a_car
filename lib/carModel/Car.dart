import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String name;
  final String brand;
  final List<String> imageUrl;
  final String rating;
  final String pricePerDay;
  final String description;
  final List<String> features;
  final List<Map<String, dynamic>> reviews;
  final String namePlate;
  final String? transmission;
  final String? fuelType;
  final String? carType;
  final bool? airConditioning;
  final bool? sunroof;
  final bool? bluetoothConnectivity;
  final String? color;
  final DateTime? dateAdded;
  final bool isFeatured;
  final String ownerID; // Field to store the owner's ID
  final List<Map<String, dynamic>> reservations; // New field for reservations

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.rating,
    required this.pricePerDay,
    required this.description,
    required this.features,
    required this.reviews,
    required this.namePlate,
    this.transmission,
    this.fuelType,
    this.carType,
    this.airConditioning,
    this.sunroof,
    this.bluetoothConnectivity,
    this.color,
    this.dateAdded,
    required this.isFeatured,
    required this.ownerID, // Initialize the ownerID field
    required this.reservations, // Initialize the reservations field
  });

  /// Converts a Car object to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'brand': brand,
      'imageUrl': imageUrl,
      'rating': rating,
      'pricePerDay': pricePerDay,
      'description': description,
      'features': features,
      'reviews': reviews,
      'namePlate': namePlate,
      'transmission': transmission,
      'fuelType': fuelType,
      'carType': carType,
      'airConditioning': airConditioning,
      'sunroof': sunroof,
      'bluetoothConnectivity': bluetoothConnectivity,
      'color': color,
      'dateAdded': dateAdded ?? FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'isFeatured': isFeatured,
      'ownerID': ownerID, // Include the ownerID in Firestore
      'reservations': reservations, // Include the reservations field
    };
  }

  /// Creates a Car object from a Firestore document
  factory Car.fromFirestore(Map<String, dynamic> doc, String id) {
    return Car(
      id: id,
      name: doc['name'] ?? 'Unknown',
      brand: doc['brand'],
      imageUrl: List<String>.from(doc['imageUrl'] ?? []),
      rating: doc['rating'] ?? 'N/A',
      pricePerDay: doc['pricePerDay'] ?? '0',
      description: doc['description'] ?? 'No description available',
      features: List<String>.from(doc['features'] ?? []),
      reviews: List<Map<String, dynamic>>.from(doc['reviews'] ?? []),
      namePlate: doc['namePlate'] ?? 'N/A',
      transmission: doc['transmission'],
      fuelType: doc['fuelType'],
      carType: doc['carType'],
      airConditioning: doc['airConditioning'],
      sunroof: doc['sunroof'],
      bluetoothConnectivity: doc['bluetoothConnectivity'],
      color: doc['color'],
      dateAdded: (doc['dateAdded'] as Timestamp?)?.toDate(),
      isFeatured: doc['isFeatured'] ?? false,
      ownerID: doc['ownerID'], // Extract ownerID from Firestore
      reservations: List<Map<String, dynamic>>.from(doc['reservations'] ?? []), // Extract reservations
    );
  }
}
