import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jim/src/constants/image_strings.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:jim/src/constants/text_strings.dart';
import 'package:jim/src/screens/bottom_bar.dart';
import 'package:jim/src/screens/forgot_pw.dart';
import 'package:jim/src/screens/register_screen.dart';
import 'package:jim/src/screens/all_datas.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_client.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final ApiService apiService= ApiService();
  final storage = FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50,),
                    Text(
                      tLogInMessage,
                      style: GoogleFonts.anton(fontSize: 40),
                    ),
                    Form(
                        child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_outlined),
                                labelText: "Email",
                                hintText: "your_email",
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 30,
                          ),
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
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () => Get.to(()=> const ForgetPassword()),
                                  child: Text(tForgotPw))),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(

                                  onPressed: () async {
                                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                      // Show a Snackbar or some other error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Please fill in all fields.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return; // Exit the onPressed method if fields are empty
                                    }

                                    //TOKEN
                                    try {
                                      String token = await apiService.login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        api: '/user/login', // Provide your API base URL
                                      );
                                      print("token $token");
                                      Get.put(UserController(token: token)); // Store the email in UserController
                                      String token2 = Get.find<UserController>().token;
                                      print("Token from UserController $token2");

                                      if (token == 'failed'){
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.topSlide,
                                          title: 'ERROR',
                                          desc: 'Login not Successful',
                                          btnOkIcon: Icons.check,
                                          btnOkOnPress: () {
                                          },
                                        )..show();
                                      }
                                      else{
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.topSlide,
                                          title: 'Sucess',
                                          desc: 'Login Successful',
                                          btnOkIcon: Icons.check,
                                          btnOkOnPress: () {
                                            Get.to(() =>  BottomBar());
                                          },

                                        )..show();
                                      }
                                      }
                                    catch (e){
                                      print('Error: $e');
                                    }
/***
                                    String email = _emailController.text.trim();
                                    if ('success' == 'success') { // Replace this with the actual success condition
                                      // Navigate to the RegisterScreen if login is successful
                                      Get.put(UserController(email: _emailController.text)); // Store the email in UserController
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.topSlide,
                                        title: 'Sucess',
                                        desc: 'Login Successful',
                                        btnOkIcon: Icons.check,
                                        btnOkOnPress: () {
                                          Get.to(() =>  BottomBar());
                                        },

                                      )..show();
                                    } else {
                                      //this is just for me to easily navigate in UI
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.topSlide,
                                        title: 'ERROR',
                                        desc: 'Login not Successful',
                                        btnOkIcon: Icons.check,
                                        btnOkOnPress: () {
                                        },
                                      )..show();
                                    }

***/


                                    /***
                                    String result = await apiService.login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      api: '/user/login', // Provide your API base URL
                                    );
                                      if (result == 'success') { // Replace this with the actual success condition
                                      // Navigate to the RegisterScreen if login is successful
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.topSlide,
                                          title: 'Success',
                                          desc: 'Login Successful',
                                          btnOkIcon: Icons.check,
                                          btnOkOnPress: () {
                                            Get.to(() =>  BottomBar());
                                          },
                                        )..show();
                                      } else {
                                        //this is just for me to easily navigate in UI
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.topSlide,
                                          title: 'Success',
                                          desc: 'Login Successful',
                                          btnOkIcon: Icons.check,
                                          btnOkOnPress: () {
                                          },
                                        )..show();
                                      }
                                      ***/
                                  },
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(),
                                      backgroundColor: Colors.black),
                                  child: Text(tLogin.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)))),
                        ],
                      ),
                    )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("OR"),
                        SizedBox(height: 10,),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                              icon: Image(image: AssetImage(GoogleImg),width: 20,),
                              onPressed: () async{
                                try{
                                  final controller = Controller(); // Create an instance of Controller
                                  final user = await controller.loginWithGoogle(); // Call the method on the instance
                                  print(user?.email);
                                  print(user?.displayName);
                                  print(user?.phoneNumber);
                                  print(user?.photoURL);
                                  if(user!=null && mounted){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(

                                        builder:(context) => const BottomBar()));
                                  }
                                }
                                on FirebaseAuthException catch (error){
                                  print(error.message);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                          error.message ?? "Something went wrong",
                                        )));
                                }
                                catch (error){
                                  print(error);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                            error.toString(),)));
                                }
                              },
                              label: Text('Sign In With Google', style: TextStyle(color: Colors.black))),
                        ),
                        SizedBox(height: 10,),
                        TextButton(
                          onPressed: () => Get.to(()=> const RegisterScreen()),
                          child: Text.rich(
                            TextSpan(
                              text: "Don't have an Account? ",
                              style: TextStyle(color: Colors.black),
                              children: const[
                                TextSpan(
                                  text: "Signup",
                                  style: TextStyle(color: Colors.blue)
                                )
                              ]
                            )
                          ),),
                      ],
                    )
                  ],
                ))),
      ),
    );
  }
}
