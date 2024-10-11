class Car {
  final String id;
  final String name;
  final List<String> imageUrl; // <-- List of image URLs (instead of a single image)
  final String rating;
  final String pricePerDay;
  final String details;
  final List<String> features;
  final List<Map<String, dynamic>> reviews;
  final String? transmission; // Optional field
  final String? fuelType; // Optional field
  final int? passengerCapacity; // Optional field
  final String? carType; // Optional field
  final String? mileage; // Optional field
  final String? engineCapacity; // Optional field
  final bool? airConditioning; // Optional field
  final bool? gps; // Optional field
  final bool? sunroof; // Optional field
  final bool? bluetoothConnectivity; // Optional field
  final bool? rearCamera; // Optional field
  final String namePlate; // Required name plate field

  Car({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.pricePerDay,
    required this.details,
    required this.features,
    required this.reviews,
    required this.namePlate, // Ensure namePlate is a required field
    this.transmission,
    this.fuelType,
    this.passengerCapacity,
    this.carType,
    this.mileage,
    this.engineCapacity,
    this.airConditioning,
    this.gps,
    this.sunroof,
    this.bluetoothConnectivity,
    this.rearCamera,
  });
}
