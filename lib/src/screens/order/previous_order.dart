// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jim/src/api/bank_detail.dart';
import 'package:jim/src/api/listing.dart';
import 'package:jim/src/api/order.dart';
import 'package:jim/src/api/review.dart';
import 'package:jim/src/constants/colors.dart';
import 'package:jim/src/utils/formatter.dart';
import '../../auth/encryption.dart';
import '../listing/edit_listing.dart';
import 'package:encrypt/encrypt.dart' as enc;

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
  bool isLoading2=true;

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
                  "Leave a Review for $carrierName",
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
                        "Review Submitted: ${_reviewController.text}, Rating: $rating");
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
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.topSlide,
                        title: 'Success',
                        desc: response["message"].toString().capitalizeFirst,
                        btnOkIcon: Icons.check,
                        btnOkOnPress: () {
                          Navigator.pop(context); // Close the modal
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
                          _reviewController.clear(); // Clear text on error
                        },
                      ).show();
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      _reviewController.clear(); // Clear review text when modal is closed
      setState(() {
        _selectedRating = 0; // Reset rating when modal is closed
      });
    });
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
            "price":
                Formatter.formatPrice(data['pricePerKg'], data['currency']),
            "available_weight":
                "${Formatter.formatWeight(data['weightAvailable'])} kg",
            "flight_date": Formatter.formatDate(data['departureDate']),
            "lastReceiveDate": Formatter.formatDate(data['lastReceivedDate']),
            "description": data['description'] ?? 'No description',
            "carrier_rating": data['carrierRating'] ?? 0,
            "profile_pic": data['carrierProfileImage'],
            "accountHolderName": data['bankDetail']['accountHolder'],
            "accountNumber": data['bankDetail']['accountNumber'],
            "bankName": data['bankDetail']['bankName'],
            "listStatus": data['expStatus'] ?? 'Unknown',
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
        isLoading2= true;
      });
      String api = "/order/giver"; // Correct endpoint
      dynamic response = await getAllOrders(api: api); // Fetch API data
     // print("Order data ${response['message']['listing']}");

      if (response["status"] == "success") {
        response["message"] = response["message"] as List;

        List<Map<String, dynamic>> updatedOrders = [];

        for (var data in response["message"]) {
          updatedOrders.add({
            "id": data['id'] ?? 'Unknown',
            "weight": "${Formatter.formatWeight(data['weight'])} kg",
            "price": Formatter.formatPrice(data['price'], data['currency']),
            "payment_status": data['paymentStatus'] ?? 'Unknown',
            "order_status": data['orderStatus'] ?? 'Unknown',
            "package_location": data['packageLocation'] ?? 'Unknown',
            "notes": data['notes'] ?? 'No notes',
            "created_at": Formatter.formatDate(data['createdAt']),
            "listing": {
              "carrier_name": data['listing']?['carrierName'] ?? 'Unknown',
              "carrier_id": data['listing']?['carrierId'] ?? 'Unknown',
              "destination":
                  data['listing']?['destination'] ?? 'No destination',
              "flight_date":
                  Formatter.formatDate(data['listing']?['departureDate']),
            },
          });
        }

        setState(() {
          orderData = updatedOrders;
          isLoading2 = false;
        });
      } else {
        print("Error: API returned a failure status. Response: $response");
        isLoading2 = false;
      }
    } catch (e) {
      print('Error fetching order data: $e');
      isLoading2 = false;
    }
  }

  bool isListingView = true; // Boolean to toggle between listing and order view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'History',
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
                // Tab-like buttons
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabButton("Listing", 0),
                      const SizedBox(width: 8),
                      _buildTabButton("Order", 1),
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

        // Determine if the bulb should be green (available) or grey (not available)
        final isBulbGreen = item['listStatus']?.toLowerCase() == 'available';

        return Stack(
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Listing #${item["id"].toString()}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Destination:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                width:
                                    8), // Adds some spacing between title and data
                            Text(
                              '${item["destination"]!.toString().capitalizeFirst}',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Price:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                width:
                                    8), // Adds some spacing between title and data
                            Text(
                              '${item["price"] ?? "N/A"}',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Available Weight:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                width:
                                    8), // Adds some spacing between title and data
                            Text(
                              '${item["available_weight"] ?? "N/A"}',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Flight Date:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                width:
                                    8), // Adds some spacing between title and data
                            Text(
                              '${item["flight_date"] ?? "N/A"}',
                            ),
                          ],
                        ),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsTheme.skyBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            dynamic response = await checkExistingOrder(
                                api: '/listing/count-orders', id: item['id']);

                            if (response['status'] == "success") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditListingScreen(),
                                  settings: RouteSettings(arguments: item),
                                ),
                              );
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                title: 'Error',
                                desc: response["message"]
                                    .toString()
                                    .capitalizeFirst,
                                btnOkIcon: Icons.check,
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Add logic for deleting the listing
                            print("Delete button pressed for ${item['id']}");
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.scale,
                              title: 'Delete',
                              desc:
                                  'Are you sure you want to delete this listing?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                print('Deleting the listing...');
                                try {
                                  dynamic response = await deleteListing(
                                      id: item['id'], api: '/listing');
                                  if (response['status'] == "error") {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.topSlide,
                                      title: 'Error',
                                      desc: response["message"]
                                          .toString()
                                          .capitalizeFirst,
                                      btnOkIcon: Icons.check,
                                      btnOkOnPress: () {},
                                    ).show();
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.bottomSlide,
                                      title: 'Success',
                                      desc: 'Listing deleted successfully.',
                                      btnOkIcon: Icons.check,
                                      btnOkOnPress: () {
                                        setState(() {
                                          fetchListing();
                                        });
                                      },
                                    ).show();
                                  }
                                } catch (error) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.topSlide,
                                    title: 'Error',
                                    desc:
                                        'Something went wrong. Please try again later.',
                                    btnOkIcon: Icons.check,
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              },
                            ).show();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 25,
              right: 35,
              child: Icon(
                Icons.circle,
                color: isBulbGreen ? Colors.green : Colors.grey,
                size: 20,
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to build the Order view with dynamic data
  Widget _buildOrderView() {
    if (isLoading2) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (orderData.isEmpty) {
      // Show "No listing yet" message when the list is empty
      return Center(
        child: Text(
          "No order yet",
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
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

        // Determine if the bulb should light up
        final isBulbLit =
            orderStatus != "completed" && orderStatus != "cancelled";

        bool isReviewDisabled = false;
        if (paymentStatus == "completed" && orderStatus == "completed") {
          isReviewDisabled = true;
        }

        return Stack(
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
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
                    Row(
                      children: [
                        const Text(
                          'Payment Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8), // Adds some spacing between title and data
                        Text(
                          '${(item["payment_status"]!).toString().capitalizeFirst}',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Order Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(item["order_status"]!).toString().capitalizeFirst}',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Package Location:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item["package_location"] ?? "Unknown"}',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Notes:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item["notes"] ?? "No notes"}',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Created At:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${item["created_at"] ?? "Unknown"}',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Carrier:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${item["listing"]["carrier_name"]}',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Destination:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${item["listing"]["destination"]}',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Flight Date:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${item["listing"]["flight_date"]}',
                        ),
                      ],
                    ),
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
                                  print(
                                      "Processing payment for carrier ID: ${item['listing']['carrier_id']}");

                                  try {
                                    dynamic response =
                                        await getCarrierBankDetail(
                                            carrierID: item['listing']['carrier_id'], api: api);

                                    if (response["status"] == "success" &&
                                        response["message"]["status"] ==
                                            "exist") {
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

                                        String bankName = response["message"]
                                                ["bank_name"] ??
                                            "";
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
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons
                                                                      .arrow_back,
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
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 12),
                                                        _buildDetailRow(
                                                            Icons
                                                                .account_balance,
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
                                                        const SizedBox(
                                                            height: 12),
                                                        Row(
                                                          children: [
                                                            ElevatedButton.icon(
                                                              onPressed:
                                                                  () async {
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
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        300],
                                                                padding: const EdgeInsets
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
                                                        const SizedBox(
                                                            height: 12),
                                                        if (photoPayment !=
                                                            null)
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "Uploaded Image:",
                                                                style:
                                                                    TextStyle(
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
                                                                alignment:
                                                                    Alignment
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
                                                                child: Image
                                                                    .memory(
                                                                  photoPayment!,
                                                                  height: 500,
                                                                  width: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Center(
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40,
                                                                      vertical:
                                                                          16),
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
                            backgroundColor: isPayNowDisabled
                                ? Colors.grey[300]
                                : Colors.redAccent.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Pay Now",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            isReviewDisabled
                                ? null
                                : _showReviewModal(
                                    item["listing"]["carrier_name"] ??
                                        "Unknown Carrier",
                                    item["id"],
                                  );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isReviewDisabled
                                ? Colors.grey[300]
                                : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Leave Review",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 25,
              right: 35,
              child: Icon(
                Icons.circle,
                color: isBulbLit ? Colors.green : Colors.grey,
                size: 20,
              ),
            ),
          ],
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
