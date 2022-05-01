import 'package:flutter/material.dart';

//view previous days of calorie intake

class PreviousDays extends StatelessWidget {
  const PreviousDays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Days'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const []
        ),
      ),
    );
  }
}