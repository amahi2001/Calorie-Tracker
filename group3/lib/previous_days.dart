import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group3/dayinfo.dart';
import 'package:table_calendar/table_calendar.dart';

class Meal {
  final String title;
  Meal({required this.title});

  @override
  String toString() => title;
}

class PreviousDays extends StatefulWidget {
  const PreviousDays({Key? key}) : super(key: key);
  @override
  State<PreviousDays> createState() => _PreviousDaysState();
}

class _PreviousDaysState extends State<PreviousDays> {
  final TextEditingController _eventController = TextEditingController();
  late Map<DateTime, List<Meal>> selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Meal> _getEventsfromDay(DateTime day) {
    return selectedEvents[day] ?? [];
  }


  @override
  void dispose() {
    _eventController
        .dispose(); //event controller should stop when page is kills
    super.dispose();
  }

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TableCalendar(
            /* inputs vars */
            //first day is the day user signed up
            firstDay: FirebaseAuth.instance.currentUser!.metadata.creationTime!,
            //Last day is the last day of the current month
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            /* styling */
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent[400],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              todayDecoration: BoxDecoration(
                color: Colors.purple[400],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blueAccent[400],
                  borderRadius: BorderRadius.circular(5),
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.white,
                )),

            /* methods */

            eventLoader: _getEventsfromDay,

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DayInfo(
                              selectedDay: selectedDay,
                            )));
              }
            },
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
            onPageChanged: (focusedDay) => _focusedDay = focusedDay
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _getEventsfromDay(_selectedDay).length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Text(
                    _getEventsfromDay(_selectedDay)[index].toString(),
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Add Event'),
                  content: TextFormField(
                    controller: _eventController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Event Name',
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                        child: const Text('Add'),
                        onPressed: () {
                          if (_eventController.text.isEmpty) {
                            //if event name is empty => do nothing

                          } else {
                            //if event name is not empty => add event
                            if (selectedEvents[_selectedDay] != null) {
                              //if there is already an event on that day
                              selectedEvents[_selectedDay]!
                                  .add(Meal(title: _eventController.text));
                            } else {
                              //if there is no event on that day
                              selectedEvents[_selectedDay] = [
                                Meal(title: _eventController.text)
                              ];
                            }
                          }
                          Navigator.pop(context);
                          _eventController.clear();
                          setState(() {});
                          return;
                        }),
                  ],
                ),
              ),
          label: const Text('Add event (for testing)')),
    );
  }
}
