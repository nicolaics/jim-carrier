import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  final Map<String, dynamic> carrier;

  const ReviewPage({super.key, required this.carrier});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    final carrier = widget.carrier; // Access the carrier data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrier Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display carrier details
            Text(
              "Name: ${carrier["name"] ?? "Unknown"}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Id: ${carrier["carrierId"] ?? "Unknown"}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Rating: ${carrier["carrierRating"] ?? "No rating"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
