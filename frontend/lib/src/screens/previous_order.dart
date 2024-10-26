import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Previous_Order_Screen extends StatefulWidget {
  const Previous_Order_Screen({super.key});
  @override
  State<Previous_Order_Screen> createState() => _Previous_Order_ScreenState();
}

class _Previous_Order_ScreenState extends State<Previous_Order_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('PreviousOrder'),
      ),
    );
  }
}
