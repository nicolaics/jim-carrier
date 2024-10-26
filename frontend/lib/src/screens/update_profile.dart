import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../constants/image_strings.dart';
import '../constants/sizes.dart';
import 'base_client.dart';



class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}
class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                Stack(
                children: [
                SizedBox(
                width: 120, height: 120,
                  child: ClipRRect(borderRadius:BorderRadius.circular(100),child: Image(image: AssetImage(WelcomeScreenImage),)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.yellow,
                      ),
                      child: const Icon(
                          LineAwesomeIcons.camera_retro_solid, size: 20.0, color: Colors.black)
                  ),
                )
                ],
                ),
                const SizedBox(height: 50),
                Form(child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(prefixIcon: Icon(Icons.person_outline_rounded),
                              labelText: "Full Name",
                              border: OutlineInputBorder()),
                        ),
                    SizedBox(height: 30,),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(prefixIcon: Icon(Icons.email_outlined),
                          labelText: "Email",
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(prefixIcon: Icon(Icons.numbers),
                          labelText: "Phone Number",
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, // Step 3: Use the boolean for visibility
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
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
                    SizedBox(height: 30,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Retrieve values from text controllers
                          String name = _nameController.text.trim();
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String phoneNumber = _phoneController.text.trim();

                          // Check if any of the fields are empty
                          if (name.isEmpty || email.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please fill in all fields.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // Exit if any field is empty
                          }

                          // Name validation: Check length and ensure only alphabets are used
                          final RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
                          if (name.length < 2 || !nameRegex.hasMatch(name)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a valid name (only alphabets and at least 2 characters).'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Phone number validation (must be exactly 10 digits)
                          if (phoneNumber.length != 11 || !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a valid 11-digit phone number.'),
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
                              SnackBar(
                                content: Text('Please enter a valid email address.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // Exit if the email format is invalid
                          }

                          if (password.length <= 5) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Password must be more than 5 characters.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // Exit if the password length is invalid
                          }
                          /***
                          await apiService.otpCode(
                            email: email,
                            api: '/user/send-verification', // Provide your API base URL
                          );
                          Get.to(() => const OtpScreen(), arguments: {
                            'message': 'register_verification',
                            'name': name,
                            'email': email,
                            'password': password,
                            'phoneNumber': phoneNumber,
                          });***/

                          // All validations passed, proceed with registration


                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(TextSpan(
                          text: "Joined at October 19,2024"
                        )
                        ),
                        ElevatedButton(
                          onPressed: (){},

                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.1),
                            elevation: 0,
                          foregroundColor: Colors.red,
                          shape: const StadiumBorder(),
                          side: BorderSide.none),
                          child: Text("Delete"),
                        )
                      ],

                    )
                        ]
                      ),
                    )
                  ],
                ),
    )
      )
    );
  }
}