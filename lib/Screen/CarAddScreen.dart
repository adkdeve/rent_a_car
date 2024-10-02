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
  XFile? _carImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _carImage = image;
    });
  }

  void _submitForm() {
    // Implement form submission logic here
    if (_carNameController.text.isNotEmpty &&
        _carModelController.text.isNotEmpty &&
        _carYearController.text.isNotEmpty &&
        _carPriceController.text.isNotEmpty &&
        _carImage != null) {
      // Handle successful submission
      print("Car added successfully");
    } else {
      // Handle form errors
      print("Please fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Car for Rent'),
        backgroundColor: swatch3, // Swatch 3 for AppBar background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: swatch4), // Swatch 4 for border
                  image: _carImage != null
                      ? DecorationImage(
                    image: FileImage(File(_carImage!.path)),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _carImage == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: swatch5, size: 50), // Swatch 5 for camera icon
                    SizedBox(height: 10),
                    Text('Upload Car Image', style: TextStyle(color: swatch5)), // Swatch 5 for text
                  ],
                )
                    : null,
              ),
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
              label: 'Price Per Day (\$)',
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
              child: const Text('Submit Car Details'),
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
  })
  {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: swatch5), // Swatch 5 for icon color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
