// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jim/src/api/listing.dart';
import 'package:jim/src/api/order.dart';
import 'dart:convert'; // For base64Decode and Uint8List
import 'dart:typed_data'; // For Uint8List
import '../../api/api_service.dart';

class ReceivedOrder extends StatefulWidget {
  const ReceivedOrder({super.key});

  @override
  _ReceivedOrder createState() => _ReceivedOrder();
}

class _ReceivedOrder extends State<ReceivedOrder> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> items = []; // List to store the updated items
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    fetchListing();
  }

  // Fetch data for the listing
  Future<void> fetchListing() async {
    try {
      String api = "/order/carrier";
      List<dynamic> response = await getAllListings(api: api) as List;
      print("Response: $response");

      List<Map<String, dynamic>> updatedItems = [];
      for (var data in response) {
        var listing = data['listing'];
        if (listing == null) continue;

        String? base64Image = data['packageImage'];
        Uint8List? imageBytes = base64Image != null && base64Image.isNotEmpty
            ? base64Decode(base64Image)
            : null;

        updatedItems.add({
          "destination": listing['destination'] ?? 'No destination',
          "departureDate": listing['departureDate'] != null
              ? formatDate(DateTime.parse(listing['departureDate']))
              : 'N/A',
          "id": data['id']?.toString() ?? 'Unknown',
          "giverName": data['giverName'] ?? 'Unknown',
          "giverPhoneNumber": data['giverPhoneNumber'] ?? 'Unknown',
          "weight": data['weight']?.toString() ?? 'N/A',
          "price": data['price']?.toString() ?? 'N/A',
          "currency": data['currency'] ?? 'MYR',
          "packageImage": imageBytes,
          "packageLocation": data['packageLocation'] ?? 'Unknown', // Ensure this is set properly
          "orderStatus": data['orderStatus'] ?? 'Unknown',
          "notes": data['notes'] ?? 'Unknown',
        });

      }

      setState(() {
        items = updatedItems;
      });
    } catch (e) {
      print('Error fetching listing: $e');
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void _showUpdateLocationModal(BuildContext context, Map<String, dynamic> item) {
    String? dropdownValue;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Update Location",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: dropdownValue,
                hint: const Text("Select Status"),
                items: const [
                  DropdownMenuItem(
                    value: "Received by Carrier",
                    child: Text("Received by Carrier"),
                  ),
                  DropdownMenuItem(
                    value: "In-flight",
                    child: Text("In-flight"),
                  ),
                  DropdownMenuItem(
                    value: "Arrived at the Destination Country",
                    child: Text("Arrived at the Destination Country"),
                  ),
                  DropdownMenuItem(
                    value: "With Local Courier",
                    child: Text("With Local Courier"),
                  ),
                  DropdownMenuItem(
                    value: "Delivered",
                    child: Text("Delivered"),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (dropdownValue != null && dropdownValue!.isNotEmpty) {
                    String orderStatus = "confirmed";
                    if (dropdownValue == "In-flight" || dropdownValue == "Arrived at the Destination Country" || dropdownValue == "With Local Courier") {
                      orderStatus = "en-route";
                    } else if (dropdownValue == "Delivered") {
                      orderStatus = "completed";
                    }

                    // Update location on the server
                    dynamic result = await updatePackageLocation(
                      orderNo: int.tryParse(item['id']) ?? 0,
                      location: dropdownValue,
                      orderStatus: orderStatus,
                      api: "/order/package-location",
                    );

                    if (result != null) {
                      // Find the index of the updated item
                      int index = items.indexWhere((element) => element['id'] == item['id']);
                      if (index != -1) {
                        // Update the item in the list
                        setState(() {
                          items[index]['packageLocation'] = dropdownValue; // Update the location
                          items[index]['orderStatus'] = orderStatus; // Update the order status
                        });
                      }
                    } else {
                      print("Error updating the location");
                    }

                    Navigator.pop(context); // Close the modal
                  } else {
                    print("No status selected");
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'YOUR ORDERS',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
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
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _showUpdateLocationModal(context, item),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            "Update Location",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
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
