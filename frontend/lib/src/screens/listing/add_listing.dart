// ignore_for_file: library_private_types_in_public_api

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:jim/src/api/listing.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';
import 'package:jim/src/auth/encryption.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  String? _selectedCountry = "";
  String? _selectedState;
  String? _selectedCity;
  DateTime? _selectedDate;
  DateTime? _lastDateToReceive;
  String? _selectedCurrency;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _accountHolderName = TextEditingController();
  final TextEditingController _bankName = TextEditingController();
  final TextEditingController _bankAccountNo = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  // Static list of currencies
  final List<String> _currencies = ['KRW', 'USD', 'GBP'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          'New Listing',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Destination',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: CSCPicker(
                layout: Layout.vertical,
                dropdownDecoration: BoxDecoration(
                  color: Colors
                      .white, // Set background color of the dropdown to white
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey),
                ),
                disabledDropdownDecoration: BoxDecoration(
                  color: Colors.white, // Also set disabled state color to white
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey),
                ),
                dropdownItemStyle: const TextStyle(
                  color: Colors
                      .black, // Set text color to black for better readability
                ),
                onCountryChanged: (country) {
                  setState(() {
                    _selectedCountry = country;
                    _selectedState = null;
                    _selectedCity = null;
                  });
                },
                onStateChanged: (state) {
                  setState(() {
                    _selectedState = state;
                    _selectedCity = null;
                  });
                },
                onCityChanged: (city) {
                  setState(() {
                    _selectedCity = city;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Weight Available',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Weight in kilograms",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Price',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Per kilogram",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    items: _currencies
                        .map((currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCurrency = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    hint: const Text('Currency'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Departure Date and Last Date to Receive
            Row(
              children: [
                // Departure Date Picker
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Departure Date',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(_selectedDate!)
                                : 'Select Date',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Last Date to Receive Picker
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last Date to Receive',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != _lastDateToReceive) {
                            setState(() {
                              _lastDateToReceive = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _lastDateToReceive != null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(_lastDateToReceive!)
                                : 'Select Date',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Additional Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _additionalInfoController,
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
            const SizedBox(height: 20),
            const Text(
              'Account Holder Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            TextFormField(
              controller: _accountHolderName,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Account Holder Name",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            const Text(
              'Bank Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            TextFormField(
              controller: _bankName,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.house),
                  labelText: "Bank Name",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            const Text(
              'Bank Account Number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            TextFormField(
              controller: _bankAccountNo,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  labelText: "Account Number",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),


            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () async {
                  String removeFlags(String input) {
                    // Regular expression to remove emojis (including country flags)
                    final RegExp regex = RegExp(
                      r'[\u{1F1E6}-\u{1F1FF}]',
                      unicode: true,
                    );
                    return input.replaceAll(regex, '');
                  }

                  String location = [
                    removeFlags(_selectedCity ?? '').trim(),
                    removeFlags(_selectedState ?? '').trim(),
                    removeFlags(_selectedCountry ?? '').trim(),
                  ].where((element) => element.isNotEmpty).join(', ');

                  print('Selected Country: $location');
                  print('Selected State: $_selectedState');
                  print('Selected City: $_selectedCity');
                  print('Weight Available: ${_weightController.text}');
                  print('Price per KG: ${_priceController.text}');
                  print('Selected Currency: $_selectedCurrency');
                  print(
                      'Departure Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Not Selected'}');
                  print(
                      'Last Date to Receive: ${_lastDateToReceive != null ? DateFormat('yyyy-MM-dd').format(_lastDateToReceive!) : 'Not Selected'}');
                  print('Additional Info: ${_additionalInfoController.text}');

                  // Prepare the data for the addListing call
                  double weight =
                      double.tryParse(_weightController.text) ?? 0.0;
                  double price = double.tryParse(_priceController.text) ?? 0.0;

                  String formatDateWithTimeZone(DateTime dateTime) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(dateTime);
                    String timeZoneOffset = dateTime.timeZoneOffset.inHours >= 0
                        ? '+${dateTime.timeZoneOffset.inHours.toString().padLeft(2, '0')}'
                        : dateTime.timeZoneOffset.inHours
                            .toString()
                            .padLeft(3, '0');

                    // Adjust for minutes if needed
                    if (dateTime.timeZoneOffset.inMinutes % 60 != 0) {
                      int minutes =
                          (dateTime.timeZoneOffset.inMinutes.abs() % 60);
                      timeZoneOffset += minutes < 10 ? '0$minutes' : '$minutes';
                    } else {
                      timeZoneOffset +=
                          '00'; // Append zero minutes if no additional offset
                    }

                    // Assuming KST as a constant, you can replace this with a dynamic value if needed
                    String timeZoneAbbreviation =
                        'KST'; // Change this according to the actual timezone if needed

                    return '$formattedDate $timeZoneOffset$timeZoneAbbreviation';
                  }

                  String date = _selectedDate != null
                      ? formatDateWithTimeZone(_selectedDate!)
                      : '';

                  String lastDate = _lastDateToReceive != null
                      ? formatDateWithTimeZone(_lastDateToReceive!)
                      : '';

                  // Print statements
                  print('Departure Date: $date');
                  print('Last Date to Receive: $lastDate');
                      final encrypted = encryptData(
                        accountHolder: _accountHolderName.text,
                        accountNumber: _bankAccountNo.text,
                      );

                      print("Encrypted Data:");
                      print("Holder: ${encrypted['holder']?.base64}");
                      print("Number: ${encrypted['number']?.base64}");

                      final decrypted = decryptData(
                        accountHolder: encrypted['holder']!,
                        accountNumber: encrypted['number']!,
                      );

                      print("Decrypted Data:");
                      print("Holder: ${decrypted['holder']}");
                      print("Number: ${decrypted['number']}");

                  print("tumbler");
                  // Call the API to add the listing
                  String result = await addListing(
                    destination: location,
                    weight: weight,
                    price: price,
                    currency: _selectedCurrency ?? '',
                    date: date,
                    lastDate: lastDate,
                    additionalInfo: _additionalInfoController.text,
                    accountHolder: encrypted["holder"]!.base64,
                    accountNumber: encrypted["number"]!.base64,
                    bankName: _bankName.text,
                    api: "/listing",
                  );

                  print(result);
                  if(result=="success"){
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      title: 'Sucess',
                      desc: 'Listing Successful',
                      btnOkIcon: Icons.check,
                      btnOkOnPress: () {
                        Get.to(() => const BottomBar(0));
                      },
                    ).show();
                  }
                  else{
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.topSlide,
                      title: 'ERROR',
                      desc: 'Listing not Successful',
                      btnOkIcon: Icons.check,
                      btnOkOnPress: () {
                      },
                    ).show();
                  }
                  Get.to(() => const BottomBar(0));
                },
                child:
                    const Text('SUBMIT', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
