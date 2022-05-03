import 'package:flutter/material.dart';
import 'package:group3/firestore.dart';

class NewMeal extends StatefulWidget {
  @override
  _NewMealState createState() => _NewMealState();
}

class _NewMealState extends State<NewMeal> {
  final _formKey = GlobalKey<FormState>();
  _NewMealState();
  String MealName = '';

  final TextEditingController foodController1 = TextEditingController();
  final TextEditingController caloriesController1 = TextEditingController();
  final TextEditingController foodController2 = TextEditingController();
  final TextEditingController caloriesController2 = TextEditingController();
  final TextEditingController foodController3 = TextEditingController();
  final TextEditingController caloriesController3 = TextEditingController();
  final TextEditingController foodController4 = TextEditingController();
  final TextEditingController caloriesController4 = TextEditingController();
  final TextEditingController foodController5 = TextEditingController();
  final TextEditingController caloriesController5 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("New Meal"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    MealName = value;
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Meal Name',
                  ),
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              NewFoodField(
                  foodController: foodController1,
                  caloriesController: caloriesController1),
              NewFoodField(
                  foodController: foodController2,
                  caloriesController: caloriesController2),
              NewFoodField(
                  foodController: foodController3,
                  caloriesController: caloriesController3),
              NewFoodField(
                  foodController: foodController4,
                  caloriesController: caloriesController4),
              NewFoodField(
                  foodController: foodController5,
                  caloriesController: caloriesController5),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(MealName)),
                    );
                    Food food1 = Food(
                        name: foodController1.text,
                        cal: caloriesController1.text);
                    Food food2 = Food(
                        name: foodController2.text,
                        cal: caloriesController2.text);
                    Food food3 = Food(
                        name: foodController3.text,
                        cal: caloriesController3.text);
                    Food food4 = Food(
                        name: foodController4.text,
                        cal: caloriesController4.text);
                    Food food5 = Food(
                        name: foodController5.text,
                        cal: caloriesController5.text);

                    List<Food> foods = [food1, food2, food3, food4, food5];
                    addMeal(MealName, foods);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ));
  }
}

class NewFoodField extends StatelessWidget {
  const NewFoodField(
      {Key? key,
      required this.foodController,
      required this.caloriesController})
      : super(key: key);

  final TextEditingController foodController;
  final TextEditingController caloriesController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: TextFormField(
              controller: foodController,
              validator: (value) {
                if (value != null || value!.isNotEmpty) {
                  return null;
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Food',
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Container(
              margin: EdgeInsets.all(4),
              child: TextFormField(
                controller: caloriesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Calories',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
