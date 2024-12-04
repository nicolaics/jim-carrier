// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';

import '../../api/auth.dart';
import '../../constants/sizes.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _ChangePasswordInsideState();
}

class _ChangePasswordInsideState extends State<UpdatePassword> {
  final TextEditingController _oldpwController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwController2 = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Update Password',
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
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: tDefaultSize),
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
                        controller: _oldpwController,
                        obscureText:
                            !_isPasswordVisible, // Step 3: Use the boolean for visibility
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: "Enter old password",
                          hintText: "Enter old password",
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
                            String oldpw = _oldpwController.text.trim();
                            String pw1 = _pwController.text.trim();
                            String pw2 = _pwController2.text.trim();

                            // Check if any of the fields are empty
                            if (pw1.isEmpty || pw2.isEmpty || oldpw.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all fields.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (pw1.length <= 5 &&
                                pw2.length <= 5 &&
                                oldpw.length <= 5) {
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
                                  content:
                                      Text('Please re-enter the passwords.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            dynamic result = await updatePassword(
                                oldPassword: oldpw,
                                newPassword: pw2,
                                api: '/user/update-password');
                            if (result['status'] == 'success') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.topSlide,
                                title: 'Success',
                                desc: 'Password Updated',
                                btnOkIcon: Icons.check,
                                btnOkOnPress: () {
                                  // Get.to(() => const ProfileScreen());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomBar(0)),
                                  );
                                },
                              ).show();
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                title: 'ERROR',
                                desc: 'Password Update Failed',
                                btnOkIcon: Icons.check,
                                btnOkOnPress: () {},
                              ).show();
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
