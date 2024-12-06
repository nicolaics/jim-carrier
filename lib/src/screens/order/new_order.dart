// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jim/src/api/order.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

import '../review/review_page.dart';

class NewOrder extends StatefulWidget {
  final Map<String, dynamic> carrier; // Accepts carrier details as a parameter

  const NewOrder({super.key, required this.carrier});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _contentsController =
      TextEditingController(); // Controller for the weight input

  Uint8List? photo;
  Uint8List? photoPayment;

  double _calculateTotalPrice() {
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final regex = RegExp(r'^([^\d]+)?([\d,\.]+)');
    final match = regex.firstMatch(widget.carrier["price"] ?? "0");
    double carrierPrice = 0.0;

    if (match != null) {
      // Extract numeric value and parse
      String numericPart = match.group(2)?.replaceAll(",", "") ?? "0";
      carrierPrice = double.tryParse(numericPart) ?? 0.0;
    }

    return weight * carrierPrice;
  }

  // Function to pick an image from the camera
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      // Update the UI with the new photo
      setState(() {
        photo = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrier = widget.carrier; // Access the passed carrier details

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "ORDER DETAILS",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: carrier["profile_pic"] != null &&
                        carrier["profile_pic"] is Uint8List
                        ? MemoryImage(carrier["profile_pic"] as Uint8List)
                        : null,
                    radius: 60,
                    child: carrier["profile_pic"] == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (starIndex) {
                      final rating = carrier["carrierRating"] ?? 0.0;

                      return GestureDetector(
                        onTap: () {
                          // Navigate to a new page when a star is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(
                                carrier: carrier, // Pass carrier data
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          starIndex < rating.floor()
                              ? Icons.star // Full star
                              : starIndex < rating && rating - starIndex >= 0.5
                              ? Icons.star_half // Half star
                              : Icons.star_border, // Empty star
                          color: Colors.amber,
                          size: 24, // Adjust size as needed
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 20),


            // Details Card
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                        Icons.person, "Name:", carrier["name"] ?? "Unknown"),
                    _buildDetailRow(Icons.location_on, "Destination:",
                        carrier["destination"] ?? "No destination"),
                    _buildDetailRow(Icons.attach_money, "Price:",
                        carrier["price"] ?? "No price"),
                    _buildDetailRow(Icons.scale, "Available Weight:",
                        carrier["available_weight"] ?? "No weight available"),
                    _buildDetailRow(Icons.date_range, "Flight Date:",
                        carrier["flight_date"] ?? "No date"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Weight Input Field
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
              style: const TextStyle(
                  fontSize: 20), // Increased text size for input
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
              onChanged: (value) {
                // Update total price whenever weight is entered
                setState(() {});
              },
            ),
            const SizedBox(height: 12),

// Total Price Display
            const Text(
              "Total Price",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: _weightController.text.isNotEmpty
                    ? "${widget.carrier['currency'] ?? ''} ${NumberFormat('#,##0.0').format(_calculateTotalPrice())}"
                    : "Enter weight to see total price",
                hintStyle: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            const Text(
              "Contents Info",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
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

// Camera Icon Button with Upload Picture
            Row(
              children: [
                const Text(
                  "Upload Picture",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt,
                      size: 32, color: Colors.blue),
                  onPressed: _pickImage,
                ),
              ],
            ),
            const SizedBox(height: 12),

// Display the selected image inside a box
            if (photo != null)
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.memory(
                  photo!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 24),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final orderWeight = _weightController.text.trim();
                    double weight = double.tryParse(orderWeight) ?? 0.0;

                    print("weight $weight");
                    print("Pay Later for $orderWeight kg");
                    print(carrier["price"]);
                    print(carrier["id"]);
                    print(carrier["currency"]);
                    
                    // Calculate the total price
                    double price = _calculateTotalPrice();

                    // Handle Pay Later logic here
                    dynamic response = await createOrder(
                      listid: carrier["id"],
                      weight: weight,
                      price: price,
                      currency: carrier["currency"],
                      packageContent: _contentsController.text,
                      packageImage: photo,
                      api: '/order', // Provide your API base URL
                    );

                    if (response["status"] == "error") {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.topSlide,
                        title: 'Create Order Failed',
                        desc: response["message"].toString().capitalizeFirst,
                        btnOkIcon: Icons.check,
                        btnOkOnPress: () {},
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.topSlide,
                        title: 'Success',
                        desc: 'Create order successful',
                        btnOkIcon: Icons.check,
                        btnOkOnPress: () {
                          Get.to(() => const BottomBar(1));
                        },
                      ).show();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // Pay Later button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Confirm Order",
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 20,
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
