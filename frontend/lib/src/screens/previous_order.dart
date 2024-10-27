import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Previous_Order_Screen extends StatefulWidget {
  const Previous_Order_Screen({super.key});
  @override
  State<Previous_Order_Screen> createState() => _Previous_Order_ScreenState();
}

class _Previous_Order_ScreenState extends State<Previous_Order_Screen> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    final query = _searchController.text;
    print("Searching for: $query");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: "Search",
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: _performSearch,
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('PreviousOrder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
