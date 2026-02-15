import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasky_app/features/home/widgets/custom_save_cancel_widget.dart';

class AppDatePicker {
  static Future<DateTime?> pick(BuildContext context, DateTime initialDate) {
    DateTime selectedDay = initialDate;
    DateTime focusedDay = initialDate;

    return showDialog<DateTime>(
      context: context,
      barrierColor: const Color(0x8A000000),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// HEADER
                    Text(
                      _monthName(focusedDay.month).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${focusedDay.year}"),

                    const SizedBox(height: 10),

                    
                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 30)),
                      focusedDay: focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(selectedDay, day),

                      onDaySelected: (selected, focused) {
                        setState(() {
                          selectedDay = selected;
                          focusedDay = focused;
                        });
                      },

                      headerVisible: false,

                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF673AB7),
                          borderRadius: BorderRadius.circular(6),
                        ),

                        selectedDecoration: BoxDecoration(
                          color: const Color(0xFF5F33E1),
                          borderRadius: BorderRadius.circular(6),
                        ),

                        defaultDecoration: BoxDecoration(
                          color: const Color(0xFF272727),
                          borderRadius: BorderRadius.circular(6),
                        ),

                        weekendDecoration: BoxDecoration(
                          color: const Color(0xFF272727),
                          borderRadius: BorderRadius.circular(6),
                        ),

                        outsideDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),

                        disabledDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),

                        defaultTextStyle: const TextStyle(
                          color: Color(0xFFE3E3E3),
                        ),

                        weekendTextStyle: const TextStyle(
                          color: Color(0xFFE3E3E3),
                        ),

                        selectedTextStyle: const TextStyle(
                          color: Color(0xFFEAE4FB),
                        ),

                        todayTextStyle: const TextStyle(
                          color: Color(0xFFEAE4FB),
                        ),

                        outsideTextStyle: const TextStyle(
                          color: Color(0xFFBDBDBD),
                        ),

                        disabledTextStyle: const TextStyle(
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTONS
                    CustomSaveCancelWidget(selectedValue: selectedDay),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  static String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
