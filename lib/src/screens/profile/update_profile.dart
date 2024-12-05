// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jim/src/api/auth.dart';
import 'package:jim/src/screens/profile/update_password.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../constants/sizes.dart';
import 'dart:typed_data';
import 'package:jim/src/screens/home/bottom_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Uint8List? photo;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchUserEmail(); // Fetch user data during initialization
  }

  // Fetch user data from API
  Future<void> fetchUserEmail() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      String api = "/user/current";
      dynamic response = await getCurrentUser(api: api); // Await the response

      if (response["status"] == "success") {
        response["message"] = response["message"] as Map;

        setState(() {
          // Set controllers with fetched data
          _nameController.text = response["message"]['name'] ?? '';
          _emailController.text = response["message"]['email'] ?? '';
          _phoneController.text = response["message"]['phoneNumber'] ?? '';
          photo = base64Decode(response["message"]['profilePicture'] ?? '');
          isLoading = false; // Stop loading after fetching data
        });
      } else {
        setState(() {
          isLoading = false; // Stop loading even if there's an error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to fetch user data: ${response["message"]}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while fetching user data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
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
                    child: GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image == null) return;

                        // Convert image to bytes
                        final bytes = await File(image.path).readAsBytes();

                        print("image path: ${image.path}");

                        dynamic response;

                        // TODO: find the path of the default image
                        if (image.path ==
                            'assets/images/welcomePage/welcome_screen.png') {
                          response = await updateProfilePicture(
                            api: '/user/update-profile-picture',
                          );
                        } else {
                          response = await updateProfilePicture(
                            img: bytes,
                            api: '/user/update-profile-picture',
                          );
                        }

                        setState(() {
                          photo =
                              bytes; // Update the photo variable with the new image bytes
                        });

                        if (response["status"] == "success") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Profile picture updated successfully.')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to update profile picture: ${response["message"]}')),
                          );
                        }
                        // You can handle the response here, if needed
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.yellow,
                        ),
                        child: const Icon(
                          LineAwesomeIcons.camera_retro_solid,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.numbers),
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to Change Password Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UpdatePassword()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          backgroundColor:
                              Colors.black, // Choose your desired color
                        ),
                        child: const Text(
                          "Change Password",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Retrieve values from text controllers
                          String name = _nameController.text.trim();
                          String email = _emailController.text.trim();
                          String phoneNumber = _phoneController.text.trim();

                          // Check if any of the fields are empty
                          if (name.isEmpty ||
                              email.isEmpty ||
                              phoneNumber.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all fields.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // Exit if any field is empty
                          }

                          // Name validation: Check length and ensure only alphabets are used
                          final RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
                          if (name.length < 2 || !nameRegex.hasMatch(name)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter a valid name (only alphabets and at least 2 characters).'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          // Phone number validation (must be exactly 10 digits)
                          if (phoneNumber.length != 11 ||
                              !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter a valid 11-digit phone number.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // Exit if the phone number is invalid
                          }

                          // Email format validation using regex
                          final RegExp emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );

                          if (!emailRegex.hasMatch(email)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please enter a valid email address.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // Exit if the email format is invalid
                          }

                          dynamic response= await updateProfile(name: name, phoneNumber: phoneNumber, api: "/user/modify");

                          if(response['status']=="success"){
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.topSlide,
                              title: 'Sucess',
                              desc: 'Profile Updated',
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
                              title: 'Error',
                              desc: 'Profile Update failed',
                              btnOkIcon: Icons.check,
                              btnOkOnPress: () {
                              },
                            ).show();
                          }




                          // All validations passed, proceed with registration
                        },
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            "Joined at October 19, 2024",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            elevation: 0,
                            foregroundColor: Colors.red,
                            shape: const StadiumBorder(),
                            side: BorderSide.none,
                          ),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
