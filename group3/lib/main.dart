import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'appbar.dart';
import 'firebase_options.dart';

import 'auth.dart'; //authentication view
import 'previous_days.dart'; //previous days view
import 'mainscreen.dart'; //main screen view




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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.dinner_dining), text: 'Add Food'),
                Tab(icon: Icon(Icons.history), text: 'Previous Days'),
                Tab(icon: Icon(Icons.logout), text: 'Logout',),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MealList(),
              PreviousDays(),
              LogoutButton(),
            ],
          ),
        )
      );
  }
}

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
