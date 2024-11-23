import 'package:jim/src/screens/home/bottom_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:typed_data';
import '../../api/api_service.dart';

import 'package:flutter/material.dart';

class NewOrder extends StatefulWidget {
  final Map<String, dynamic> carrier; // Accepts carrier details as a parameter

  const NewOrder({Key? key, required this.carrier}) : super(key: key);

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();// Controller for the weight input
  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    final carrier = widget.carrier; // Access the passed carrier details

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "ORDER DETAILS",
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: CircleAvatar(
                backgroundImage: carrier["profile_pic"] != null && carrier["profile_pic"] is Uint8List
                    ? MemoryImage(carrier["profile_pic"] as Uint8List)
                    : null,
                radius: 60,
                child: carrier["profile_pic"] == null ? const Icon(Icons.person, size: 50) : null,
              ),
            ),
            const SizedBox(height: 20),

            // Details Card
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildDetailRow(Icons.person, "Name:", carrier["name"] ?? "Unknown"),
                    _buildDetailRow(Icons.location_on, "Destination:", carrier["destination"] ?? "No destination"),
                    _buildDetailRow(Icons.attach_money, "Price:", carrier["price"] ?? "No price"),
                    _buildDetailRow(Icons.scale, "Available Weight:", carrier["available_weight"] ?? "No weight available"),
                    _buildDetailRow(Icons.date_range, "Flight Date:", carrier["flight_date"] ?? "No date"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Weight Input Field
            const Text(
              "Order Weight (kg)",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20), // Increased text size for input
              decoration: InputDecoration(
                hintText: "Enter weight you want to order",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.scale, size: 28),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Contents Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentsController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final orderWeight = _weightController.text;

                    print("Pay Now for $orderWeight kg");
                    // Handle Pay Now logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // Pay Now button color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final orderWeight = _weightController.text.trim();
                    double weight = double.tryParse(orderWeight) ?? 0.0;
                    print("weight $weight");
                    print("Pay Later for $orderWeight kg");
                    print(carrier["price"]);
                    print(carrier["id"]);
                    print(carrier["currency"]);
                    final regex = RegExp(r'^([^\d]+)?([\d,\.]+)');
                    final match = regex.firstMatch(carrier["price"]);
                    double carrierPrice = 0.0;
                    String currencySymbol = "";


                    if (match != null) {
                      // Capture the currency symbol and numeric value
                      currencySymbol = match.group(1)?.trim() ?? ""; // E.g., $
                      String numericPart = match.group(2)?.replaceAll(
                          ",", "") ?? ""; // Remove commas from numbers
                      // Try parsing the numeric part to double
                      carrierPrice = double.tryParse(numericPart) ?? 0.0;
                    }
                    // Calculate the total price
                    double price = weight * carrierPrice;
                    print("Total price: $price");
                    // Handle Pay Later logic here
                    await apiService.order(
                      listid: carrier["id"],
                      weight: weight,
                      price: price,
                      currency: carrier["currency"],
                      notes: "hi",
                      api:
                      '/order', // Provide your API base URL
                    );
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      title: 'Success',
                      desc: 'Order Successful',
                      btnOkIcon: Icons.check,
                      btnOkOnPress: () {
                        Get.to(() => const BottomBar());
                      },
                    ).show();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // Pay Later button color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Pay Later",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),




          ],
        ),
      ),
    );
  }

  // Helper method to create each detail row with icon, label, and value
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[700], size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label ",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


