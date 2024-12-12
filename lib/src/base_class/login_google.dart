import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jim/src/auth/secure_storage.dart';

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
    
    final fcmToken = await StorageService.getFcmToken();

    Map<String, dynamic> response = {
      "idToken": googleAuth?.idToken,
      "serverAuthCode": googleAccount?.serverAuthCode,
      "fcmToken": fcmToken,
      "name": userCredential.user?.displayName,
      "profilePictureUrl": userCredential.user?.photoURL,
      "phoneNumber": userCredential.user?.phoneNumber,
    };

    return response;
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

}