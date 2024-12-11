import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jim/src/api/listing.dart';
import 'package:jim/src/constants/colors.dart';
import 'package:jim/src/screens/order/new_order.dart';
import 'package:jim/src/utils/formatter.dart';

import '../../utils/send_email.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> items = [];
  String? selectedValue;
  bool isLoading = true; // Initially, the loading state is true

  @override
  void initState() {
    super.initState();
    fetchListing(); // Call fetchListing() when the widget is first created
  }

  Future<void> fetchListing() async {
    try {
      setState(() {
        isLoading = true; // Start loading before making the API call
      });

      String api = "/listing/all";
      dynamic response = await getAllListings(api: api); // Fetch data
      print("Response: $response");

      if (response["status"] == "success") {
        response["message"] = response["message"] as List;

        List<Map<String, dynamic>> updatedItems = [];
        for (var data in response["message"]) {
          String? base64Image = data['carrierProfilePicture'];
          Uint8List imageBytes;

          if (base64Image != null && base64Image.isNotEmpty) {
            imageBytes = base64Decode(base64Image);
          } else {
            ByteData byteData = await rootBundle
                .load('assets/images/welcomePage/welcome_screen.png');
            imageBytes = byteData.buffer.asUint8List();
          }

          updatedItems.add({
            "carrierId": data['carrierId'] ?? 'Unknown',
            "carrierEmail": data['carrierEmail']?? 'Unknown',
            "id": data['id'] ?? 'Unknown',
            "currency": data['currency'] ?? 'Unknown',
            "name": data['carrierName'] ?? 'Unknown',
            "destination": data['destination'] ?? 'No destination',
            "price":
                "${Formatter.formatPrice(data['pricePerKg'], data['currency'])} per kg",
            "available_weight":
                "${Formatter.formatWeight(data['weightAvailable'])} kg available",
            "flight_date": Formatter.formatDate(data['departureDate']),
            "profile_pic": imageBytes,
            "carrierRating": data['carrierRating'] ?? 0,
          });
        }

        setState(() {
          items = updatedItems;
          isLoading = false; // Stop loading after data is fetched
        });
      } else {
        print("FETCH LISTING ERROR: ${response["message"]}");
        setState(() {
          isLoading = false; // Stop loading even if the fetch failed
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading if an error occurred
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Available Carriers',
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
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${index + 1}', // List number
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              CircleAvatar(
                                backgroundImage:
                                    items[index]["profile_pic"] != null
                                        ? MemoryImage(items[index]
                                            ["profile_pic"] as Uint8List)
                                        : null,
                                radius: 20,
                              ),
                            ],
                          ),
                          title: Text(
                            items[index]["name"] ?? "Name",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index]["destination"] ?? "Destination",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                items[index]["price"] ?? "Price",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                items[index]["available_weight"] ??
                                    "Available Weight",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                items[index]["flight_date"] ?? "Flight Date",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewOrder(
                                        carrier: items[index],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsTheme.skyBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("View", style: TextStyle(color: Colors.black)),
                              ),
                              const SizedBox(height: 8),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (starIndex) {
                                    final rating =
                                        items[index]["carrierRating"] ?? 0.0;
                                    if (starIndex < rating.floor()) {
                                      return const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    } else if (starIndex < rating &&
                                        rating - starIndex >= 0.5) {
                                      return const Icon(
                                        Icons.star_half,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    }
                                  }),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            print("Tapped on ${items[index]["name"]}");
                            print("Tapped on ${items[index]["id"]}");
                            print("Tapped on ${items[index]["currency"]}");
                            print(
                                "Carrier Rating: ${items[index]["carrierRating"]}");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewOrder(carrier: items[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example: Open a generic email action or specify a behavior
          if (items.isNotEmpty) {
            // Launch email for the first carrier (as an example)
            launchEmail(items[0]['carrierEmail']);
          } else {
            // Show a message if there are no items
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No carriers available to email."),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.email, color: Colors.white),
      ),

    );
  }

}
