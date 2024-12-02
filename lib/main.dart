import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jim/firebase_options.dart';
import 'package:jim/src/api/api_service.dart';
import 'package:jim/src/api/auth.dart';
import 'package:jim/src/base_class/firebase_notif.dart';
import 'package:jim/src/flutter_storage.dart';
import 'package:jim/src/screens/home/bottom_bar.dart';
import 'package:jim/src/screens/welcome.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotification().initNotifications();

  setupInterceptors();
  
  String refreshToken = await StorageService.getRefreshToken();

  String next = "welcome";

  try {
    final response =
        await autoLogin(refreshToken: refreshToken, api: "/user/auto-login");

    if (response["status"] == "success") {
      next = "home";
      await StorageService.storeAccessToken(response["message"]["access_token"]);
      await StorageService.storeRefreshToken(response["message"]["refresh_token"]);
    }
  } catch (e) {
    print("ERROR HERE: $e");
  }

  runApp(MyApp(nextScreen: next));
}

class MyApp extends StatelessWidget {
  final String nextScreen;

  const MyApp({super.key, required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    if (nextScreen == "home") {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomBar(0),
      );
    } else {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
      );
    }
  }
}
