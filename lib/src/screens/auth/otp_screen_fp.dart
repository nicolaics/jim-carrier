// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:jim/src/api/auth.dart';
import 'package:jim/src/auth/secure_storage.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jim/src/screens/auth/reset_password.dart';

class OtpScreen2 extends StatefulWidget {
  const OtpScreen2({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen2> {
  // Declare the OTP variable at the class level to retain its state
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: tDefaultSize),
                Text(
                  'CO\nDE',
                  style: GoogleFonts.montserrat(
                      fontSize: 80, fontWeight: FontWeight.bold),
                ),
                Text(
                  'VERIFICATION',
                  style: GoogleFonts.anton(fontSize: 30),
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter the verification code sent to your\nemail.',
                  style: GoogleFonts.cormorant(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // OtpTextField to capture OTP input
                OtpTextField(
                  mainAxisAlignment: MainAxisAlignment.center,
                  numberOfFields: 6,
                  fillColor: Colors.black.withOpacity(0.1),
                  filled: true,
                  onSubmit: (code) {
                    setState(() {
                      otp =
                          code; // Update the otp variable with the submitted code
                    });
                    print(
                        "OTP is: => $otp"); // Debugging print to verify OTP value
                  },
                ),
                const SizedBox(height: 20),

                // Elevated Button to verify OTP
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check if the OTP is empty
                      if (otp.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please enter the OTP.'),
                          backgroundColor: Colors.red,
                        ));
                        return; // Exit if OTP is empty
                      }

                      // Debugging print to check OTP value before API call
                      print("Before API call - OTP: $otp");

                      String email = await StorageService.getTempEmail();

                      dynamic response = await verifyVerificationCode(
                          email: email,
                          verificationCode: otp,
                          api: "/user/verify-verification");

                      if (response["status"] == "success") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          title: 'Success',
                          desc: 'Directing to next page',
                          btnOkIcon: Icons.check,
                          btnOkOnPress: () {
                            Get.to(() => const ResetPassword());
                          },
                        ).show();
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
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor:
                          Colors.black, // Set the background color to black
                    ),
                    child: const Text(
                      "Verify Code",
                      style: TextStyle(
                          color: Colors.white), // Set the text color to white
                    ),
                  ),
                ),
                const SizedBox(
                  height: 1000,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
