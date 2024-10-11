import 'package:rent_a_car_project/carsdata/Car.dart';

class CarRepository {
  static final CarRepository _instance = CarRepository._internal();
  factory CarRepository() => _instance;
  CarRepository._internal();

  final List<Car> _cars = [
    Car(
      id: '1',
      name: 'Toyota Camry',
      imageUrl: [
        'https://autos.hamariweb.com//images/carimages/car_5554_123307.jpg',
        'https://example.com/another_camry_image.jpg', // Additional image link
      ],
      pricePerDay: '\R\s100',
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
      imageUrl: [
        'https://www.publicdomainpictures.net/pictures/130000/t2/bmw-i8-luxury-car.jpg',
        'https://example.com/tesla_model_3_image.jpg', // Additional image link
      ],
      pricePerDay: '\R\s150',
      rating: '4.6',
      details: 'Tesla Model 3 is a popular electric vehicle with high performance and cutting-edge features.',
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
    // Additional Cars
    Car(
      id: '3',
      name: 'Honda Civic',
      imageUrl: [
        'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg?cs=srgb&dl=pexels-pixabay-210019.jpg&fm=jpg',
        'https://example.com/honda_civic_image.jpg', // Additional image link
      ],
      pricePerDay: '\R\s90',
      rating: '4.5',
      details: 'Honda Civic is a reliable compact sedan with modern technology.',
      features: ['Compact', 'Automatic', 'Gasoline', 'Comfortable'],
      reviews: [
        {'reviewer': 'Tom Lee', 'review': 'Great handling and fuel efficiency.', 'rating': 4},
      ],
      transmission: 'Automatic',
      fuelType: 'Gasoline',
      passengerCapacity: 5,
      carType: 'Sedan',
      mileage: '16 km/l',
      engineCapacity: '1800cc',
      airConditioning: true,
      gps: true,
      sunroof: false,
      bluetoothConnectivity: true,
      rearCamera: true,
      namePlate: 'CIV123', // Added namePlate field
    ),
    Car(
      id: '4',
      name: 'BMW X5',
      imageUrl: [
        'https://static.toiimg.com/photo/80387978.cms',
        'https://example.com/bmw_x5_image.jpg', // Additional image link
      ],
      pricePerDay: '\R\s200',
      rating: '4.7',
      details: 'BMW X5 is a luxury SUV offering powerful performance and spacious comfort.',
      features: ['SUV', 'Automatic', 'Diesel', 'Luxury Interior'],
      reviews: [
        {'reviewer': 'Alice Johnson', 'review': 'Powerful and spacious, ideal for long trips.', 'rating': 5},
      ],
      transmission: 'Automatic',
      fuelType: 'Diesel',
      passengerCapacity: 7,
      carType: 'SUV',
      mileage: '12 km/l',
      engineCapacity: '3000cc',
      airConditioning: true,
      gps: true,
      sunroof: true,
      bluetoothConnectivity: true,
      rearCamera: true,
      namePlate: 'BMWX567', // Added namePlate field
    ),
    Car(
      id: '5',
      name: 'Audi Q7',
      imageUrl: [
        'https://images.pexels.com/photos/3729464/pexels-photo-3729464.jpeg?cs=srgb&dl=pexels-mikebirdy-3729464.jpg&fm=jpg',
        'https://example.com/audi_q7_image.jpg', // Additional image link
      ],
      pricePerDay: '\R\s220',
      rating: '4.9',
      details: 'Audi Q7 is a premium SUV with advanced technology and a smooth ride.',
      features: ['SUV', 'Automatic', 'Gasoline', 'Premium Interior'],
      reviews: [
        {'reviewer': 'Michael Green', 'review': 'Perfect mix of luxury and performance.', 'rating': 5},
      ],
      transmission: 'Automatic',
      fuelType: 'Gasoline',
      passengerCapacity: 7,
      carType: 'SUV',
      mileage: '11 km/l',
      engineCapacity: '3000cc',
      airConditioning: true,
      gps: true,
      sunroof: true,
      bluetoothConnectivity: true,
      rearCamera: true,
      namePlate: 'Q7PREM', // Added namePlate field
    ),
    Car(
      id: '6',
      name: 'Mercedes-Benz E-Class',
      imageUrl: [
        'https://gtspirit.com/wp-content/uploads/2020/07/20C0392_001.jpg',
        'https://example.com/mercedes_e_class_image.jpg', // Additional image link
      ],
      pricePerDay: '\R\s250',
      rating: '4.8',
      details: 'The Mercedes-Benz E-Class delivers exceptional luxury and cutting-edge technology.',
      features: ['Luxury', 'Automatic', 'Gasoline', 'Luxury Interior'],
      reviews: [
        {'reviewer': 'Sophia Clark', 'review': 'Unparalleled luxury and comfort.', 'rating': 5},
      ],
      transmission: 'Automatic',
      fuelType: 'Gasoline',
      passengerCapacity: 5,
      carType: 'Luxury Sedan',
      mileage: '10 km/l',
      engineCapacity: '2500cc',
      airConditioning: true,
      gps: true,
      sunroof: true,
      bluetoothConnectivity: true,
      rearCamera: true,
      namePlate: 'ECLASS123', // Added namePlate field
    ),
    Car(
      id: '7',
      name: 'Ford Mustang',
      imageUrl: [
        'https://images.cars.com/xxlarge/in/v2/stock_photos/945f3b77-3f3d-443e-9264-41b4a270cc9f/0d92de5c-0b5e-400f-80ba-808264de43c8.png',
        'https://example.com/ford_mustang_image.jpg', // Additional image link
      ],
      pricePerDay: '\R\s180',
      rating: '4.6',
      details: 'Ford Mustang is a high-performance muscle car with a legendary design.',
      features: ['Coupe', 'Manual', 'Gasoline', 'Sporty Interior'],
      reviews: [
        {'reviewer': 'David Brown', 'review': 'The ultimate driving experience.', 'rating': 5},
      ],
      transmission: 'Manual',
      fuelType: 'Gasoline',
      passengerCapacity: 4,
      carType: 'Coupe',
      mileage: '8 km/l',
      engineCapacity: '5000cc',
      airConditioning: true,
      gps: true,
      sunroof: false,
      bluetoothConnectivity: true,
      rearCamera: true,
      namePlate: 'MUST567', // Added namePlate field
    ),
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
    return _cars.take(10).toList(); // Returns the first 3 cars as recent for simplicity
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
        imageUrl: [], // Provide a default image URL list
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
