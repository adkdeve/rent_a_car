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
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final textTheme = theme.textTheme;

          if (provider.userId.isEmpty) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Error: User not logged in.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Notifications',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
              backgroundColor: colorScheme.primary,
              elevation: 0,
            ),
            body: provider.notifications.isEmpty
                ? _buildNoNotificationsWidget(colorScheme, textTheme)
                : _buildNotificationsList(context, provider, colorScheme, textTheme),
          );
        },
      ),
    );
  }

  // Widget for displaying the notifications list
  Widget _buildNotificationsList(
      BuildContext context,
      NotificationProvider provider,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
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
            color: colorScheme.error,
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
            color: isRead ? colorScheme.surfaceVariant : colorScheme.surface, // Mark read notifications with different color
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(
                Icons.notifications,
                color: colorScheme.primary,
                size: 30,
              ),
              title: Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTimestamp(timestamp), // You can still use the utility method
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
  Widget _buildNoNotificationsWidget(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet.',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}