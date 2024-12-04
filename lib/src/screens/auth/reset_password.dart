// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/api/auth.dart';
import 'package:jim/src/auth/secure_storage.dart';
import 'package:jim/src/screens/auth/login_screen.dart';

import '../../constants/sizes.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<ResetPassword> {
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwController2 = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: tDefaultSize * 4),
            Text(
              'Change Password',
              style: GoogleFonts.anton(fontSize: 40),
            ),
            Form(
                child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _pwController,
                    obscureText:
                        !_isPasswordVisible, // Step 3: Use the boolean for visibility
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Enter new password",
                      hintText: "Enter new password",
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
                    height: 30,
                  ),
                  TextFormField(
                    controller: _pwController2,
                    obscureText:
                        !_isPasswordVisible, // Step 3: Use the boolean for visibility
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Re-enter new password",
                      hintText: "Enter new password again",
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
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        //for UI making

                        String pw1 = _pwController.text.trim();
                        String pw2 = _pwController2.text.trim();
                        String email = await StorageService.getTempEmail();
                        await StorageService.deleteTempEmail();

                        // Check if any of the fields are empty
                        if (pw1.isEmpty || pw2.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (pw1.length <= 5 && pw2.length <= 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Password must be more than 5 characters.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return; // Exit if the password length is invalid
                        } else if (pw1 != pw2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please re-enter the passwords.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          dynamic result = await resetPassword(
                              newPassword: pw2,
                              api: '/user/reset-password',
                              email: email);

                          if (result['status'] == 'success') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.topSlide,
                              title: 'Success',
                              desc: 'Password Reset',
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
                              title: 'ERROR',
                              desc: 'Password Reset Failed',
                              btnOkIcon: Icons.check,
                              btnOkOnPress: () {},
                            ).show();
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        'CHANGE PASSWORD',
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
    ));
  }
}
