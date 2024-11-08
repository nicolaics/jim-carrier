
// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  final String token;
  UserController({required this.token});
}

class Controller extends GetxController {

  Future<dynamic> loginWithGoogle() async{
    final googleAccount = await GoogleSignIn().signIn();
    print("googleAccount: ${googleAccount?.serverAuthCode}");

    final googleAuth = await googleAccount?.authentication;
    print("googleAuth: ${googleAuth?.idToken}");
    
    // final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);

    // String? token = await FirebaseMessaging.instance.getToken();
    // print("fcmId Token: $token");

    // signing in with firebase auth
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print("Credential $credential" );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    // print("usercredential:  $userCredential");
    print("usercredential user:  ${userCredential.user}");
    
    // return userCredential.user;

    Map<String, dynamic> response = {
      "idToken": googleAuth?.idToken,
      "serverAuthCode": googleAccount?.serverAuthCode,
      "fcmToken": "1234",
      "name": userCredential.user?.displayName,
      "photoUrl": userCredential.user?.photoURL,
      "phoneNumber": userCredential.user?.phoneNumber,
    };

    return response;
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

}