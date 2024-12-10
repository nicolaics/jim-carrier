// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/src/api/order.dart';
import 'package:jim/src/constants/colors.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmOrder extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const ConfirmOrder({super.key, required this.orderData});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  @override
  void initState() {
    super.initState();
    // Log the passed orderData
    debugPrint("Order Data Passed: ${widget.orderData}");
  }

  int? orderNo;

  @override
  Widget build(BuildContext context) {
    final orderData = widget.orderData;

    orderNo = (orderData["id"] is String)
        ? int.tryParse(orderData["id"])
        : orderData["id"] as int?;

    print("Order IDDDDDD:");
    print(orderNo);
    //status=orderData["orderStatus"];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Confirm Order",
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
            // Package Image
// Package Image with Text Outside (Above)
            if (orderData["packageImage"] != null && orderData["packageImage"] is Uint8List)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Align tightly around its content
                  children: [
                    // Text above the image
                    const SizedBox(height: 8), // Add spacing between text and image
                    // Image
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          orderData["packageImage"] as Uint8List,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const Text(
                      "Package Image",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text above the placeholder
                    const Text(
                      "Package Image",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8), // Add spacing between text and placeholder
                    // Placeholder for when there's no image
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ],
                ),
              ),



            const SizedBox(height: 20),

            // Order Details Card
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
                    _buildDetailRow(Icons.person, "Order Number:",
                        orderData["id"] ?? "Unknown"),
                    _buildDetailRow(Icons.location_on, "Destination Country:",
                        orderData["destination"] ?? "No destination"),
                    _buildDetailRow(Icons.attach_money, "Price:",
                        orderData["price"] ?? "No price"),
                    _buildDetailRow(Icons.scale, "Weight:",
                        orderData["weight"] ?? "No weight specified"),
                    _buildDetailRow(Icons.date_range, "Delivery Date:",
                        orderData["departureDate"] ?? "No date"),
                    _buildDetailRow(
                        Icons.note, "Notes:", orderData["notes"] ?? "No notes"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Confirm Order Button
                  ElevatedButton(
                    onPressed: () async {
                      print("Order IDDDDDD:");
                      print(orderNo);
                      print("Order Confirmed!");
                      dynamic response = await updateOrderStatus(
                          orderNo: orderNo,
                          orderStatus: "confirmed",
                          api: "/order/order-status");

                      if (response["status"] == "success") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          title: 'Success',
                          desc: 'Order confirmed',
                          btnOkIcon: Icons.check,
                          btnOkOnPress: () {
                            Get.to(() => const BottomBar(0));
                          },
                        ).show();
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          title: 'Error',
                          desc: response["message"].toString().capitalizeFirst,
                          btnOkIcon: Icons.check,
                          btnOkOnPress: () {
                          },
                        ).show();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsTheme.skyBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm Order",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between buttons

                  // Reject Order Button
                  ElevatedButton(
                    onPressed: () async {
                      print("Order Rejected!");
                      dynamic response = await updateOrderStatus(
                          orderNo: orderNo,
                          orderStatus: "cancelled",
                          api: "/order/order-status");

                      if (response["status"] == "success") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          title: 'Success',
                          desc: 'Order confirmed',
                          btnOkIcon: Icons.check,
                          btnOkOnPress: () {
                            Get.to(() => const BottomBar(0));
                          },
                        ).show();
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          title: 'Error',
                          desc: response["message"].toString().capitalizeFirst,
                          btnOkIcon: Icons.check,
                          btnOkOnPress: () {
                          },
                        ).show();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Reject Order",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _launchEmail(orderData['giverEmail']),
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.email, color: Colors.white),
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
  Future<void> _launchEmail(String toEmail) async {
    print("EMAILLLL $toEmail");
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: toEmail,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );
    launchUrl(emailLaunchUri);
  }
}
