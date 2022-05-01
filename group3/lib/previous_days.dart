import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'nav_drawer.dart'; //navigation drawer/ sidebar



class PreviousDays extends StatefulWidget {
  @override
  State<PreviousDays> createState() => _PreviousDaysState();
}

class _PreviousDaysState extends State<PreviousDays> {
  
  final User = FirebaseAuth.instance.currentUser;
  late DateTime creationDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  @override
  void initState() {
    super.initState();
    if(User!.metadata.creationTime != null) {
      creationDate = User!.metadata.creationTime!;
    }
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Previous Days'),
        ),
        body: TableCalendar(
          focusedDay: DateTime.now(),
          //first day is the day user signed up
          firstDay: creationDate,
          //Last day is the last day of the current month
          lastDay: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
        ));
  }
}
