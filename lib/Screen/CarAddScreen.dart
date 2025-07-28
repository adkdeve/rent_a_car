import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../carModel/CarRepository.dart';
import '../carModel/Car.dart';
import '../globalContent.dart';
import 'dart:convert';

class CarAddScreen extends StatefulWidget {
  const CarAddScreen({super.key});

  @override
  _CarAddScreenState createState() => _CarAddScreenState();
}

class _CarAddScreenState extends State<CarAddScreen> {
  // Existing controllers
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carBrandController = TextEditingController(); // New controller for brand
  final TextEditingController _carPriceController = TextEditingController();
  final TextEditingController _carDescriptionController = TextEditingController(); // New controller for description
  final TextEditingController _carNamePlateController = TextEditingController();
  final TextEditingController _carColorController = TextEditingController();

  late bool _isLoading = false; // Add this variable to track loading state

  // Feature toggles
  bool _hasAC = false;
  bool _hasBluetooth = false;
  bool _hasSunroof = false;

  Future<String> _convertImageToBase64(XFile image) async {
    final bytes = await File(image.path).readAsBytes();
    return base64Encode(bytes);
  }

  // Dropdown options
  String? _selectedFuelType = 'Petrol'; // Default selection
  List<String> _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];

  String? _selectedTransmission = 'Manual'; // Default selection
  List<String> _transmissions = ['Manual', 'Automatic'];

  String? _selectedCarType; // Default selection for car type
  List<String> _carTypes = ['Sedan', 'SUV', 'Hatchback', 'Convertible', 'Truck']; // Define car types

  List<XFile> _carImages = [];
  final ImagePicker _picker = ImagePicker();
  final CarRepository _carRepository = CarRepository();

  // Save images locally
  Future<String> _saveImageLocally(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path =
        '${directory.path}/${_carNamePlateController.text}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File localImage = await File(image.path).copy(path);
    return localImage.path;
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
        _carBrandController.text.isNotEmpty &&
        _carPriceController.text.isNotEmpty &&
        _carDescriptionController.text.isNotEmpty &&
        _carNamePlateController.text.isNotEmpty &&
        _selectedCarType != null && // Validate car type
        _carImages.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show the loading indicator
      });

      try {
        // Convert images to Base64
        List<String> base64Images = [];
        for (var image in _carImages) {
          String base64Image = await _convertImageToBase64(image);
          base64Images.add(base64Image);
        }

        // Create the car object with the details
        Car newCar = Car(
          id: _carNamePlateController.text,
          name: _carNameController.text,
          brand: _carBrandController.text,
          imageUrl: base64Images,
          pricePerDay: _carPriceController.text,
          rating: '4.5', // Default rating
          description: _carDescriptionController.text,
          features: [
            if (_hasAC) 'Air Conditioning',
            if (_hasBluetooth) 'Bluetooth',
            if (_hasSunroof) 'Sunroof',
          ],
          reviews: [],
          reservations: [], // Initialize reservations as an empty list
          namePlate: _carNamePlateController.text,
          transmission: _selectedTransmission,
          fuelType: _selectedFuelType,
          carType: _selectedCarType ?? '', // Use selected car type here
          airConditioning: _hasAC,
          sunroof: _hasSunroof,
          bluetoothConnectivity: _hasBluetooth,
          color: _carColorController.text,
          isFeatured: true,
          ownerID: FirebaseAuth.instance.currentUser!.uid, // Use current user ID as owner
        );

        // Upload the car details to Firestore
        await _carRepository.addCarToFirestore(newCar);

        if (mounted) {
          Navigator.pop(context); // Navigate back after success
        }
      } catch (e) {
        print("Error adding car: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add car: $e")),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Hide the loading indicator
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and add at least one image.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Your Car for Rent',
          style: TextStyle(color: colorScheme.onPrimary), // Use onPrimary color for text
        ),
        backgroundColor: colorScheme.primary, // Use primary color for app bar background
      ),
      body: Stack(
        children: [
          _isLoading // Show loading indicator if the form is submitting
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                if (_carImages.length < 5)
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: colorScheme.surface, // Use surface color for background
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.onSurface.withOpacity(0.5), // Use onSurface color for border
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: colorScheme.onBackground, // Use onBackground color for icon
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Upload Car Images',
                            style: TextStyle(
                              color: colorScheme.onBackground, // Use onBackground color for text
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
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

                // Car detail form fields
                _buildTextField(controller: _carNameController, label: 'Car Name', icon: Icons.directions_car),
                const SizedBox(height: 16),
                _buildTextField(controller: _carBrandController, label: 'Car Brand', icon: Icons.branding_watermark),
                const SizedBox(height: 16),
                _buildTextField(controller: _carPriceController, label: 'Price Per Day (₹)', icon: Icons.attach_money, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(controller: _carDescriptionController, label: 'Description', icon: Icons.description),
                const SizedBox(height: 16),
                _buildTextField(controller: _carNamePlateController, label: 'Car Name Plate', icon: Icons.confirmation_number),
                const SizedBox(height: 16),
                _buildTextField(controller: _carColorController, label: 'Car Color', icon: Icons.color_lens),

                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                _buildDropdown(
                  label: "Car Type",
                  value: _selectedCarType,
                  items: _carTypes,
                  onChanged: (value) {
                    setState(() {
                      _selectedCarType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),

                // Feature toggles
                _buildFeatureSwitch("Air Conditioning (AC)", _hasAC, (value) {
                  setState(() {
                    _hasAC = value;
                  });
                }),
                _buildFeatureSwitch("Bluetooth Connectivity", _hasBluetooth, (value) {
                  setState(() {
                    _hasBluetooth = value;
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
                    backgroundColor: colorScheme.primary, // Use primary color for button background
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    'Submit Car Details',
                    style: TextStyle(
                      color: colorScheme.onPrimary, // Use onPrimary color for button text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for icon
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureSwitch(String label, bool value, Function(bool) onChanged) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SwitchListTile(
      title: Text(
        label,
        style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
      ),
      value: value,
      activeColor: colorScheme.primary, // Use primary color for switch
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
