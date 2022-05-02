import 'package:flutter/material.dart';

void intakeSubmitted() async => print("Submitted");

class add_food extends StatefulWidget {
  const add_food({Key? key}) : super(key: key);

  @override
  State<add_food> createState() => _add_foodState();
}

class _add_foodState extends State<add_food> {
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
