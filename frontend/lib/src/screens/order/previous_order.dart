import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviousOrderScreen extends StatefulWidget {
  const PreviousOrderScreen({super.key});

  @override
  State<PreviousOrderScreen> createState() => _PreviousOrderScreenState();
}

class _PreviousOrderScreenState extends State<PreviousOrderScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy data for listing
  List<Map<String, dynamic>> listingData = [
    {
      "name": "Carrier 1",
      "destination": "Seoul",
      "price": "₩5000 per kg",
      "available_weight": "10 kg",
      "flight_date": "Nov 15, 2024",
      "profile_pic": "frontend/assets/images/welcomePage/welcome_screen.png"
    },
    {
      "name": "Carrier 2",
      "destination": "Busan",
      "price": "₩4000 per kg",
      "available_weight": "15 kg",
      "flight_date": "Nov 20, 2024",
      "profile_pic": "frontend/assets/images/welcomePage/welcome_screen.png"
    },
  ];

  // Dummy data for orders
  List<Map<String, dynamic>> orderData = [
    {
      "name": "Carrier 1",
      "destination": "Seoul",
      "price": "₩5000 per kg",
      "available_weight": "10 kg",
      "flight_date": "Nov 15, 2024",
      "order_weight": "5 kg",
    },
    {
      "name": "Carrier 2",
      "destination": "Busan",
      "price": "₩4000 per kg",
      "available_weight": "15 kg",
      "flight_date": "Nov 20, 2024",
      "order_weight": "7 kg",
    },
  ];

  bool isListingView = true; // Boolean to toggle between listing and order view

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab-like buttons
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Listing button
                _buildTabButton("LISTING", 0),
                const SizedBox(width: 8),
                // Order button
                _buildTabButton("ORDER", 1),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Display either Listing or Order data based on the button clicked
          Expanded(
            child: isListingView ? _buildListingView() : _buildOrderView(),
          ),
        ],
      ),
    );
  }

  // Helper method to build the Tab-like button
  Widget _buildTabButton(String label, int index) {
    bool isSelected = (index == 0 && isListingView) || (index == 1 && !isListingView);

    return GestureDetector(
      onTap: () {
        setState(() {
          isListingView = index == 0;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Method to build the Listing view
  Widget _buildListingView() {
    return ListView.builder(
      itemCount: listingData.length,
      itemBuilder: (context, index) {
        final item = listingData[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundImage: AssetImage(item["profile_pic"]),
              radius: 20,
            ),
            title: Text(
              item["name"] ?? "Name",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["destination"] ?? "Destination"),
                Text(item["price"] ?? "Price"),
                Text(item["available_weight"] ?? "Available Weight"),
                Text(item["flight_date"] ?? "Flight Date"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Handle edit action
                    print("Edit pressed for ${item["name"]}");
                  },
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Handle delete action
                    setState(() {
                      listingData.removeAt(index);
                    });
                    print("Deleted ${item["name"]}");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to build the Order view
  Widget _buildOrderView() {
    return ListView.builder(
      itemCount: orderData.length,
      itemBuilder: (context, index) {
        final item = orderData[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              item["name"] ?? "Name",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["destination"] ?? "Destination"),
                Text(item["price"] ?? "Price"),
                Text(item["available_weight"] ?? "Available Weight"),
                Text(item["flight_date"] ?? "Flight Date"),
                Text("Order Weight: ${item["order_weight"]} kg"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Order Status Button
                IconButton(
                  icon: const Icon(Icons.info, color: Colors.blue),
                  onPressed: () {
                    // Handle order status action
                    print("Order Status pressed for ${item["name"]}");
                  },
                ),
                // Reviews Button
                IconButton(
                  icon: const Icon(Icons.rate_review, color: Colors.green),
                  onPressed: () {
                    // Handle reviews action
                    print("Reviews pressed for ${item["name"]}");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


