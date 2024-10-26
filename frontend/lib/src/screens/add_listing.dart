import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csc_picker/csc_picker.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({Key? key}) : super(key: key);

  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  DateTime? _selectedDate;
  String? _selectedCurrency;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController(); // Controller for Additional Info

  // Static list of currencies
  final List<String> _currencies = ['Won', 'USD', 'Pound'];

  @override
  Widget build(BuildContext context) {
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
            // Location Picker
            const Text(
              'Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: CSCPicker(
                layout: Layout.vertical,
                onCountryChanged: (country) {
                  setState(() {
                    _selectedCountry = country;
                    _selectedState = null; // Reset state and city when country changes
                    _selectedCity = null;
                  });
                },
                onStateChanged: (state) {
                  setState(() {
                    _selectedState = state;
                    _selectedCity = null; // Reset city when state changes
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

            // Weight Available Field
            const Text(
              'Weight Available',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Price per KG Field
            const Text(
              'Price per KG',
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: DropdownButton<String>(
                    isExpanded: true, // Expand dropdown to fill the space
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
                    hint: const Text('Currency'), // Show hint when no currency is selected
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Departure Date Field
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
            const SizedBox(height: 20),

            // Additional Info Field
            const Text(
              'Additional Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _additionalInfoController, // Set the controller for Additional Info
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  // Print all selected values
                  print('Selected Country: $_selectedCountry');
                  print('Selected State: $_selectedState');
                  print('Selected City: $_selectedCity');
                  print('Weight Available: ${_weightController.text}');
                  print('Price per KG: ${_priceController.text}');
                  print('Selected Currency: $_selectedCurrency');
                  print('Departure Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Not Selected'}');
                  print('Additional Info: ${_additionalInfoController.text}'); // Print Additional Info
                },
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
