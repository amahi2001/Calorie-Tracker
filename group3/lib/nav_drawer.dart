import 'package:flutter/material.dart';
import 'previous_days.dart'; //previous days view

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
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
            leading: Icon(Icons.calendar_today),
            title: Text('Previous Days'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreviousDays()),
              )
            },
          ),
        ],
      ),
    );
  }
}
