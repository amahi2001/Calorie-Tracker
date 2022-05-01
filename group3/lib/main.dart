import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'auth.dart'; //authentication view
import 'nav_drawer.dart'; //navigation drawer/ sidebar
import 'previous_days.dart'; //previous days view

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style:
                  ElevatedButton.styleFrom(primary: Colors.blueAccent[400]))),
      home: const LoginPage(title: 'Calorie Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String food_name;
  late int calories;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: const [LogoutButton()],
      ),
      drawer: NavDrawer(), // this is our sidebar

      body: Center(
        child: Column(
          children: [
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
                onPressed: () async {
                  print("submitted");
                },
                child: Text('Log intake'))
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(
            builder: (context, constraints) => SizedBox(
                  width: constraints.maxWidth,
                  child: authenticatedFlipFlop(
                      authenticated: MyHomePage(title: title),
                      unauthenticated: const AuthGate()),
                )),
      );
}
