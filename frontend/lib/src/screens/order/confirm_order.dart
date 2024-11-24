import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';
import '../../api/api_service.dart';

class ConfirmOrder extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const ConfirmOrder({super.key, required this.orderData});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  final ApiService apiService = ApiService();
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
    //status=orderData["orderStatus"];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "CONFIRM ORDER",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Image
            if (orderData["packageImage"] != null && orderData["packageImage"] is Uint8List)
              Center(
                child: Container(
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
              )
            else
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),

            // Order Details Card
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.person, "Order Number:", orderData["id"] ?? "Unknown"),
                    _buildDetailRow(Icons.location_on, "Destination Country:", orderData["destination"] ?? "No destination"),
                    _buildDetailRow(Icons.attach_money, "Price:", orderData["price"] ?? "No price"),
                    _buildDetailRow(Icons.scale, "Weight:", orderData["weight"] ?? "No weight specified"),
                    _buildDetailRow(Icons.date_range, "Delivery Date:", orderData["departureDate"] ?? "No date"),
                    _buildDetailRow(Icons.note, "Notes:", orderData["notes"] ?? "No notes"),
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
                      print("Order Confirmed!");
                      await apiService.updateOrderStatus(orderNo: orderNo, orderStatus: "confirmed", api: "/order/order-status");
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.topSlide,
                        title: 'Success',
                        desc: 'Order Confirmed',
                        btnOkIcon: Icons.check,
                        btnOkOnPress: () {
                          Get.to(() => const BottomBar());
                        },
                      ).show();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm Order",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between buttons

                  // Reject Order Button
                  ElevatedButton(
                    onPressed: () async {
                      print("Order Rejected!");
                     // await apiService.updateOrderStatus(orderNo: orderNo, orderStatus: "cancelled", api: "/order/order-status");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Reject Order",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
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


