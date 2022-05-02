import 'package:flutter/material.dart';

void intakeSubmitted() async => print("Submitted");

class AddFood extends StatefulWidget {
  const AddFood({Key? key}) : super(key: key);

  @override
  State<AddFood> createState() => AddFoodState();
}

class AddFoodState extends State<AddFood> {
  late String foodName;
  late int calories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: const [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Food Item',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Calorie value',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                  onPressed: intakeSubmitted,
                  child: Text('Log intake')
              )
            ],
          ),
        )
    );
  }
}
