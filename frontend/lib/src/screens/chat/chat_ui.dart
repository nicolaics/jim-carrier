import 'package:flutter/material.dart';
import 'dart:convert'; // For base64Decode and Uint8List
import 'dart:typed_data'; // For Uint8List
import '../../api/api_service.dart';
import '../order/confirm_order.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
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
      List<dynamic> response = await apiService.getListing(api: api) as List;
      print("Response: $response");

      List<Map<String, dynamic>> updatedItems = [];
      for (var data in response) {
        // Validate that 'listing' exists
        var listing = data['listing'];
        if (listing == null) {
          continue; // Skip if 'listing' is null
        }
        String? base64Image = data['packageImage']; // Nullable String
        Uint8List? imageBytes;

        if (base64Image != null && base64Image.isNotEmpty) {
          imageBytes = base64Decode(base64Image);
        } else {
          imageBytes = null; // Explicitly set it to null if there's no valid image
        }
        // Ensure all fields are correctly parsed
        Map<String, dynamic> mappedItem = {
          "destination": listing['destination'] ?? 'No destination',
          "departureDate": listing['departureDate'] != null
              ? formatDate(DateTime.parse(listing['departureDate']))
              : 'N/A',
          // Ensure ID is always a String
          "id": data['id'] != null ? data['id'].toString() : 'Unknown',
          "giverName": data['giverName'] ?? 'Unknown',
          "giverPhoneNumber": data['giverPhoneNumber'] ?? 'Unknown',
          "weight": data['weight']?.toString() ?? 'N/A', // Convert weight to String
          "price": data['price']?.toString() ?? 'N/A', // Convert price to String
          "currency": data['currency'] ?? 'MYR',
          "packageImage": imageBytes,
          "orderStatus": data['orderStatus'] ?? 'Unknown',
          "notes": data['notes'] ?? 'Unknown',
        };

        updatedItems.add(mappedItem);
      }
      setState(() {
        items = updatedItems;
      });
    } catch (e) {
      print('Error fetching listing: $e');
    }
  }

  // Formatting helpers
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
                      "Order Number: ${item['id']}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Country: ${item['destination']}"),
                        Text("Price: ${item['currency']} ${item['price']}"),
                        Text("Weight: ${item['weight']} kg"),
                        Text("Departure Date: ${item['departureDate']}"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("View"),
                    ),
                      onTap: () {
                        print("Tapped on ${items[index]["name"]}");
                        print("Tapped on ${items[index]["id"]}");
                        print("Tapped on ${items[index]["currency"]}");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ConfirmOrder(
                                    orderData: items[index]), // Pass the entire data for this order
                          ),
                        );
                      }
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
