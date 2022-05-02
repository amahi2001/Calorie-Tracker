import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'appbar.dart';
import 'firebase_options.dart';

import 'auth.dart'; //authentication view
import 'nav_drawer.dart'; //navigation drawer/ sidebar

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
      home: const HomePage(title: 'Calorie Tracker'),
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
  late String foodName;
  late int calories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: widget.title),
      drawer: const NavDrawer(),
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

void intakeSubmitted() async => print("Submitted");

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: title),
      body: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
                width: constraints.maxWidth,
                child: const AuthGate(),
              )),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return authenticatedFlipFlop(
        authenticated: MyHomePage(title: title),
        unauthenticated: LoginPage(title: title));
  }
}
