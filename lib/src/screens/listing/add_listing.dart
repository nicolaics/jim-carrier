// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:jim/src/api/listing.dart';
import 'package:jim/src/constants/colors.dart';
import 'package:jim/src/constants/currency.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';
import 'package:jim/src/utils/formatter.dart';

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
  final TextEditingController _additionalInfoController =
      TextEditingController();

  String _lastPriceValue = "";
  String _lastWeightValue = "";

  @override
  void initState() {
    super.initState();
    _priceController.addListener(() {
      String rawValue =
          _priceController.text.replaceAll(',', ''); // Remove commas

      if (rawValue == _lastPriceValue) return; // Prevent infinite loop

      // Get the current caret position
      int oldCaretPosition = _priceController.selection.baseOffset;

      // Format the new value
      String formattedValue =
          NumberFormat('#,##0').format(double.tryParse(rawValue) ?? 0.0);

      // Calculate the new caret position based on the difference in string lengths
      int adjustment = formattedValue.length - rawValue.length;
      int newCaretPosition = oldCaretPosition + adjustment;

      setState(() {
        _lastPriceValue = rawValue;
        _priceController.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(
            offset: newCaretPosition.clamp(0, formattedValue.length),
          ),
        );
      });
    });

    _weightController.addListener(() {
      String rawValue =
          _weightController.text.replaceAll(',', ''); // Remove commas

      if (rawValue == _lastWeightValue) return; // Prevent infinite loop

      // Get the current caret position
      int oldCaretPosition = _weightController.selection.baseOffset;

      // Format the new value
      String formattedValue =
          NumberFormat('#,##0').format(double.tryParse(rawValue) ?? 0.0);

      // Calculate the new caret position based on the difference in string lengths
      int adjustment = formattedValue.length - rawValue.length;
      int newCaretPosition = oldCaretPosition + adjustment;

      setState(() {
        _lastWeightValue = rawValue;
        _weightController.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(
            offset: newCaretPosition.clamp(0, formattedValue.length),
          ),
        );
      });
    });
  }

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
                    items: currencyMap.entries
                        .map((entry) => DropdownMenuItem(
                              value: entry.value,
                              child: Text(entry.value),
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(), // Cannot select dates in the past
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;

                              // Clear the "Last Date to Receive" if it conflicts
                              if (_lastDateToReceive != null &&
                                  _lastDateToReceive!.isAfter(_selectedDate!)) {
                                _lastDateToReceive = null;
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: _selectedDate ?? DateTime(2101),
                          );
                          if (picked != null && picked != _lastDateToReceive) {
                            setState(() {
                              _lastDateToReceive = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _lastDateToReceive != null
                                ? DateFormat('yyyy-MM-dd').format(_lastDateToReceive!)
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

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: ColorsTheme.skyBlue,
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
                  double weight = double.tryParse(
                          Formatter.removeCommas(_weightController.text)) ??
                      0.0;
                  double price = double.tryParse(
                          Formatter.removeCommas(_priceController.text)) ??
                      0.0;

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

                  // Call the API to add the listing
                  dynamic response = await addListing(
                    destination: location,
                    weight: weight,
                    price: price,
                    currency: _selectedCurrency ?? '',
                    date: date,
                    lastDate: lastDate,
                    additionalInfo: _additionalInfoController.text,
                    api: "/listing",
                  );

                  if (response['status'] == "success") {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      title: 'Sucess',
                      desc: 'Create listing successful',
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
                      title: 'Create Listing Failed',
                      desc: response["message"].toString().capitalizeFirst,
                      btnOkIcon: Icons.check,
                      btnOkOnPress: () {},
                    ).show();
                  }
                },
                child:
                    const Text('Submit', style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
