import 'package:flutter/material.dart';

import 'auth.dart';

PreferredSizeWidget appBar({required title}) => AppBar(
  // Here we take the value from the MyHomePage object that was created by
  // the App.build method, and use it to set our appbar title.
  title: Text(title),
  actions: const [LogoutButton()],
);