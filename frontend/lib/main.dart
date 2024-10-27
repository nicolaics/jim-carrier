import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/src/screens/bottom_bar.dart';
import 'package:jim/src/screens/home_page.dart';
import 'package:jim/src/screens/profile_screen.dart';
import 'package:jim/src/screens/register_screen.dart';
import 'package:jim/src/screens/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
