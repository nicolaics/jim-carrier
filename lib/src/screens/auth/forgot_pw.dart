// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jim/src/screens/auth/otp_screen_fp.dart';
import '../../api/api_service.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  @override
  _ForgetPassword createState() => _ForgetPassword();
}
class _ForgetPassword extends State<ForgetPassword> {
  final ApiService apiService = ApiService();
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
                          onPressed: () async{
                            //for UI making
                            Get.to(() => const OtpScreen2());
/***
                            await apiService.otpCode(
                              email: _emailController.text,
                              api: '/user/send-verification', // Provide your API base URL
                            );

                            // Check if the email text box is empty
                            if (_emailController.text.isEmpty) {
                              // Show a Snackbar for empty email
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter your email.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return; // Exit if the email is empty
                            }

                            // Email format validation using regex
                            String email = _emailController.text;
                            final RegExp emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            );

                            if (!emailRegex.hasMatch(email)) {
                              // Show a Snackbar for invalid email format
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter a valid email address.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return; // Exit if the email format is invalid
                            }

                            String result= await apiService.forgotPw(
                              email: email,
                              api: '/user/send-verification', // Provide your API base URL
                            );
                            // Proceed to the OtpScreen if the email field is filled and valid
                            if(result == 'success'){
                              print("Got Code");
                            }
                            else{
                              print("Failed getting code");
                            }
                            Get.to(() => const OtpScreen2()); ***/
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