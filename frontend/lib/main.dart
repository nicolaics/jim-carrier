import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jim/firebase_options.dart';
import 'package:jim/src/screens/welcome.dart';
import 'package:jim/src/screens/home/home_page.dart';
import 'package:jim/src/screens/order/previous_order.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
