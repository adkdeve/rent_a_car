import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  bool _isAutomatic = false;
  bool _hasAC = false;
  bool _hasGPS = false;

  List<XFile> _carImages = []; // List to store images
  final ImagePicker _picker = ImagePicker();

  // Method to pick multiple images
  Future<void> _pickImage() async {
    if (_carImages.length >= 5) {
      // If the user has already selected 5 images, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only upload up to 5 images')),
      );
      return;
    }

    final List<XFile>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        // Add images but ensure the total does not exceed 5
        _carImages.addAll(pickedImages.take(5 - _carImages.length));
      });
    }
  }

  void _submitForm() {
    if (_carNameController.text.isNotEmpty &&
        _carModelController.text.isNotEmpty &&
        _carYearController.text.isNotEmpty &&
        _carPriceController.text.isNotEmpty &&
        _carImages.isNotEmpty) {
      // Handle successful submission and save data
      print("Car details submitted successfully with images");
    } else {
      // Handle form errors
      print("Please fill all fields and add at least one image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Car for Rent',style: TextStyle(color: Colors.white),),
        backgroundColor: swatch3, // Swatch 3 for AppBar background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Show upload icon if less than 5 images are uploaded
            if (_carImages.length < 5)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: swatch4), // Swatch 4 for border
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: swatch5, size: 50), // Swatch 5 for camera icon
                      SizedBox(height: 10),
                      Text('Upload Car Images', style: TextStyle(color: swatch5)), // Swatch 5 for text
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
                      // Button to remove an image
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
            const SizedBox(height: 20),
            _buildTextField(
              controller: _carNameController,
              label: 'Car Name',
              icon: Icons.directions_car,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _carModelController,
              label: 'Car Model',
              icon: Icons.model_training,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _carYearController,
              label: 'Year of Manufacture',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _carPriceController,
              label: 'Price Per Day (\R\s\.)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildFeatureSwitch('Automatic Transmission', _isAutomatic, (value) {
              setState(() {
                _isAutomatic = value;
              });
            }),
            _buildFeatureSwitch('Air Conditioning (AC)', _hasAC, (value) {
              setState(() {
                _hasAC = value;
              });
            }),
            _buildFeatureSwitch('GPS Navigation', _hasGPS, (value) {
              setState(() {
                _hasGPS = value;
              });
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: swatch3, // Swatch 3 for button background
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Submit Car Details',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a custom text field
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
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color, // Dynamic text color based on theme
      ),
    );
  }


  // Function to build a custom feature switch
  Widget _buildFeatureSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      activeColor: swatch3, // Swatch 3 for active switch color
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
