import 'package:flutter/material.dart';
import 'package:group3/firestore.dart';

class MealCard extends StatefulWidget {
  const MealCard(
      {Key? key,
      required this.retrieveData,
      required this.id,
      required this.name,
      required this.calories,
      required this.foods})
      : super(key: key);

  final Function retrieveData;
  final String name;
  final String calories;
  final List<Food> foods;
  final String id;

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  _MealCardState();

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
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    iconSize: 20,
                    tooltip: 'Increase volume by 10',
                    onPressed: () {
                      deleteMeal(widget.id);
                      widget.retrieveData();
                    },
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
