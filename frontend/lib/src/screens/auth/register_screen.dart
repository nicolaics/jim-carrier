// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/constants/image_strings.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:jim/src/constants/text_strings.dart';
import 'package:jim/src/screens/auth/otp_screen.dart';
import '../../api/api_service.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /*
  void _submitForm() {
    // Get the values from the controllers
    String fullName = _nameController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneController.text;
    String pw = _passwordController.text;


    // Do something with the values (e.g., validation, send to API)
    print('Full Name: $fullName');
    print('Email: $email');
    print('Phone Number: $phoneNumber');
    print('Phone Number: $pw');
  }
  */

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Let's get \nStarted",
                      style: GoogleFonts.anton(fontSize: 40),
                    ),
                    Form(
                        child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_outlined),
                                labelText: "Full Name",
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.numbers_outlined),
                                labelText: "Phone Number",
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                labelText: "Email",
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText:
                                !_isPasswordVisible, // Step 3: Use the boolean for visibility
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: "Password",
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                // Step 4: Toggle visibility and change the icon
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons
                                          .visibility // Show icon when password is visible
                                      : Icons
                                          .visibility_off, // Hide icon when password is hidden
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          /***
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                      onPressed: () => Get.to(()=> const ForgetPassword()), child: Text(tForgotPw))),***/
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Retrieve values from text controllers
                                String name = _nameController.text.trim();
                                String email = _emailController.text.trim();
                                String password =
                                    _passwordController.text.trim();
                                String phoneNumber =
                                    _phoneController.text.trim();

                                // Check if any of the fields are empty
                                if (name.isEmpty ||
                                    email.isEmpty ||
                                    password.isEmpty ||
                                    phoneNumber.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please fill in all fields.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return; // Exit if any field is empty
                                }

                                // Name validation: Check length and ensure only alphabets are used
                                final RegExp nameRegex =
                                    RegExp(r'^[a-zA-Z ]+$');
                                if (name.length < 2 ||
                                    !nameRegex.hasMatch(name)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter a valid name (only alphabets and at least 2 characters).'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
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
                                      content: Text(
                                          'Please enter a valid email address.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return; // Exit if the email format is invalid
                                }

                                if (password.length <= 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Password must be more than 5 characters.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return; // Exit if the password length is invalid
                                }
                                await apiService.otpCode(
                                  email: email,
                                  api:
                                      '/user/send-verification', // Provide your API base URL
                                );
                                Get.to(() => const OtpScreen(), arguments: {
                                  'message': 'register_verification',
                                  'name': name,
                                  'email': email,
                                  'password': password,
                                  'phoneNumber': phoneNumber,
                                });

                                // All validations passed, proceed with registration
                              },
                              style: OutlinedButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                backgroundColor: Colors.black,
                              ),
                              child: Text(
                                tsignup.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("OR"),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                              icon: const Image(
                                image: AssetImage(GoogleImg),
                                width: 20,
                              ),
                              onPressed: () {},
                              label: const Text('Sign In With Google',
                                  style: TextStyle(color: Colors.black))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  ],
                ))),
      ),
    );
  }
}
