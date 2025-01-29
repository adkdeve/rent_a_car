import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../carModel/Car.dart';
import 'CarDetailScreen.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String carId;
  final String bookingId;
  final String currentUserId;
  final String status; // Status of the booking
  final String type; // Type of notification (booking_request, owner_response, etc.)

  const BookingDetailsScreen({
    Key? key,
    required this.carId,
    required this.bookingId,
    required this.currentUserId,
    required this.status,
    required this.type, // Accept type as a parameter
  }) : super(key: key);

  Future<void> _updateBookingStatus(String status, BuildContext context) async {
    try {
      // Fetch the booking document
      final bookingDoc = await FirebaseFirestore.instance.collection('bookings').doc(bookingId).get();
      if (!bookingDoc.exists) {
        throw 'Booking not found.';
      }

      final booking = bookingDoc.data() as Map<String, dynamic>;

      // Update the booking status
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({'status': status});

      // Notify the renter
      final String renterId = booking['renterId'];
      await FirebaseFirestore.instance
          .collection('users')
          .doc(renterId)
          .collection('notifications')
          .add({
        'title': 'Booking ${status == 'accepted' ? 'Accepted' : 'Rejected'}',
        'message': 'Your booking for the car has been ${status == 'accepted' ? 'accepted' : 'rejected'}.',
        'type': 'owner_response', // Marking as "owner_response"
        'carId': carId,
        'bookingId': bookingId,
        'status': status,
        'isRead': false,  // New field added to track read status
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking ${status == 'accepted' ? 'accepted' : 'rejected'} successfully.'),
          backgroundColor: status == 'accepted' ? Colors.green : Colors.red,
        ),
      );

      Navigator.pop(context); // Go back to notifications
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update booking status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // Now you can use 'type' anywhere in your UI logic
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('bookings').doc(bookingId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Booking details not found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final booking = snapshot.data!.data() as Map<String, dynamic>;

          final isBookingRequest = type == 'booking_request'; // Now using 'type' parameter

          // Determine the status color based on the passed status value
          Color statusColor;
          String statusText;
          Color statusIconColor;

          switch (status) {
            case 'accepted':
              statusColor = Colors.green;
              statusText = 'Accepted';
              statusIconColor = Colors.green;
              break;
            case 'rejected':
              statusColor = Colors.red;
              statusText = 'Rejected';
              statusIconColor = Colors.red;
              break;
            default:
              statusColor = Colors.orange;
              statusText = 'Pending';
              statusIconColor = Colors.orange;
              break;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking Information',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(Icons.directions_car, 'Car Name', booking['carId']),
                        _buildDetailRow(Icons.person, 'Renter Name', booking['renterDetails']['name']),
                        _buildDetailRow(Icons.phone, 'Phone Number', booking['renterDetails']['phoneNumber']),
                        _buildDetailRow(Icons.calendar_today, 'Pickup Date', booking['pickupDate'].toDate().toString()),
                        _buildDetailRow(Icons.calendar_today, 'Drop-off Date', booking['dropOffDate'].toDate().toString()),
                        _buildDetailRow(Icons.timer, 'Duration', '${booking['duration']} days'),
                        _buildDetailRow(Icons.attach_money, 'Total Amount', '₹${booking['totalAmount']}'),
                        const SizedBox(height: 16),
                        _buildStatusRow(statusIconColor, statusText, statusColor), // Use the passed status
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (isBookingRequest) // Only show the buttons if it's a booking request
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _updateBookingStatus('accepted', context),
                          icon: const Icon(Icons.check),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _updateBookingStatus('rejected', context),
                          icon: const Icon(Icons.close),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                if (label == 'Car Name') // Add "View" button for the Car Name
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.directions_car),
                          onPressed: () => _navigateToCarDetailScreen(context, value),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // New Widget to display the booking status
  Widget _buildStatusRow(Color iconColor, String statusText, Color textColor) {
    return Row(
      children: [
        Icon(Icons.assignment_turned_in, color: iconColor), // Status icon
        const SizedBox(width: 16),
        Text(
          'Status: '
              '$statusText',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }

  void _navigateToCarDetailScreen(BuildContext context, String carId) async {
    try {
      final carDoc = await FirebaseFirestore.instance.collection('cars').doc(carId).get();
      if (!carDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Car not found.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Parse the car data into the Car model
      final carData = carDoc.data() as Map<String, dynamic>;
      final car = Car.fromFirestore(carData, carId);

      // Navigate to CarDetailScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarDetailScreen(car: car),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load car details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
