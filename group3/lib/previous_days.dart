import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PreviousDays extends StatelessWidget {
  const PreviousDays({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Previous Days')),
        body: TableCalendar(
          focusedDay: DateTime.now(),
          //first day is the day user signed up
          firstDay: FirebaseAuth.instance.currentUser!.metadata.creationTime!,
          //Last day is the last day of the current month
          lastDay: DateTime.now(),
        ));
  }
}
