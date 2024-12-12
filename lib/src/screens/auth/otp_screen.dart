import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:jim/src/api/auth.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jim/src/auth/secure_storage.dart';
import 'package:jim/src/screens/auth/login_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Declare the OTP variable at the class level to retain its state
  String otp = '';

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed arguments using Get.arguments
    final Map<String, dynamic> args = Get.arguments;
    // final String fromWhere = args['message'];
    final String name = args['name'];
    final String email = args['email'];
    final String password = args['password'];
    final String phoneNumber = args['phoneNumber'];

    print(name); // Debugging print to ensure arguments are passed correctly

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
                  keyboardType: TextInputType.visiblePassword, // Ensure the numeric keyboard is used
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

                      ByteData byteData = await rootBundle
                          .load('assets/images/welcomePage/welcome_screen.png');
                      Uint8List imageBytes = byteData.buffer.asUint8List();

                      final fcmToken = await StorageService.getFcmToken();

                      // Call the API with the OTP and other user data
                      dynamic response = await registerUser(
                        name: name,
                        email: email,
                        password: password,
                        phoneNumber: phoneNumber,
                        profilePicture: imageBytes,
                        verification: otp, // Pass the OTP value to the API
                        fcmToken: fcmToken,
                        api: '/user/register', // Provide your API base URL
                      );

                      if (response["status"] == "success") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          title: 'Success',
                          desc: 'Account registered successfully',
                          btnOkIcon: Icons.check,
                          btnOkOnPress: () {
                            Get.to(() => const LoginScreen());
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
                          btnOkOnPress: () {
                            // Navigate to the BottomBar screen after the dialog is dismissed
                            //   if (mounted) {
                            Get.to(() => const LoginScreen());
                            // }
                          },
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
                          color: Colors.white,
                          fontSize: 20), // Set the text color to white
                    ),

                  ),
                ),
                const SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      ),
    );
  }
}