import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jim/src/constants/image_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Sample data for the list with more details
  final List<Map<String, String>> items = [
    {
      "name": "Giri Pravas",
      "destination": "Going to Ktm",
      "price": "10000 won per kg",
      "available_weight": "5kg available",
      "flight_date": "2024-12-12"
    },
    {
      "name": "Christian",
      "destination": "Going to Indonesia",
      "price": "10000 won per kg",
      "available_weight": "5kg available",
      "flight_date": "2024-12-12"
    },
    {
      "name": "Igor",
      "destination": "Going to Russia",
      "price": "10000 won per kg",
      "available_weight": "5kg available",
      "flight_date": "2024-12-12"
    },
    {
      "name": "Nhi",
      "destination": "Going to Vietnam",
      "price": "10000 won per kg",
      "available_weight": "5kg available",
      "flight_date": "2024-12-12"
    },
    {
      "name": "Kim Namjoon",
      "destination": "Going to Korea",
      "price": "10000 won per kg",
      "available_weight": "5kg available",
      "flight_date": "2024-12-12"
    },
  ];

  String? selectedValue; // For the dropdown button
  void _performSearch() {
    final query = _searchController.text;
    print("Searching for: $query");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: "Search",
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: _performSearch,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "AVAILABLE CARRIERS",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: DropdownButton<String>(
                    value: selectedValue,
                    hint: const Text("SORT BY"),
                    items: <String>['Alphabetical', 'High to Low', 'Nearest Date']
                        .map<DropdownMenuItem<String>>((String value) {
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
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundImage: AssetImage(WelcomeScreenImage), // Ensure this path is correct
                          radius: 20,
                        ),
                      ],
                    ),
                    title: Text(
                      items[index]["name"] ?? "Name",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index]["destination"] ?? "Destination",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[index]["price"] ?? "Price",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          items[index]["available_weight"] ?? "Available Weight",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          items[index]["flight_date"] ?? "Flight Date",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        print("Button pressed for ${items[index]["name"]}");
                      },
                      child: const Text("View"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onTap: () {
                      print("Tapped on ${items[index]["name"]}");
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
