import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../api/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> items = [];  //
  void initState() {
    super.initState();
    fetchListing();
  }
  Future<void> fetchListing() async {
    try {
      String api = "/order/carrier";
      List<dynamic> response = await apiService.getListing(api: api) as List;  // Await the response
      print("Response: $response");
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("haha"),
    );
  }
}

