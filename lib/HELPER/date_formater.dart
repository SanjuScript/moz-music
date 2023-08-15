import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatAudioDate(int millisecondsSinceEpoch) {
  final now = DateTime.now();
  final dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    if (difference.inHours == 0) {
      if (difference.inMinutes == 0) {
        return '${difference.inSeconds} seconds ago';
      }
      return '${difference.inMinutes} minutes ago';
    }
    return '${difference.inHours} hours ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    final daysAgo = difference.inDays;
    return '$daysAgo days ago';
  }
}

