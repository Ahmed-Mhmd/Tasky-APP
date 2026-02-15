import 'package:flutter/material.dart';

class DateFormatter {
  static String format(BuildContext context, DateTime date) {
    final now = DateTime.now();

    if (_isSameDay(date, now)) {
      return "Today At ${TimeOfDay.fromDateTime(date).format(context)}";
    }

    if (_isSameDay(date, now.add(const Duration(days: 1)))) {
      return "Tomorrow At ${TimeOfDay.fromDateTime(date).format(context)}";
    }

    return "${date.day}/${date.month}/${date.year}";
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
