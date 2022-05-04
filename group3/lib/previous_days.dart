import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dayinfo.dart';
import 'firestore.dart';

GlobalKey<_Quickview> globalKey = GlobalKey();

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
                globalKey.currentState!.retrieveData(selectedDay);
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
            onPageChanged: (focusedDay) => _focusedDay = focusedDay
          ),
          QuickView(
            selectedDay: _selectedDay,
            key: globalKey,
          ),
        ],
      ),
    );
  }
}

class QuickView extends StatefulWidget {
  const QuickView({Key? key, required this.selectedDay}) : super(key: key);

  final DateTime selectedDay;
  @override
  State<QuickView> createState() => _Quickview();
}

class _Quickview extends State<QuickView> {
  Future<List<Meal>> meals = Future.value([]);

  void retrieveData(DateTime selectedDay) {
    meals = getData(selectedDay);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    meals = getData(widget.selectedDay);
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: meals,
        builder: (context, AsyncSnapshot<List<Meal>> snapshot) {
          if (!snapshot.hasData) {
            return Text('Select a Day');
          } else {
            int TotalCal = 0;
            for (var meal in snapshot.data!) {
              for (var food in meal.foods) {
                TotalCal = TotalCal + int.parse(food.cal);
              }
            }
            // List meals = [];
            return Column(
              children: [
                const Divider(
                  height: 30,
                  thickness: 1,
                  color: Color.fromARGB(50, 0, 0, 0),
                ),
                QuickViewCard(
                  numberOfMeals: (snapshot.data?.length ?? 0).toString(),
                  totalCal: TotalCal.toString(),
                  meals: snapshot.data!,
                  selectedDay: widget.selectedDay,
                ),
              ],
            );
          }
        });
  }
}

class QuickViewCard extends StatelessWidget {
  const QuickViewCard(
      {Key? key,
      required this.numberOfMeals,
      required this.totalCal,
      required this.meals,
      required this.selectedDay})
      : super(key: key);

  final List<Meal> meals;
  final String numberOfMeals;
  final String totalCal;
  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    if (totalCal != '0') {
      return Center(
          child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.dining_outlined),
              title: Text("Total Calories: " + totalCal),
              subtitle: Text(numberOfMeals + ' meals'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('DETAILS'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DayInfo(
                                  meals: meals,
                                  date: DateFormat('EEEE, MMM d, yyyy')
                                      .format(selectedDay),
                                )));
                  },
                ),
                const SizedBox(width: 8),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ));
    } else {
      return Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.dining_outlined),
                title: Text("No meals logged on this day"),
                subtitle: Text(numberOfMeals + ' meals'),
              )
            ],
          ),
        ),
      );
    }
  }
}
