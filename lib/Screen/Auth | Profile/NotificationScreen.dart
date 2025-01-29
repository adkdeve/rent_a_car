import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/NotificationProvider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationProvider(),
      child: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.userId.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Error: User not logged in.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
            body: provider.notifications.isEmpty
                ? _buildNoNotificationsWidget()
                : _buildNotificationsList(context, provider),
          );
        },
      ),
    );
  }

  // Widget for displaying the notifications list
  Widget _buildNotificationsList(
      BuildContext context, NotificationProvider provider) {
    return ListView.builder(
      itemCount: provider.notifications.length,
      itemBuilder: (context, index) {
        final notification = provider.notifications[index].data() as Map<String, dynamic>;
        final notificationId = provider.notifications[index].id;
        final title = notification['title'] ?? 'Notification';
        final message = notification['message'] ?? 'No details';
        final timestamp = (notification['timestamp'] as Timestamp).toDate();
        final carId = notification['carId'];
        final bookingId = notification['bookingId'];
        final isRead = notification['isRead'] ?? false; // Check if the notification is read

        return Dismissible(
          key: Key(notificationId),
          onDismissed: (direction) async {
            await provider.deleteNotification(notificationId); // Delete from Firebase
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          direction: DismissDirection.startToEnd, // Swipe left to delete
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: isRead ? Colors.grey[200] : Colors.white, // Mark read notifications with different color
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(
                Icons.notifications,
                color: Colors.green,
                size: 30,
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTimestamp(timestamp), // You can still use the utility method
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              onTap: () {
                provider.handleNotificationTap(context, carId, bookingId, provider.userId, notificationId); // Mark as read on tap
              },
            ),
          ),
        );
      },
    );
  }

  // Utility function to format timestamp (if needed)
  String formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute}';
  }

  // Widget for displaying when no notifications are present
  Widget _buildNoNotificationsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
