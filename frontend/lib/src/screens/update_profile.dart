import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants/image_strings.dart';
import '../constants/sizes.dart';
import 'base_client.dart';
import 'dart:typed_data';


class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ApiService apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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

  @override
  Widget build(BuildContext context) {

    void onProfileTapped(){

    }
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
                    child: GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image == null) return;

                        // Convert image to bytes
                        final bytes = await File(image.path).readAsBytes();

                        // Update the UI with the new photo
                        setState(() {
                          photo = bytes;  // Update the photo variable with the new image bytes
                        });

                        // Upload the new profile picture (optional)
                        String response = await apiService.update_profile(
                          img: bytes,
                          api: '/user/update-profile-picture',  // Provide your API base URL
                        );

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          title: 'Success',
                          desc: 'Image Updated',
                          btnOkIcon: Icons.check,
                          btnOkOnPress: () {
                            Navigator.pop(context, bytes);
                          },
                        )..show();

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
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.numbers),
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Retrieve values from text controllers
                          String name = _nameController.text.trim();
                          String email = _emailController.text.trim();
                          String phoneNumber = _phoneController.text.trim();

                          // Check if any of the fields are empty
                          if (name.isEmpty || email.isEmpty|| phoneNumber.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
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
                              SnackBar(
                                content: Text('Please enter a valid name (only alphabets and at least 2 characters).'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Phone number validation (must be exactly 10 digits)
                          if (phoneNumber.length != 11 || !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a valid 11-digit phone number.'),
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
                              SnackBar(
                                content: Text('Please enter a valid email address.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // Exit if the email format is invalid
                          }

                          // All validations passed, proceed with registration
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
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
                          child: Text("Delete"),
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
