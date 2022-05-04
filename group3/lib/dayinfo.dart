import 'package:flutter/material.dart';
import 'package:group3/firestore.dart';

import 'mealcard.dart';

class DayInfo extends StatefulWidget {
  const DayInfo({Key? key, required this.selectedDay}) : super(key: key);

  final DateTime selectedDay;

  @override
  State<DayInfo> createState() => _DayInfo();
}

class _DayInfo extends State<DayInfo> {
  void retrieveData() {
    meals = getData(widget.selectedDay);
    setState(() {});
  }

  Future<List<Meal>> meals = Future.value([]);

  @override
  void initState() {
    super.initState();
    meals = getData(widget.selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: meals,
            builder: (context, AsyncSnapshot<List<Meal>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            child: CircularProgressIndicator.adaptive(),
                            width: 50,
                            height: 50,
                          )
                        ]
                    )
                );
              } else {
                int totalCal = 0;
                for (var meal in snapshot.data!) {
                  for (var food in meal.foods) {
                    totalCal = totalCal + int.parse(food.cal);
                  }
                }
                return Column(
                  children: [
                    TodayTotal(total: totalCal.toString(), max: '1400'),
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          child: const Text(
                            "Your previous meals",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          int calories = 0;
                          for (var food in snapshot.data![index].foods) {
                            calories = calories + int.parse(food.cal);
                          }
                          return MealCard(
                            id: snapshot.data![index].id,
                            name: snapshot.data![index].name,
                            calories: calories.toString(),
                            foods: snapshot.data![index].foods,
                            retrieveData: retrieveData,
                          );
                        },
                      ),
                    )
                  ],
                );
              }
            }));
  }
}

class TodayTotal extends StatefulWidget {
  const TodayTotal({
    Key? key,
    required this.total,
    required this.max,
  }) : super(key: key);

  @override
  State<TodayTotal> createState() => _TodayTotal();

  final String total;
  final String max;
}

class _TodayTotal extends State<TodayTotal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.blueAccent[400],
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: CircularProgressIndicator(
                              value: int.parse(widget.total) /
                                  int.parse(widget.max),
                              strokeWidth: 15,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(widget.total,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Daily Max: " + widget.max,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
