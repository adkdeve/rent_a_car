// utils/date_utils.dart
String formatTimestamp(DateTime timestamp) {
  return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
}
