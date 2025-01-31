import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../carModel/Car.dart';

class BookingProcessScreen extends StatefulWidget {
  final Car car;

  const BookingProcessScreen({Key? key, required this.car}) : super(key: key);

  @override
  _BookingProcessScreenState createState() => _BookingProcessScreenState();
}

class _BookingProcessScreenState extends State<BookingProcessScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _pickupDate;
  DateTime? _dropOffDate;
  TimeOfDay? _pickupTime;
  TimeOfDay? _dropOffTime;

  int _duration = 0;
  double _totalAmount = 0.0;

  String _name = "";
  String _phoneNumber = "";

  bool _isLoading = false;

  List<Map<String, dynamic>> _unavailableDates = [];

  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _dropOffDateController = TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _dropOffTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUnavailableDates();
    _loadUserProfile();
  }

  Future<void> _fetchUnavailableDates() async {
    final carDoc = await FirebaseFirestore.instance
        .collection('cars')
        .doc(widget.car.id)
        .get();

    if (carDoc.exists) {
      setState(() {
        _unavailableDates = List<Map<String, dynamic>>.from(carDoc['reservations'] ?? []);
      });
    }
  }

  Future<void> _loadUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        _name = userDoc['name'] ?? '';
        _phoneNumber = userDoc['phoneNumber'] ?? '';
      });
    }
  }

  bool _isDateUnavailable(DateTime date) {
    for (var reservation in _unavailableDates) {
      DateTime resStart = (reservation['startDate'] as Timestamp).toDate();
      DateTime resEnd = (reservation['endDate'] as Timestamp).toDate();
      if (!(date.isBefore(resStart) || date.isAfter(resEnd))) {
        return true;
      }
    }
    return false;
  }

  void _calculateTotalAmount() {
    if (_pickupDate != null && _dropOffDate != null) {
      setState(() {
        _duration = _dropOffDate!.difference(_pickupDate!).inDays + 1;
        _totalAmount = _duration * double.parse(widget.car.pricePerDay.replaceAll('Rs', ''));
      });
    }
  }

  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickupDate == null || _dropOffDate == null || _pickupTime == null || _dropOffTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select pickup and drop-off dates and times.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final currentUser = FirebaseAuth.instance.currentUser;

    final pickupDateTime = DateTime(
      _pickupDate!.year,
      _pickupDate!.month,
      _pickupDate!.day,
      _pickupTime!.hour,
      _pickupTime!.minute,
    );

    final dropOffDateTime = DateTime(
      _dropOffDate!.year,
      _dropOffDate!.month,
      _dropOffDate!.day,
      _dropOffTime!.hour,
      _dropOffTime!.minute,
    );

    final booking = {
      'carId': widget.car.id,
      'carName': widget.car.name,
      'renterId': currentUser!.uid,
      'ownerId': widget.car.ownerID,
      'pickupDate': pickupDateTime,
      'dropOffDate': dropOffDateTime,
      'duration': _duration,
      'totalAmount': _totalAmount,
      'status': 'pending',
      'renterDetails': {
        'name': _name,
        'phoneNumber': _phoneNumber,
      },
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      final bookingRef = await FirebaseFirestore.instance.collection('bookings').add(booking);

      await FirebaseFirestore.instance.collection('cars').doc(widget.car.id).update({
        'reservations': FieldValue.arrayUnion([
          {'startDate': pickupDateTime, 'endDate': dropOffDateTime}
        ]),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.car.ownerID)
          .collection('notifications')
          .add({
        'title': 'New Booking Request',
        'message': '$_name has requested to book your car ${widget.car.name}.',
        'type': 'booking_request',
        'carId': widget.car.id,
        'bookingId': bookingRef.id,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Booking Confirmed"),
          content: const Text("Your booking request has been sent to the owner."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm booking: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isPickup) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isPickup) {
          _pickupTime = pickedTime;
          _pickupTimeController.text = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
        } else {
          _dropOffTime = pickedTime;
          _dropOffTimeController.text = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
        }
        _calculateTotalAmount();
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _pickupDateController.dispose();
    _dropOffDateController.dispose();
    _pickupTimeController.dispose();
    _dropOffTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Process"),
        backgroundColor: colorScheme.primary, // Use primary color for app bar background
        foregroundColor: colorScheme.onPrimary, // Use onPrimary color for text and icons
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Book Your ${widget.car.name}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground, // Use onBackground color for text
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for label
                ),
                style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                onChanged: (value) => _name = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for label
                ),
                style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
                validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                onChanged: (value) => _phoneNumber = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pickupDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Pickup Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for icon
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for label
                ),
                style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
                onTap: () async {
                  DateTime initialDate = DateTime.now();
                  DateTime firstDate = DateTime.now();
                  DateTime lastDate = DateTime.now().add(const Duration(days: 365));

                  while (_isDateUnavailable(initialDate) && initialDate.isBefore(lastDate)) {
                    initialDate = initialDate.add(const Duration(days: 1));
                  }

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    selectableDayPredicate: (date) => !_isDateUnavailable(date),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _pickupDate = pickedDate;
                      _pickupDateController.text = '${pickedDate.toLocal()}'.split(' ')[0];
                      _calculateTotalAmount();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectTime(context, true),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _pickupTimeController,
                    decoration: InputDecoration(
                      labelText: "Pickup Time",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for icon
                      labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for label
                    ),
                    style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dropOffDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Drop-off Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for icon
                  labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for label
                ),
                style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
                onTap: () async {
                  DateTime initialDate = _pickupDate ?? DateTime.now();
                  DateTime firstDate = _pickupDate ?? DateTime.now();
                  DateTime lastDate = DateTime.now().add(const Duration(days: 365));

                  while (_isDateUnavailable(initialDate) && initialDate.isBefore(lastDate)) {
                    initialDate = initialDate.add(const Duration(days: 1));
                  }

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    selectableDayPredicate: (date) => !_isDateUnavailable(date),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _dropOffDate = pickedDate;
                      _dropOffDateController.text = '${pickedDate.toLocal()}'.split(' ')[0];
                      _calculateTotalAmount();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectTime(context, false),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dropOffTimeController,
                    decoration: InputDecoration(
                      labelText: "Drop-off Time",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time, color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for icon
                      labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)), // Use onSurface color for label
                    ),
                    style: TextStyle(color: colorScheme.onBackground), // Use onBackground color for text
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total Duration: $_duration days',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onBackground, // Use onBackground color for text
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Amount: Rs$_totalAmount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground, // Use onBackground color for text
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: colorScheme.primary, // Use primary color for button background
                  ),
                  child: Text(
                    "Confirm Booking",
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onPrimary, // Use onPrimary color for button text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}