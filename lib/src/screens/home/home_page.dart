import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:jim/src/api/listing.dart';
import 'dart:typed_data';
import '../../api/api_service.dart';
import 'package:jim/src/screens/order/new_order.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> items =
      []; // Change the list type to dynamic to handle both String and Uint8List

  String? selectedValue; // For the dropdown button

  @override
  void initState() {
    super.initState();
    fetchListing(); // Call the function when the widget is initialized
  }

  // Async function to fetch data and update items list

  Future<void> fetchListing() async {
    try {
      String api = "/listing/all";
      List<dynamic> response =
          await getAllListings(api: api) as List; // Await the response
      print("Response: $response");

      List<Map<String, dynamic>> updatedItems =
          []; // To store the updated items

      // Map the API response to the desired format
      for (var data in response) {
        String? base64Image = data['carrierProfilePicture'];
        Uint8List? imageBytes;

        if (base64Image != null && base64Image.isNotEmpty) {
          imageBytes = base64Decode(
              base64Image); // Decode the base64 string to Uint8List
        }
        print("carrier rating ${data["carrierRating"]}");

        updatedItems.add({
          "id": data['id'] ?? 'Unknown',
          "currency": data['currency'] ?? 'Unknown',
          "name": data['carrierName'] ??
              'Unknown', // Default to 'Unknown' if not available
          "destination": data['destination'] ??
              'No destination', // Default to 'No destination'
          "price": formatPrice(
              data['pricePerKg'],
              data['currency'] ??
                  'KRW'), // Format the price based on the currency
          "available_weight": formatWeight(data[
              'weightAvailable']), // Format the available weight with space
          "flight_date":
              formatDate(data['departureDate']), // Format the departure date
          "profile_pic": imageBytes, // Store the decoded image bytes
          "carrierRating": data['carrierRating']??0,
        });
      }

      // Update the state with the new items
      setState(() {
        items = updatedItems;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // Format the price based on the currency
  String formatPrice(dynamic price, String currency) {
    // Ensure that price is treated as a double
    double priceValue = price is double ? price : price.toDouble();

    final numberFormat = _getCurrencyFormat(currency);
    // Append " per kg" to the formatted price
    return "${numberFormat.format(priceValue)} per kg";
  }

  // Format the weight with a space between the number and kg
  String formatWeight(dynamic weight) {
    return "$weight kg available"; // Add space between number and kg
  }

  // Format the date as "Oct 19, 2024"
  String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Unknown date"; // Return "Unknown date" if no date is available
    }

    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('MMM dd, yyyy').format(parsedDate); // Format the date
    } catch (e) {
      return "Invalid date"; // Return "Invalid date" if the format is not correct
    }
  }

  // Get the appropriate currency format based on the currency code
  NumberFormat _getCurrencyFormat(String currency) {
    switch (currency) {
      case 'USD':
        return NumberFormat.simpleCurrency(name: 'USD');
      case 'KRW':
        return NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
      case 'EUR':
        return NumberFormat.currency(locale: 'de_DE', symbol: '€');
      case 'JPY':
        return NumberFormat.currency(locale: 'ja_JP', symbol: '¥');
      default:
        return NumberFormat.currency(locale: 'en_US', symbol: '\$');
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: DropdownButton<String>(
                    value: selectedValue,
                    hint: const Text("SORT BY"),
                    items: <String>[
                      'Alphabetical',
                      'High to Low',
                      'Nearest Date'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        // Display the base64 image in CircleAvatar
                        CircleAvatar(
                          backgroundImage: items[index]["profile_pic"] !=
                                  null //need to change this to !=null
                              ? MemoryImage(items[index]["profile_pic"]
                                  as Uint8List) // Use MemoryImage to display the base64 image
                              : null, // Fallback if no image data exists
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
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[index]["price"] ?? "Price",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          items[index]["available_weight"] ??
                              "Available Weight",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          items[index]["flight_date"] ?? "Flight Date",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min, // Ensures the column uses only the space it needs
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewOrder(carrier: items[index]),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("View"),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (starIndex) {
                              final rating = items[index]["carrierRating"] ?? 0.0;
                              if (starIndex < rating.floor()) {
                                // Full star
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              } else if (starIndex < rating && rating - starIndex >= 0.5) {
                                // Half star
                                return const Icon(
                                  Icons.star_half,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              } else {
                                // Empty star
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
                      print("Carrier Rating: ${items[index]["carrierRating"]}");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewOrder(carrier: items[index]),
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
    );
  }
}