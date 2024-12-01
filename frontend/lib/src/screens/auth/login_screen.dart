// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/api/auth.dart';
import 'package:jim/src/constants/image_strings.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:jim/src/constants/text_strings.dart';
import 'package:jim/src/flutter_storage.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';
import 'package:jim/src/screens/auth/forgot_pw.dart';
import 'package:jim/src/screens/auth/register_screen.dart';
import 'package:jim/src/base_class/login_google.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_service.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isPasswordVisible = false;

  final ApiService apiService = ApiService();

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

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
                      tLogInMessage,
                      style: GoogleFonts.anton(fontSize: 40),
                    ),
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
                                hintText: "your_email",
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
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () =>
                                      Get.to(() => const ForgetPassword()),
                                  child: const Text(tForgotPw))),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      // Show a Snackbar or some other error message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please fill in all fields.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return; // Exit the onPressed method if fields are empty
                                    }
                                    //TOKEN
                                    try {
                                      final fcmToken = await StorageService.getFcmToken();

                                      String token = await login(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                        fcmToken: fcmToken,
                                        api:
                                            '/user/login', // Provide your API base URL
                                      );
                                      if(token=="failed"){
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.topSlide,
                                          title: 'ERROR',
                                          desc: 'Login not Successful',
                                          btnOkIcon: Icons.check,
                                          btnOkOnPress: () {
                                          },
                                        ).show();
                                      }
                                      else{
                                        print("token $token");
                                        StorageService.storeToken(token);
                                        print("hahahahaha");
                                        print(StorageService.getToken());
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.topSlide,
                                          title: 'Sucess',
                                          desc: 'Login Successful',
                                          btnOkIcon: Icons.check,
                                          btnOkOnPress: () {
                                            Get.to(() => const BottomBar());
                                          },
                                        ).show();
                                      }

                                    } catch (e) {
                                      print('Error: $e');

                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(),
                                      backgroundColor: Colors.black),
                                  child: Text(tLogin.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20)))),
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
                              onPressed: () async {
                                try {
                                  final controller =
                                      Controller(); // Create an instance of Controller
                                  final user = await controller
                                      .loginWithGoogle(); // Call the method on the instance

                                  dynamic response;

                                  response = await loginWithGoogle(
                                    userInfo: user,
                                    api:
                                        '/user/login/google', // Provide your API base URL
                                  );
                                  
                                  if (response == "toRegist") {
                                    if (user['phoneNumber'] == null) {
                                      // Display the bottom sheet to collect phone number
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true, // Ensure the sheet takes minimal space
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                              top: 16.0,
                                              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Adjust for keyboard
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min, // Ensures the column takes the minimal space
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Please enter your phone number",
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  TextField(
                                                    controller: _phoneController,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Phone Number',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                    keyboardType: TextInputType.phone,
                                                    autofocus: true, // Focus on this field as soon as the bottom sheet appears
                                                  ),
                                                  const SizedBox(height: 20),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      final phoneNumber = _phoneController.text;

                                                      if (phoneNumber.isNotEmpty) {
                                                        print("Phone number entered: $phoneNumber");

                                                        // Safe navigation to pop the bottom sheet
                                                        if (mounted) {
                                                          Navigator.pop(context); // Close the bottom sheet if widget is still mounted
                                                        }

                                                        user['phoneNumber'] = phoneNumber; // Update user data

                                                        // Proceed with registration
                                                        response = await registerWithGoogle(
                                                          userInfo: user,
                                                          api: '/user/register/google', // Provide your API base URL
                                                        );

                                                        print("Registration Response: $response");

                                                        // Store token after registration
                                                        await StorageService.storeToken(response);

                                                        // Only show dialogs if widget is still mounted
                                                       // if (mounted) {
                                                          if (response == 'failed') {
                                                            // Handle registration failure
                                                            AwesomeDialog(
                                                              context: context,
                                                              dialogType: DialogType.error,
                                                              animType: AnimType.topSlide,
                                                              title: 'ERROR',
                                                              desc: 'Login not Successful',
                                                              btnOkIcon: Icons.check,
                                                              btnOkOnPress: () {},
                                                            ).show();
                                                          } else {
                                                            // Handle registration success
                                                            print("jere");
                                                            Get.to(() => const BottomBar());
                                                            AwesomeDialog(
                                                              context: context,
                                                              dialogType: DialogType.success,
                                                              animType: AnimType.topSlide,
                                                              title: 'Success',
                                                              desc: 'Login Successful',
                                                              btnOkIcon: Icons.check,
                                                              btnOkOnPress: () {
                                                                // Navigate to the BottomBar screen after the dialog is dismissed
                                                             //   if (mounted) {
                                                                  Get.to(() => const BottomBar());
                                                               // }
                                                              },
                                                            ).show();
                                                          }
                                                        }
                                                  //    } else {
                                                    //    print("Phone number is empty.");
                                                      //}
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      minimumSize: const Size(200, 50), // Set button size
                                                    ),
                                                    child: const Text("Submit"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }





                                } on FirebaseAuthException catch (error) {
                                  print(error.message);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    error.message ?? "Something went wrong",
                                  )));
                                } catch (error) {
                                  print(error);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    error.toString(),
                                  )));
                                }
                              },
                              label: const Text('Sign In With Google',
                                  style: TextStyle(color: Colors.black))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () => Get.to(() => const RegisterScreen()),
                          child: const Text.rich(TextSpan(
                              text: "Don't have an Account? ",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: "Signup",
                                    style: TextStyle(color: Colors.blue))
                              ])),
                        ),
                      ],
                    )
                  ],
                ))),
      ),
    );
  }
}
