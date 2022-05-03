import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Food {
  Food({required this.name, required this.cal});

  Food.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          cal: json['cal']! as String,
        );

  final String name;
  String cal;

  Map<String, Object>? toJson() {
    return {'name': name, 'cal': cal};
  }
}

class Meal {
  Meal({required this.name, required this.date});

  Meal.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          date: json['date']! as String,
        );

  final String name;
  final String date;
  List<Food> foods = [];

  Map<String, Object?> toJson() {
    return {'name': name};
  }
}

Future<List<Meal>> getTodayData() async {
  List<Meal> todayMeals = [];

  if (FirebaseAuth.instance.currentUser != null) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DateTime now = DateTime.now();
    String today = Timestamp.fromDate(DateTime(now.year, now.month, now.day))
        .seconds
        .toString();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('meals')
        .where('date', isEqualTo: today)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        Meal meal = Meal.fromJson(doc.data());

        for (var i = 1; i <= 5; i++) {
          if (doc.data()['food$i']['name'] != '') {
            Food food = Food.fromJson(doc.data()['food$i']);
            if (food.cal == '') {
              food.cal = '0';
            }
            meal.foods.add(food);
          }
        }
        todayMeals.add(meal);
      });
    });
  }
  print('retrieved');
  return todayMeals;
}

void addMeal(String name, List<Food> foods) {
  final String _name = name;
  final List<Food> _foods = foods;

  DateTime now = DateTime.now();
  String today = Timestamp.fromDate(DateTime(now.year, now.month, now.day))
      .seconds
      .toString();
  if (FirebaseAuth.instance.currentUser != null) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    Meal newMeal = Meal(name: _name, date: today);

    List<Food> cleanedFoods = [];

    foods.forEach((element) {
      if (element.name.isNotEmpty && element.cal.isNotEmpty) {
        cleanedFoods.add(element);
        newMeal.foods.add(element);
      }
    });

    print(newMeal.foods.length);

    // String jsonFoods = jsonEncode({'food1': cleanedFoods});
    // print(jsonFoods);

    db.collection('users').doc(uid).collection('meals').add(
      {
        'date': today,
        'name': _name,
        'food1': {
          'cal': foods[0].cal,
          'name': foods[0].name,
        },
        'food2': {
          'cal': foods[1].cal,
          'name': foods[1].name,
        },
        'food3': {
          'cal': foods[2].cal,
          'name': foods[2].name,
        },
        'food4': {
          'cal': foods[3].cal,
          'name': foods[3].name,
        },
        'food5': {
          'cal': foods[4].cal,
          'name': foods[4].name,
        },
      },
    );
  }
}
