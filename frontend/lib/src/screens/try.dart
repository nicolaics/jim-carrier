import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/screens/login_screen.dart';
import 'package:jim/src/screens/profile_menu.dart';
import 'package:jim/src/screens/update_profile.dart';
import 'package:jim/src/screens/all_datas.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants/image_strings.dart';
import 'base_client.dart';

class TryScreen extends StatefulWidget {
  const TryScreen({super.key});

  @override
  State<TryScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();

  String? user_name;
  String? user_email;
  Uint8List? photo;

  // Fetch data in initState
  @override
  void initState() {
    super.initState();
    fetchUserEmail();  // Call the function when the widget is initialized
  }

  // Async function to fetch user data
  Future<void> fetchUserEmail() async {
    try {
      String api = "/user/current";
      Map response = await apiService.get(api: api) as Map;  // Await the response
      print("Response: $response");
      setState(() {
        user_name = response['name'];
        user_email = response['email'];
        photo = base64Decode(response['profilePicture']); // Decode the photo from base64
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateToUpdateProfile() async {
    // Navigate to the UpdateProfileScreen and wait for the result
    final updatedImage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
    );

    if (updatedImage != null) {
      // If there was an updated image, update the UI accordingly
      setState(() {
        photo = updatedImage as Uint8List;  // Assuming the updated image is returned as Uint8List
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1, // Adjust the width to make the border thicker or thinner
                      ),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: photo == null
                          ? Icon(Icons.account_circle, size: 120) // Placeholder if photo is null
                          : Image.memory(
                        photo!,
                        fit: BoxFit.cover, // Ensures the image fits well within the circle
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.yellow,
                      ),
                      child: const Icon(
                        LineAwesomeIcons.pencil_alt_solid, size: 20.0, color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Display user_name and user_email only after they are fetched
              user_name == null || user_email == null
                  ? CircularProgressIndicator()  // Show a loading indicator until data is fetched
                  : Column(
                children: [
                  Text(user_name!, style: GoogleFonts.anton(fontSize: 20)),
                  Text(user_email!, style: GoogleFonts.anton(fontSize: 20)),
                ],
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _navigateToUpdateProfile, // Call the new method here
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: Text("Edit Profile", style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog_solid,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Billing Details",
                icon: LineAwesomeIcons.wallet_solid,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "User Management",
                icon: LineAwesomeIcons.user_check_solid,
                onPress: () {},
              ),
              const Divider(),
              SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Information",
                icon: LineAwesomeIcons.info_solid,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Log Out",
                icon: LineAwesomeIcons.sign_out_alt_solid,
                textColor: Colors.red,
                endIcon: false,
                onPress: () async {
                  final controller = Controller();
                  await controller.signOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
