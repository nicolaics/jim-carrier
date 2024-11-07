
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  final String token;
  UserController({required this.token});
}

class Controller extends GetxController {

  Future<User?> loginWithGoogle() async{
    final googleAccount= await GoogleSignIn().signIn();

    final googleAuth= await googleAccount?.authentication;

    //signing in with firebase auth
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print("Credential $credential" );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    print("usercredential:  $userCredential" );
    return userCredential.user;
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

}