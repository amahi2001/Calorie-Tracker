import 'package:flutter/material.dart';
import 'package:group3/firestore.dart';

class DayInfo extends StatelessWidget {
  const DayInfo({Key? key, required this.meals, required this.date, required this.totalCalories})
      : super(key: key);
  final List<Meal> meals;
  final String date;
  final String totalCalories;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(date),
      ),
      body: Center(
        child: Column(
          children: [
            TodayTotal(total: totalCalories, max: '1500'),
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
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  int calories = 0;
                  for (var food in meals[index].foods) {
                    calories = calories + int.parse(food.cal);
                  }
                  return OldMealCard(
                    name: meals[index].name,
                    calories: calories.toString(),
                    foods: meals[index].foods,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TodayTotal extends StatelessWidget {
  const TodayTotal({Key? key, required this.total, required this.max})
      : super(key: key);
  final String total;
  final String max;

  @override
  Widget build(BuildContext context) {
    int numericalTotal = int.parse(total);
    int numericalMax = int.parse(max);
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
                              color: numericalTotal >= numericalMax ? Colors.red :
                                     numericalTotal >= numericalMax * .75 ? Colors.orange : null,
                              value: numericalTotal / numericalMax,
                              strokeWidth: 15,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(total,
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
                    "Daily Max: " + max,
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

class OldMealCard extends StatefulWidget {
  const OldMealCard(
      {Key? key,
      required this.name,
      required this.calories,
      required this.foods})
      : super(key: key);

  final String name;
  final String calories;
  final List<Food> foods;

  @override
  _OldMealCardState createState() => _OldMealCardState();
}

class _OldMealCardState extends State<OldMealCard> {
  _OldMealCardState();

  bool isTapped = false;

  void showMeals() {
    setState(() {
      isTapped = !isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          onTap: () {
            showMeals();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(widget.name),
                      subtitle: Text(widget.calories + " Calories"),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isTapped,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(50, 0, 100, 10),
                  child: Column(
                      children: List.generate(widget.foods.length, (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.foods[index].name),
                        Text(widget.foods[index].cal + ' Cal'),
                      ],
                    );
                  })),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
