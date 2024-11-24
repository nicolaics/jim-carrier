
import 'package:flutter/material.dart';
import 'dart:typed_data' as typed_data;
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../api/api_service.dart';

class PreviousOrderScreen extends StatefulWidget {
  const PreviousOrderScreen({super.key});

  @override
  State<PreviousOrderScreen> createState() => _PreviousOrderScreenState();
}



class _PreviousOrderScreenState extends State<PreviousOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> listingData = [];
  List<Map<String, dynamic>> orderData = [];

  String? selectedValue; // For the dropdown button
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    fetchListing();
    fetchOrder(); // Fetch both listing and order data
  }

  void _showReviewModal(String carrierName, int orderId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to be resized with the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Adjust for keyboard
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  "Leave a Review for $carrierName $orderId",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text("Rate out of 5",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                RatingBar.builder(
                  initialRating: _selectedRating.toDouble(), // Sets initial rating
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true, // Allow half-star ratings if desired
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _selectedRating = rating.toInt(); // Update selected rating
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _reviewController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Write your review",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    int rating = _selectedRating.toInt();
                    print("Review Submitted: ${_reviewController.text}, Rating: $_selectedRating");
                    _reviewController.clear();
                    setState(() {
                      _selectedRating = 0; // Reset rating after submission
                    });
                    await apiService.review(
                      orderId: orderId,
                      reviewName: carrierName,
                      reviewContent: _reviewController.text,
                      rating: rating,
                      api:
                      '/review', // Provide your API base URL
                    );

                    Navigator.pop(context); // Close the modal
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Async function to fetch both listing and order data
  Future<void> fetchListing() async {
    try {
      String api = "/listing/carrier"; // Correct endpoint
      var response = await apiService.getOrder(api: api); // Fetch API data

      if (response is List) {
        List<Map<String, dynamic>> updatedItems = [];

        for (var data in response) {
          updatedItems.add({
            "id": data['id'] ?? 'Unknown',
            "carrier_name": data['carrierName'] ?? 'Unknown',
            "destination": data['destination'] ?? 'No destination',
            "price": formatPrice(data['pricePerKg'], 'KRW'),
            "available_weight": formatWeight(data['weightAvailable']),
            "flight_date": formatDate(data['departureDate']),
            "description": data['description'] ?? 'No description',
            "carrier_rating": data['carrierRating'] ?? 0,
            "profile_pic": data['carrierProfileImage'],
          });
        }

        setState(() {
          listingData = updatedItems;
        });
      } else if (response is Map && response['status'] == 'failed') {
        print("Error: API returned a failure status. Response: $response");
      } else {
        print("Error: Unexpected response format. Response: $response");
      }
    } catch (e) {
      print('Error fetching listing data: $e');
    }
  }

  Future<void> fetchOrder() async {
    try {
      String api = "/order/giver"; // Correct endpoint
      var response = await apiService.getOrder(api: api); // Fetch API data

      if (response is List) {
        List<Map<String, dynamic>> updatedOrders = [];

        for (var data in response) {
          updatedOrders.add({
            "id": data['id'] ?? 'Unknown',
            "weight": formatWeight(data['weight']),
            "price": formatPrice(data['price'], 'KRW'),
            "payment_status": data['paymentStatus'] ?? 'Unknown',
            "order_status": data['orderStatus'] ?? 'Unknown',
            "package_location": data['packageLocation'] ?? 'Unknown',
            "notes": data['notes'] ?? 'No notes',
            "created_at": formatDate(data['createdAt']),
            "listing": {
              "carrier_name": data['listing']?['carrierName'] ?? 'Unknown',
              "destination": data['listing']?['destination'] ?? 'No destination',
              "flight_date": formatDate(data['listing']?['departureDate']),
            },
          });
        }

        setState(() {
          orderData = updatedOrders;
        });
      } else if (response is Map && response['status'] == 'failed') {
        print("Error: API returned a failure status. Response: $response");
      } else {
        print("Error: Unexpected response format. Response: $response");
      }
    } catch (e) {
      print('Error fetching order data: $e');
    }
  }


// Safeguards for format conversion methods
  String formatPrice(dynamic price, String currency) {
    try {
      double priceAsDouble = double.tryParse(price.toString()) ?? 0.0;
      return NumberFormat.simpleCurrency(name: currency).format(priceAsDouble);
    } catch (e) {
      print('Error formatting price: $e');
      return 'N/A';
    }
  }

  String formatWeight(dynamic weight) {
    try {
      double weightAsDouble = double.tryParse(weight.toString()) ?? 0.0;
      return "${weightAsDouble.toStringAsFixed(2)} kg";
    } catch (e) {
      print('Error formatting weight: $e');
      return 'N/A';
    }
  }

  String formatDate(dynamic date) {
    try {
      DateTime parsedDate;
      if (date is DateTime) {
        parsedDate = date;
      } else if (date is String) {
        parsedDate = DateTime.parse(date);
      } else {
        throw FormatException("Invalid date format");
      }
      return DateFormat('MMM dd, yyyy').format(parsedDate);
    } catch (e) {
      print('Error formatting date: $e');
      return 'Invalid Date';
    }
  }


  bool isListingView = true; // Boolean to toggle between listing and order view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Listings',
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
          // Tab-like buttons
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("LISTING", 0),
                const SizedBox(width: 8),
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

  // Method to build the Listing view with dynamic data
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundImage: item["profile_pic"] != null && item["profile_pic"].isNotEmpty
                      ? MemoryImage(item["profile_pic"] as typed_data.Uint8List)
                      : null,
                  radius: 20,
                ),
                title: Text(
                  item["carrier_name"] ?? "Carrier Name",
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add logic for editing the listing
                        print("Edit button pressed for ${item['carrier_name']}");
                      },
                      child: const Text("Edit"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic for deleting the listing
                        print("Delete button pressed for ${item['carrier_name']}");
                      },
                      child: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300], // Red delete button
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  // Method to build the Order view with dynamic data
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${item["id"]}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('Payment Status: ${item["payment_status"] ?? "Unknown"}'),
                Text('Order Status: ${item["order_status"] ?? "Unknown"}'),
                Text('Package Location: ${item["package_location"] ?? "Unknown"}'),
                Text('Notes: ${item["notes"] ?? "No notes"}'),
                Text('Created At: ${item["created_at"] ?? "Unknown"}'),
                const SizedBox(height: 8),
                Text('Carrier: ${item["listing"]["carrier_name"]}'),
                Text('Destination: ${item["listing"]["destination"]}'),
                Text('Flight Date: ${item["listing"]["flight_date"]}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("View Status pressed for Order #${item["id"]}");
                      },
                      child: const Text("View Status"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Pass a valid key to the modal
                        _showReviewModal(
                          item["listing"]["carrier_name"] ?? "Unknown Carrier",
                          item["id"],
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      child: const Text("Leave Review"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
