import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PreviousDays extends StatefulWidget {
  const PreviousDays({Key? key}) : super(key: key);
  @override
  State<PreviousDays> createState() => _PreviousDaysState();
}

class _PreviousDaysState extends State<PreviousDays> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  late User user;
  //date the user Created the account
  late DateTime user_creation_date;
  //last day of current month
  DateTime final_date =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    user_creation_date = user.metadata.creationTime!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Previous Days')),
        body: TableCalendar(
          //first day is the day user signed up
          firstDay: user_creation_date,
          //Last day is the last day of the current month
          lastDay: final_date,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            // Use `selectedDayPredicate` to determine which day is currently selected.
            // If this returns true, then `day` will be marked as selected.

            // Using `isSameDay` is recommended to disregard
            // the time-part of compared DateTime objects.
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
            print('Selected day $selectedDay');
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
        ));
  }
}
