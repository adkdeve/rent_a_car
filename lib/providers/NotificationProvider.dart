import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screen/booking/BookingDetailsScreen.dart';

class NotificationProvider with ChangeNotifier {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<QueryDocumentSnapshot> notifications = [];

  NotificationProvider() {
    if (userId.isNotEmpty) {
      _fetchNotifications();
    }
  }

  // Fetch notifications for the current user
  Future<void> _fetchNotifications() async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        notifications = snapshot.docs;
        notifyListeners();
      });
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  // Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({
        'isRead': true,
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Handle notification tap (mark as read)
  void handleNotificationTap(BuildContext context, String? carId, String? bookingId, String userId, String notificationId) async {
    markNotificationAsRead(notificationId); // Mark notification as read when tapped

    if (carId != null && carId.isNotEmpty && bookingId != null && bookingId.isNotEmpty) {
      try {
        // Fetch the notification details to get the status and type
        final notificationDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .doc(notificationId)
            .get();

        if (notificationDoc.exists) {
          final notificationData = notificationDoc.data() as Map<String, dynamic>;
          final status = notificationData['status'] ?? 'pending'; // Default to 'pending' if status is null
          final type = notificationData['type'] ?? 'unknown'; // Default to 'unknown' if type is null

          // Navigate to BookingDetailsScreen with the status and type
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailsScreen(
                carId: carId,
                bookingId: bookingId,
                currentUserId: userId,
                status: status, // Pass status
                type: type,     // Pass type
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification not found.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid booking or car ID.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
