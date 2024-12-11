// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jim/src/api/auth.dart';
import 'package:jim/src/constants/colors.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/auth/secure_storage.dart';
import 'package:jim/src/screens/auth/login_screen.dart';
import 'package:jim/src/screens/bank/bank.dart';
import 'package:jim/src/screens/coming_soon.dart';
import 'package:jim/src/screens/profile/profile_menu.dart';
import 'package:jim/src/screens/profile/update_profile.dart';
import 'package:jim/src/base_class/login_google.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ProfileScreen> {
  // final TextEditingController _searchController = TextEditingController();
  final storage = const FlutterSecureStorage();

  String? userName;
  String? userEmail;
  Uint8List? photo;

  // Fetch data in initState
  @override
  void initState() {
    super.initState();
    fetchUserEmail(); // Call the function when the widget is initialized
  }

  // Async function to fetch user data
  Future<void> fetchUserEmail() async {
    try {
      String api = "/user/current";
      dynamic response = await getCurrentUser(api: api); // Await the response

      if (response["status"] == "success") {
        response["message"] = response["message"] as Map;

        setState(() {
          userName = response["message"]['name'];
          userEmail = response["message"]['email'];
          photo = base64Decode(response["message"]
              ['profilePicture']); // Decode the photo from base64
        });
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Error',
          desc: response["message"].toString().capitalizeFirst,
          btnOkIcon: Icons.check,
          btnOkOnPress: () {},
        ).show();
      }
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
        photo = updatedImage
            as Uint8List; // Assuming the updated image is returned as Uint8List
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
                        width:
                            1, // Adjust the width to make the border thicker or thinner
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: photo == null
                          ? const Icon(Icons.account_circle,
                              size: 120) // Placeholder if photo is null
                          : Image.memory(
                              photo!,
                              fit: BoxFit
                                  .cover, // Ensures the image fits well within the circle
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
                        LineAwesomeIcons.pencil_alt_solid,
                        size: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Display userName and userEmail only after they are fetched
              userName == null || userEmail == null
                  ? const CircularProgressIndicator() // Show a loading indicator until data is fetched
                  : Column(
                      children: [
                        Text(userName!, style: GoogleFonts.anton(fontSize: 20)),
                        Text(userEmail!,
                            style: GoogleFonts.anton(fontSize: 20)),
                      ],
                    ),

              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed:
                      _navigateToUpdateProfile, // Call the new method here
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(20, 40),
                    backgroundColor: ColorsTheme.skyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Edit Profile",
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog_solid,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                onPress: () {
                  Get.to(() => const ComingSoonScreen(), arguments: 'Settings');
                },
              ),
              ProfileMenuWidget(
                title: "Bank Details",
                icon: LineAwesomeIcons.wallet_solid,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                onPress: () {
                  Get.to(() => const BankScreen(), arguments: 'Billing Details');
                },
              ),
              ProfileMenuWidget(
                title: "Billing Details",
                icon: LineAwesomeIcons.wallet_solid,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                onPress: () {
                  Get.to(() => const ComingSoonScreen(), arguments: 'Billing Details');
                },
              ),
              ProfileMenuWidget(
                title: "User Management",
                icon: LineAwesomeIcons.user_check_solid,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                onPress: () {
                  Get.to(() => const ComingSoonScreen(), arguments: 'User Management');
                },
              ),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Information",
                icon: LineAwesomeIcons.info_solid,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                onPress: () {
                  Get.to(() => const ComingSoonScreen(), arguments: 'Information');
                },
              ),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Log Out",
                icon: LineAwesomeIcons.sign_out_alt_solid,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                textColor: Colors.black,
                endIcon: false,
                onPress: () async {
                  await logout(api: '/user/logout');
                  await StorageService.deleteTokens();
                  final controller = Controller();
                  await controller.signOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
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
