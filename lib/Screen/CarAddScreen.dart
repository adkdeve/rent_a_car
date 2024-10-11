import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../carsdata/CarRepository.dart';
import '../carsdata/Car.dart';
import '../globalContent.dart';

class CarAddScreen extends StatefulWidget {
  const CarAddScreen({super.key});

  @override
  _CarAddScreenState createState() => _CarAddScreenState();
}

class _CarAddScreenState extends State<CarAddScreen> {
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carYearController = TextEditingController();
  final TextEditingController _carPriceController = TextEditingController();
  final TextEditingController _carMileageController = TextEditingController();
  final TextEditingController _carEngineCapacityController = TextEditingController();
  final TextEditingController _namePlateController = TextEditingController();

  // Feature toggles
  bool _isAutomatic = false;
  bool _hasAC = false;
  bool _hasGPS = false;
  bool _hasBluetooth = false;
  bool _hasRearCamera = false;
  bool _hasSunroof = false;

  // Dropdown options
  String? _selectedFuelType = 'Petrol'; // Default selection
  List<String> _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];

  String? _selectedTransmission = 'Manual'; // Default selection
  List<String> _transmissions = ['Manual', 'Automatic'];

  List<XFile> _carImages = [];
  final ImagePicker _picker = ImagePicker();
  final CarRepository _carRepository = CarRepository();

  // Save images locally
  Future<String> _saveImageLocally(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/${_namePlateController.text}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File localImage = await File(image.path).copy(path); // Save the image locally
    return localImage.path; // Return the file path
  }

  // Pick images for car
  Future<void> _pickImage() async {
    if (_carImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only upload up to 5 images')),
      );
      return;
    }

    final List<XFile>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _carImages.addAll(pickedImages.take(5 - _carImages.length)); // Allow up to 5 images
      });
    }
  }

  // Submit the form and add the car to the repository
  void _submitForm() async {
    if (_carNameController.text.isNotEmpty &&
        _carModelController.text.isNotEmpty &&
        _carYearController.text.isNotEmpty &&
        _carPriceController.text.isNotEmpty &&
        _namePlateController.text.isNotEmpty &&
        _carImages.isNotEmpty) {

      // Save images locally and get their paths
      List<String> imagePaths = [];
      for (var image in _carImages) {
        String imagePath = await _saveImageLocally(image);
        imagePaths.add(imagePath);
      }

      // Add the new car to the repository
      Car newCar = Car(
        id: _namePlateController.text, // Use name plate as ID
        name: _carNameController.text,
        imageUrl: imagePaths, // Store all image paths
        pricePerDay: _carPriceController.text,
        rating: '4.5', // Default rating
        details: 'Details about ${_carNameController.text}',
        features: [
          if (_hasAC) 'Air Conditioning',
          if (_hasGPS) 'GPS',
          if (_hasBluetooth) 'Bluetooth',
          if (_hasRearCamera) 'Rear Camera',
          if (_hasSunroof) 'Sunroof',
        ], // Only add selected features
        reviews: [],
        transmission: _selectedTransmission,
        fuelType: _selectedFuelType,
        passengerCapacity: 5,
        carType: _carModelController.text,
        mileage: _carMileageController.text,
        engineCapacity: _carEngineCapacityController.text,
        airConditioning: _hasAC,
        gps: _hasGPS,
        sunroof: _hasSunroof,
        bluetoothConnectivity: _hasBluetooth,
        rearCamera: _hasRearCamera,
        namePlate: _namePlateController.text, // Store name plate for display in detail screen
      );

      _carRepository.addCar(newCar); // Add car to the repository

      // Go back to the previous screen
      Navigator.pop(context);

      print("Car details submitted successfully with images.");
    } else {
      print("Please fill all fields and add at least one image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Car for Rent', style: TextStyle(color: Colors.white)),
        backgroundColor: swatch3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Upload images...
            if (_carImages.length < 5)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: swatch4),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: swatch5, size: 50),
                      SizedBox(height: 10),
                      Text('Upload Car Images', style: TextStyle(color: swatch5)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),

            // Display the selected images
            if (_carImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                itemCount: _carImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(File(_carImages[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _carImages.removeAt(index);
                            });
                          },
                          child: const Icon(Icons.remove_circle, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 10),

            // Form fields
            _buildTextField(controller: _carNameController, label: 'Car Name', icon: Icons.directions_car),
            const SizedBox(height: 16),
            _buildTextField(controller: _carModelController, label: 'Car Model', icon: Icons.model_training),
            const SizedBox(height: 16),
            _buildTextField(controller: _carYearController, label: 'Year of Manufacture', icon: Icons.calendar_today, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField(controller: _carPriceController, label: 'Price Per Day (₹)', icon: Icons.attach_money, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField(controller: _carMileageController, label: 'Mileage (km/l)', icon: Icons.speed, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField(controller: _carEngineCapacityController, label: 'Engine Capacity (cc)', icon: Icons.engineering, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField(controller: _namePlateController, label: 'Car Name Plate', icon: Icons.confirmation_number),
            const SizedBox(height: 20),

            // Dropdown for Fuel Type
            _buildDropdown(
              label: "Fuel Type",
              value: _selectedFuelType,
              items: _fuelTypes,
              onChanged: (value) {
                setState(() {
                  _selectedFuelType = value!;
                });
              },
            ),

            // Dropdown for Transmission
            _buildDropdown(
              label: "Transmission",
              value: _selectedTransmission,
              items: _transmissions,
              onChanged: (value) {
                setState(() {
                  _selectedTransmission = value!;
                });
              },
            ),

            // Toggle switches for additional features
            _buildFeatureSwitch("Air Conditioning (AC)", _hasAC, (value) {
              setState(() {
                _hasAC = value;
              });
            }),
            _buildFeatureSwitch("GPS Navigation", _hasGPS, (value) {
              setState(() {
                _hasGPS = value;
              });
            }),
            _buildFeatureSwitch("Bluetooth Connectivity", _hasBluetooth, (value) {
              setState(() {
                _hasBluetooth = value;
              });
            }),
            _buildFeatureSwitch("Rear Camera", _hasRearCamera, (value) {
              setState(() {
                _hasRearCamera = value;
              });
            }),
            _buildFeatureSwitch("Sunroof", _hasSunroof, (value) {
              setState(() {
                _hasSunroof = value;
              });
            }),

            const SizedBox(height: 20),

            // Submit button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: swatch3,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Submit Car Details', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for building text fields, dropdowns, and switches
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: Icon(Icons.local_gas_station, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      activeColor: swatch3,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
