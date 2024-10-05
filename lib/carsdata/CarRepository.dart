import 'Car.dart';

class CarRepository {
  static final CarRepository _instance = CarRepository._internal();
  factory CarRepository() => _instance;
  CarRepository._internal();

  final List<Car> _cars = [
    Car(
      id: '1',
      name: 'Toyota Camry',
      imageUrl: 'https://autos.hamariweb.com//images/carimages/car_5554_123307.jpg',
      pricePerDay: '\R\s120',
      rating: '4.8',
      details: 'Toyota Camry is a comfortable sedan known for reliability.',
      features: ['Sedan', 'Automatic', 'Gasoline', 'Comfortable Interior'],
      reviews: [
        {'reviewer': 'John Doe', 'review': 'Reliable and efficient.', 'rating': 4},
      ],
      transmission: 'Automatic',
      fuelType: 'Gasoline',
      passengerCapacity: 5,
      carType: 'Sedan',
      mileage: '15 km/l',
      engineCapacity: '2000cc',
      airConditioning: true,
      gps: false,
      sunroof: false,
      bluetoothConnectivity: true,
      rearCamera: true,
      namePlate: 'ABC123', // Added namePlate field
    ),
    Car(
      id: '2',
      name: 'Tesla Model 3',
      imageUrl: 'https://www.publicdomainpictures.net/pictures/130000/t2/bmw-i8-luxury-car.jpg',
      pricePerDay: '\R\s150',
      rating: '4.6',
      details: 'Tesla Model 3 is a popular electric vehicle with high performance and cutting-edge features. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      features: ['Electric', 'Autopilot', 'Luxury Interior'],
      reviews: [
        {'reviewer': 'Jane Smith', 'review': 'The best electric car on the market!', 'rating': 5},
      ],
      transmission: 'Automatic',
      fuelType: 'Electric',
      passengerCapacity: 5,
      carType: 'Sedan',
      mileage: 'N/A',
      engineCapacity: 'Electric motor',
      airConditioning: true,
      gps: true,
      sunroof: false,
      bluetoothConnectivity: true,
      rearCamera: true,
      namePlate: 'XYZ456', // Added namePlate field
    ),
    // Add more cars as needed
  ];

  // Method to get all cars
  List<Car> getCars() {
    return _cars;
  }

  // Method to get featured cars (e.g., filter based on a specific criteria, like rating or pricePerDay)
  List<Car> getFeaturedCars() {
    // Assuming featured cars have a rating of 4.5 or higher
    return _cars.where((car) => double.tryParse(car.rating) != null && double.parse(car.rating) >= 4.5).toList();
  }

  // Method to get recent cars (could be based on an attribute like recent additions to the list)
  List<Car> getRecentCars() {
    // Assuming cars added recently are at the end of the list
    return _cars.take(3).toList(); // Returns the first 3 cars as recent for simplicity
  }

  // Method to get cars by category (carType could be used as a category)
  List<Car> getCarsByCategory(String category) {
    return _cars.where((car) => car.carType?.toLowerCase() == category.toLowerCase()).toList();
  }

  // Method to get a car by ID
  Car getCarById(String id) {
    return _cars.firstWhere(
          (car) => car.id == id,
      orElse: () => Car(
        id: '0', // Provide a default ID
        name: 'Unknown Car', // Provide a default name
        imageUrl: '', // Provide a default image URL
        pricePerDay: '0', // Provide a default price
        rating: '0', // Provide a default rating
        details: 'No details available.', // Provide default details
        features: [], // Provide an empty list for features
        reviews: [], // Provide an empty list for reviews
        transmission: null, // Nullable fields
        fuelType: null,
        passengerCapacity: null,
        carType: null,
        mileage: null,
        engineCapacity: null,
        airConditioning: null,
        gps: null,
        sunroof: null,
        bluetoothConnectivity: null,
        rearCamera: null,
        namePlate: 'UNKNOWN', // Default namePlate for unknown car
      ),
    );
  }

  // Method to add a new car to the list
  void addCar(Car car) {
    _cars.add(car);
  }
}
