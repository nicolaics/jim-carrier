import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jim/src/screens/login_screen.dart';
import 'package:jim/src/screens/password_change.dart';
import 'base_client.dart';

class OtpScreen2 extends StatefulWidget {
  const OtpScreen2({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen2> {
  final ApiService apiService = ApiService();

  // Declare the OTP variable at the class level to retain its state
  String otp = '';

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: tDefaultSize),
                Text(
                  'CO\nDE',
                  style: GoogleFonts.montserrat(fontSize: 80, fontWeight: FontWeight.bold),
                ),
                Text(
                  'VERIFICATION',
                  style: GoogleFonts.anton(fontSize: 30),
                ),
                SizedBox(height: 20),
                Text(
                  'Enter the verification code sent to your\nemail.',
                  style: GoogleFonts.cormorant(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // OtpTextField to capture OTP input
                OtpTextField(
                  mainAxisAlignment: MainAxisAlignment.center,
                  numberOfFields: 6,
                  fillColor: Colors.black.withOpacity(0.1),
                  filled: true,
                  onSubmit: (code) {
                    setState(() {
                      otp = code; // Update the otp variable with the submitted code
                    });
                    print("OTP is: => $otp"); // Debugging print to verify OTP value
                  },
                ),
                SizedBox(height: 20),

                // Elevated Button to verify OTP
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      //For UI Testing
                      Get.to(()=> const PasswordChange());
                      /***
                      // Check if the OTP is empty
                      if (otp.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please enter the OTP.'),
                          backgroundColor: Colors.red,
                        ));
                        return; // Exit if OTP is empty
                      }
                      // Debugging print to check OTP value before API call
                      print("Before API call - OTP: $otp");
                        Get.to(()=> const LoginScreen());
                        ***/
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Set the background color to black
                    ),
                    child: Text(
                      "VERIFY",
                      style: TextStyle(color: Colors.white), // Set the text color to white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
