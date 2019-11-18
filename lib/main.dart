import 'package:flutter/material.dart';

import './home.dart';

// render our app
void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: Home(),
    );
  }
}