// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jim/src/api/order.dart';
import 'dart:convert'; // For base64Decode and Uint8List
import 'dart:typed_data'; // For Uint8List

class ReceivedOrder extends StatefulWidget {
  const ReceivedOrder({super.key});

  @override
  _ReceivedOrder createState() => _ReceivedOrder();
}

class _ReceivedOrder extends State<ReceivedOrder> {
  List<Map<String, dynamic>> items = [];
  String? selectedValue;
  bool isLoading = true; // Loading state

  bool _hasFetchedData = false;

  @override
  void initState() {
    super.initState();
    if (!_hasFetchedData) {
      _hasFetchedData = true;
      fetchReceivedOrder();
    }
  }


  Future<void> fetchReceivedOrder() async {
    setState(() {
      isLoading = true; // Show loading spinner
    });

    try {
      String api = "/order/carrier";
      dynamic response = await getReceivedOrders(api: api);
      print("response $response");

      if (response["status"] == "success") {
        List<Map<String, dynamic>> updatedItems = [];
        for (var order in response["message"]) {
          var listing = order['listing'];
          if (listing == null) continue;

          String? base64Image = order['packageImage'];
          Uint8List? imageBytes = base64Image != null && base64Image.isNotEmpty
              ? base64Decode(base64Image)
              : null;

          updatedItems.add({
            "destination": listing['destination'] ?? 'No destination',
            "departureDate": listing['departureDate'] != null
                ? formatDate(DateTime.parse(listing['departureDate']))
                : 'N/A',
            "id": order['id']?.toString() ?? 'Unknown',
            "giverName": order['giverName'] ?? 'Unknown',
            "giverPhoneNumber": order['giverPhoneNumber'] ?? 'Unknown',
            "weight": order['weight']?.toString() ?? 'N/A',
            "price": order['price']?.toString() ?? 'N/A',
            "currency": order['currency'] ?? 'MYR',
            "packageImage": imageBytes,
            "packageLocation": order['packageLocation'] ?? 'Unknown',
            "orderStatus": order['orderStatus'] ?? 'Unknown',
            "notes": order['notes'] ?? 'Unknown',
          });
        }

        setState(() {
          items = updatedItems;
        });
      } else {
        print("Error: ${response["message"]}");
      }
    } catch (e) {
      print('Error fetching listing: $e');
    } finally {
      setState(() {
        isLoading = false; // Hide loading spinner
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Received Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Loading spinner
      )
          : items.isEmpty
          ? const Center(
        child: Text(
          "No orders yet",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedValue,
              hint: const Text("SORT BY"),
              items: <String>['Alphabetical', 'High to Low', 'Nearest Date']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundImage: item['packageImage'] != null
                          ? MemoryImage(item['packageImage'] as Uint8List)
                          : null,
                      radius: 20,
                    ),
                    title: Text(
                      "Order ID: ${item['id']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Country: ${item['destination']}"),
                        Text("Price: ${item['currency']} ${item['price']}"),
                        Text("Weight: ${item['weight']} kg"),
                        Text("Order Status: ${item['orderStatus']}"),
                        Text("Current Location: ${item['packageLocation']}"),
                        Text("Departure Date: ${item['departureDate']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

