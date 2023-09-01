import 'package:intl/intl.dart';

String abbreviateNumber(dynamic number) {
  if (number is int) {
    number = double.parse(number.toString());
  }
  if (number == null) return '';
  if (number < 1000) {
    return number.toStringAsFixed(
        0); // No abbreviation needed for numbers less than 1000
  } else if (number < 10000) {
    return '${(number / 1000).toStringAsFixed(1)}K'; // Abbreviate as "X.XK" for thousands
  } else if (number < 1000000) {
    return '${(number / 1000).toStringAsFixed(0)}K'; // Abbreviate as "XXK" for thousands
  } else if (number < 10000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M'; // Abbreviate as "X.XM" for millions
  } else {
    return '${(number / 1000000).toStringAsFixed(0)}M'; // Abbreviate as "XXM" for millions
  }
}

String formatTimeAgoFromString(String? dateString) {
  if (dateString == null) return '';
  dateString = dateString.split(' +')[0];
  final timestamp = DateTime.parse(dateString);
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else if (now.year == timestamp.year) {
    final format = DateFormat('MMMM d');
    return format.format(timestamp);
  } else {
    final format = DateFormat('MMMM d, y');
    return format.format(timestamp);
  }
}
