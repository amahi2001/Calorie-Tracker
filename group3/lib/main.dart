import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
        child: Builder(builder: (context) {
          final controller = DefaultTabController.of(context)!;
          controller.addListener(() {
            if (controller.index == controller.length - 1) {
              print('swipe');
              showDialog<String>(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('AlertDialog Title'),
                  content: const Text('AlertDialog description'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        controller.animateTo(0);
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          });
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home_outlined), text: 'home'),
                  Tab(icon: Icon(Icons.history), text: 'Previous Days'),
                  TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: () {
                      showDialog<String>(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('AlertDialog Title'),
                          content: const Text('AlertDialog description'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Icon(
                          Icons.logout_outlined,
                          color: Color.fromARGB(180, 255, 255, 255),
                          size: 23,
                        ),
                      ),
                      Text(
                        'Log Out',
                        style: TextStyle(
                            color: Color.fromARGB(180, 255, 255, 255)),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                MealList(),
                PreviousDays(),
                SizedBox.shrink() // need a widget for the logout tab
              ],
            ),
          );
        }));
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
