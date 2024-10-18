class Car {
  final String id;
  final String name;
  final List<String> imageUrl; // List of image URLs
  final String rating;
  final String pricePerDay;
  final String details;
  final List<String> features;
  final List<Map<String, dynamic>> reviews;
  final String namePlate; // Required name plate field

  // Optional fields
  final String? transmission; // Manual, Automatic, etc.
  final String? fuelType; // Petrol, Diesel, Electric, etc.
  final int? passengerCapacity; // Number of passengers
  final String? carType; // SUV, Sedan, etc.
  final String? mileage; // Fuel efficiency (km/l)
  final String? engineCapacity; // Engine size (cc)
  final bool? airConditioning; // Whether the car has AC
  final bool? gps; // Whether the car has GPS
  final bool? sunroof; // Whether the car has a sunroof
  final bool? bluetoothConnectivity; // Bluetooth support
  final bool? rearCamera; // Rear-view camera
  final String? color; // Color of the car
  final String? driveType; // AWD, FWD, RWD
  final String? fuelEfficiency; // Fuel efficiency (km/l)
  final String? vin; // Vehicle Identification Number

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
    this.color,
    this.driveType,
    this.fuelEfficiency,
    this.vin,
  });
}
