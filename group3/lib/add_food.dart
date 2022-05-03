import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AddFood extends StatefulWidget {
  const AddFood({Key? key}) : super(key: key);

  @override
  State<AddFood> createState() => AddFoodState();
}

class AddFoodState extends State<AddFood> {
  late String foodName;
  late int calories;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState(){
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView (
        children:  [
          Text(user.uid),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter Food Item',
            ),
            onChanged: (value) {
              foodName = value;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter Calorie value',
            ),
            keyboardType: TextInputType.number,
            onChanged: 
              (value) {
                calories = int.parse(value);
              },
          ),
          ElevatedButton(
              onPressed:() async {
                await FirebaseFirestore.instance.collection(user.uid).doc().set({
                  'dish': foodName,
                  'calories': calories,
                  'date' : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                });
              },
              child: Text('Log intake')
          )
        ],
      )
    );
  }
}
