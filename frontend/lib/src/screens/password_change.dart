import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/screens/login_screen.dart';

import '../constants/sizes.dart';
import 'base_client.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {

  @override
  final ApiService apiService = ApiService();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwController2 = TextEditingController();
  bool _isPasswordVisible = false;

  Widget build(BuildContext context){
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: tDefaultSize * 4),
                Text(
                  'Change Password',
                  style: GoogleFonts.anton(fontSize: 40),
                ),
                Form(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _pwController,
                            obscureText: !_isPasswordVisible, // Step 3: Use the boolean for visibility
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: "Enter new password",
                              hintText: "Enter new password",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                // Step 4: Toggle visibility and change the icon
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility // Show icon when password is visible
                                      : Icons.visibility_off, // Hide icon when password is hidden
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _pwController2,
                            obscureText: !_isPasswordVisible, // Step 3: Use the boolean for visibility
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: "Re-enter new password",
                              hintText: "Enter new password again",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                // Step 4: Toggle visibility and change the icon
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility // Show icon when password is visible
                                      : Icons.visibility_off, // Hide icon when password is hidden
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async{
                                //for UI making

                                String pw1 = _pwController.text.trim();
                                String pw2 = _pwController2.text.trim();

                                // Check if any of the fields are empty
                                if (pw1.isEmpty || pw2.isEmpty ) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please fill in all fields.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                else if (pw1.length <= 5 && pw2.length <= 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Password must be more than 5 characters.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return; // Exit if the password length is invalid
                                }
                                else if(pw1 != pw2){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please re-enter the passwords.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                else{
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.topSlide,
                                      title: 'Success',
                                      desc: 'Password Changed Successfully',
                                      btnOkIcon: Icons.check,
                                      btnOkOnPress: () {
                                        Get.to(() => const LoginScreen());
                                      },
                                )..show();

                                }

                                //  Get.to(() => const LoginScreen());
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
                                shape: RoundedRectangleBorder(),
                                backgroundColor: Colors.black,
                              ),
                              child: Text(
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
        )
    );
  }
}