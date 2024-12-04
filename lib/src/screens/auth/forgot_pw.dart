// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jim/src/screens/auth/otp_screen_fp.dart';

import '../../api/auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  @override
  _ForgetPassword createState() => _ForgetPassword();
}
class _ForgetPassword extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: tDefaultSize * 4),
            Text(
              'Forgot Password?',
              style: GoogleFonts.anton(fontSize: 40),
            ),
            Text('Please enter the email you use to sign in with.',
                style: GoogleFonts.cormorant(
                    fontSize: 15, color: Colors.black),
                textAlign: TextAlign.center),
            Form(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: "Email",
                            hintText: "your@gmail.com",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Get the trimmed email text
                            String email = _emailController.text.trim();

                            // Debug to ensure email is being read correctly
                            debugPrint("Email entered: $email");

                            // Check if the email text box is empty
                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your email.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return; // Exit if the email is empty
                            }

                            // Email format validation using regex
                            final RegExp emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            );

                            if (!emailRegex.hasMatch(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid email address.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return; // Exit if the email format is invalid
                            }

                            // Call the API to request verification code
                            dynamic result = await forgotPassword(
                              email: email,
                              api: '/user/send-verification',
                            );

                            // Proceed only if the API call is successful
                            if (result['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Verification code sent successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Get.to(() => const OtpScreen2());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to send code. Please try again.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },


                          style: OutlinedButton.styleFrom(
                            shape: const RoundedRectangleBorder(),
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'SEND CODE',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      )


                    ],
                  ),
                )),
          ],
        ),
      ),
      )
    );
  }
}