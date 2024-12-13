import 'package:flutter/material.dart';
import 'package:jim/src/api/auth.dart';
import 'package:jim/src/auth/secure_storage.dart';
import 'package:jim/src/constants/image_strings.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:jim/src/constants/text_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/screens/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:jim/src/screens/auth/register_screen.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = true; // Initially, the loading state is true

  @override
  void initState() {
    super.initState();
    autoLoginProcess();
  }

  Future<void> autoLoginProcess() async {
    try {
      setState(() {
        isLoading = true; // Start loading before making the API call
      });

      final response = await autoLogin(api: "/user/login/auto");
      if (response["status"] == "success") {
        await StorageService.storeAccessToken(
            response["message"]["access_token"]);
        setState(() {
          isLoading = false;
        });
        Get.to(() => const BottomBar(0));
      } else {
        print("HERE ELSE");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("ERROR HERE: $e");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(tDefaultSize),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(AppName,
                          style: GoogleFonts.lilitaOne(fontSize: 40),
                          textAlign: TextAlign.center),
                      Image(
                          image: const AssetImage(WelcomeScreenImage),
                          height: height * 0.4),
                      Column(
                        children: [
                          Text(Welcome,
                              style: GoogleFonts.anton(fontSize: 35),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          Text(WelcomeMessage,
                              style: GoogleFonts.pacifico(
                                  fontSize: 20, color: Colors.grey),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () =>
                                    Get.to(() => const LoginScreen()),
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                                child: Text(tLogin.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20))),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () =>
                                    Get.to(() => const RegisterScreen()),
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: Colors.black),
                                child: Text(tSignup.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ));
  }
}
