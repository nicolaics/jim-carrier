// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'dart:typed_data' as typed_data;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jim/src/api/listing.dart';
import 'package:jim/src/api/order.dart'
import 'package:jim/src/api/review.dart';
import 'package:jim/src/auth/encryption.dart';
import '../listing/edit_listing.dart';

class PreviousOrderScreen extends StatefulWidget {
  const PreviousOrderScreen({super.key});

  @override
  State<PreviousOrderScreen> createState() => _PreviousOrderScreenState();
}

class _PreviousOrderScreenState extends State<PreviousOrderScreen> {
  final TextEditingController _reviewController = TextEditingController();

  List<Map<String, dynamic>> listingData = [];
  List<Map<String, dynamic>> orderData = [];

  String? selectedValue; // For the dropdown button
  int _selectedRating = 0;
  Uint8List? photoPayment;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchListing();
    fetchOrder(); // Fetch both listing and order data
  }

  Future<void> _pickImagePayment() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery); // Use gallery
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      setState(() {
        photoPayment = bytes; // Update the payment proof image
      });
    }
  }

  void _showReviewModal(String carrierName, int orderId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow the bottom sheet to be resized with the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                16.0, // Adjust for keyboard
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  "Leave a Review for $carrierName $orderId",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Rate out of 5",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating:
                      _selectedRating.toDouble(), // Sets initial rating
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true, // Allow half-star ratings if desired
                  itemCount: 5,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _selectedRating =
                          rating.toInt(); // Update selected rating
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
                    print(
                        "Review Submitted: ${_reviewController.text}, Rating: $_selectedRating");
                    _reviewController.clear();
                    setState(() {
                      _selectedRating = 0; // Reset rating after submission
                    });
                    dynamic response = await createReview(
                      orderId: orderId,
                      reviewName: carrierName,
                      reviewContent: _reviewController.text,
                      rating: rating,
                      api: '/review', // Provide your API base URL
                    );

                    if (response["status"] == "success") {
                      Navigator.pop(context); // Close the modal
                    } else {
                      // TODO: do here
                    }
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
      setState(() {
        isLoading = true;
      });
      String api = "/listing/carrier"; // Correct endpoint
      dynamic response = await getAllOrders(api: api); // Fetch API data

      if (response["status"] == "success") {
        response["message"] = response["message"] as List;

        List<Map<String, dynamic>> updatedItems = [];

        for (var data in response["message"]) {
          updatedItems.add({
            "id": data['id'] ?? 'Unknown',
            "carrierID": data['çarrierId'] ?? 'Únknown',
            "carrier_name": data['carrierName'] ?? 'Unknown',
            "destination": data['destination'] ?? 'No destination',
            "price": formatPrice(data['pricePerKg'], 'KRW'),
            "available_weight": formatWeight(data['weightAvailable']),
            "flight_date": formatDate(data['departureDate']),
            "lastReceiveDate": formatDate(data['lastReceivedDate']),
            "description": data['description'] ?? 'No description',
            "carrier_rating": data['carrierRating'] ?? 0,
            "profile_pic": data['carrierProfileImage'],
            "accountHolderName": data['bankDetail']['accountHolder'],
            "accountNumber": data['bankDetail']['accountNumber'],
            "bankName": data['bankDetail']['bankName'],
          });
        }

        setState(() {
          listingData = updatedItems;
          isLoading = false;
        });
      } else {
        print("Error: API returned a failure status. Response: $response");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching listing data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchOrder() async {
    try {
      setState(() {
        isLoading = true;
      });
      String api = "/order/giver"; // Correct endpoint
      dynamic response = await getAllOrders(api: api); // Fetch API data

      if (response["status"] == "success") {
        response["message"] = response["message"] as List;

        List<Map<String, dynamic>> updatedOrders = [];

        for (var data in response["message"]) {
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
              "destination":
                  data['listing']?['destination'] ?? 'No destination',
              "flight_date": formatDate(data['listing']?['departureDate']),
            },
          });
        }

        setState(() {
          orderData = updatedOrders;
          isLoading = false;
        });
      } else {
        print("Error: API returned a failure status. Response: $response");
        isLoading = false;
      }
    } catch (e) {
      print('Error fetching order data: $e');
      isLoading = false;
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
        throw const FormatException("Invalid date format");
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
          'Active and History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                  child:
                      isListingView ? _buildListingView() : _buildOrderView(),
                ),
              ],
            ),
    );
  }

  // Helper method to build the Tab-like button
  Widget _buildTabButton(String label, int index) {
    bool isSelected =
        (index == 0 && isListingView) || (index == 1 && !isListingView);

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
          boxShadow: const [
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
    if (listingData.isEmpty) {
      // Show "No listing yet" message when the list is empty
      return Center(
        child: Text(
          "No listings yet",
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }

    // Render the list if data exists
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
                  backgroundImage: item["profile_pic"] != null &&
                          item["profile_pic"].isNotEmpty
                      ? MemoryImage(item["profile_pic"] as typed_data.Uint8List)
                      : null,
                  radius: 20,
                ),
                title: Text(
                  item["carrier_name"] ?? "Carrier Name",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        dynamic response = await checkExistingOrder(
                            api: '/listing/count-orders', id: item['id']);

                        if (response['status'] == "success") {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditListingScreen(),
                              settings: RouteSettings(arguments: item),
                            ),
                          );

                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.topSlide,
                            title: 'Error',
                            desc: response["message"],
                            btnOkIcon: Icons.check,
                            btnOkOnPress: () {},
                          ).show();
                        }
                      },
                      child: const Text("Edit"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic for deleting the listing
                        print(
                            "Delete button pressed for ${item['carrier_name']}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300], // Red delete button
                      ),
                      child: const Text("Delete"),
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
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: orderData.length,
      itemBuilder: (context, index) {
        final item = orderData[index];
        final orderStatus = item["order_status"]?.toLowerCase();
        final paymentStatus = item["payment_status"]?.toLowerCase();

        // Determine if the "Pay Now" button should be disabled
        final isPayNowDisabled = paymentStatus == "completed" ||
            orderStatus == "waiting" ||
            orderStatus == "cancelled";

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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('Payment Status: ${item["payment_status"] ?? "Unknown"}'),
                Text('Order Status: ${item["order_status"] ?? "Unknown"}'),
                Text(
                    'Package Location: ${item["package_location"] ?? "Unknown"}'),
                Text('Notes: ${item["notes"] ?? "No notes"}'),
                Text('Created At: ${item["created_at"] ?? "Unknown"}'),
                const SizedBox(height: 8),
                Text('Carrier: ${item["listing"]["carrier_name"]}'),
                Text('Destination: ${item["listing"]["destination"]}'),
                Text('Flight Date: ${item["listing"]["flight_date"]}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: isPayNowDisabled
                          ? null
                          : () async {
                              print(
                                  "Processing payment for Order ID: ${item['id']}");
                              String api = "/order/get-payment-details";

                              try {
                                dynamic response = await getBankDetails(
                                    carrierID: 3, api: api);

                                if (response["status"] == "success" &&
                                    response["message"]["status"] == "exist") {
                                  try {
                                    final encryptedHolder =
                                        enc.Encrypted.fromBase64(
                                            response["message"]
                                                ["account_holder"]);
                                    final encryptedNumber =
                                        enc.Encrypted.fromBase64(
                                            response["message"]
                                                ["account_number"]);

                                    final decrypted = decryptData(
                                      accountHolder: encryptedHolder,
                                      accountNumber: encryptedNumber,
                                    );

                                    String bankName =
                                        response["message"]["bank_name"] ?? "";
                                    String accountNumber =
                                        decrypted['number'] ?? "";
                                    String accountHolderName =
                                        decrypted['holder'] ?? "";

                                    print("Bank Name: $bankName");
                                    print("Account Number: $accountNumber");
                                    print(
                                        "Account Holder Name: $accountHolderName");

                                    // Display payment details modal
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setModalState) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: 16.0,
                                                left: 16.0,
                                                right: 16.0,
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.arrow_back,
                                                              size: 28),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        const Text(
                                                          "Payment Details",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    _buildDetailRow(
                                                        Icons.account_balance,
                                                        "Bank Name:",
                                                        bankName),
                                                    _buildDetailRow(
                                                        Icons.credit_card,
                                                        "Account No:",
                                                        accountNumber),
                                                    _buildDetailRow(
                                                        Icons.person,
                                                        "Account Holder:",
                                                        accountHolderName),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      children: [
                                                        ElevatedButton.icon(
                                                          onPressed: () async {
                                                            await _pickImagePayment();
                                                            setModalState(
                                                                () {});
                                                          },
                                                          icon: const Icon(
                                                              Icons
                                                                  .photo_library,
                                                              size: 24),
                                                          label: const Text(
                                                              "Upload Proof of Payment"),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[300],
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        12),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    if (photoPayment != null)
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Uploaded Image:",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Image.memory(
                                                              photoPayment!,
                                                              height: 500,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    const SizedBox(height: 20),
                                                    Center(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.blue,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      40,
                                                                  vertical: 16),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          "Proceed",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    print("Error during decryption: $e");
                                  }
                                } else if (response['status'] == 'error') {
                                  print(
                                      "Failed to fetch payment details. Response: $response");
                                }
                              } catch (e) {
                                print("An error occurred: $e");
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isPayNowDisabled ? Colors.grey[300] : Colors.blue,
                      ),
                      child: const Text(
                        "Pay Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
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
