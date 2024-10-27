import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csc_picker/csc_picker.dart';

import 'base_client.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({Key? key}) : super(key: key);

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
  final TextEditingController _additionalInfoController = TextEditingController();

  // Static list of currencies
  final List<String> _currencies = ['KRW', 'USD', 'GBP'];

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'New Listing',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[300],
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
                color: Colors.grey[200],
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: CSCPicker(
                layout: Layout.vertical,
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
                fillColor: Colors.grey[200],
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
                      fillColor: Colors.grey[200],
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
                      fillColor: Colors.grey[200],
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
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
                fillColor: Colors.grey[200],
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
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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

                  double weight = double.tryParse(_weightController.text) ?? 0.0;
                  double price = double.tryParse(_priceController.text) ?? 0.0;

                  String date = _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '';
                  String lastDate = _lastDateToReceive != null ? DateFormat('yyyy-MM-dd').format(_lastDateToReceive!) : '';

                  // Call the API to add the listing

                 String result= await apiService.addListing(
                    destination: location,
                    weight: weight,
                    price: price,
                    currency: _selectedCurrency ?? '',
                    date: date,
                    lastDate: lastDate,
                    additionalInfo: _additionalInfoController.text,
                    api: "/listing",
                  );

                 print(result);
                },
                child: const Text('SUBMIT', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
