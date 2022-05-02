import 'package:flutter/material.dart';
import 'previous_days.dart'; //previous days view

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: const Text(
              'Side Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent[400],
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: AssetImage('assets/images/cover.jpg')
              //     )
            ),
          ),
          ListTile(
            //for previous days
            leading: const Icon(Icons.calendar_today),
            title: const Text('Previous Days'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreviousDays()),
              )
            },
          ),
        ],
      ),
    );
  }
}
