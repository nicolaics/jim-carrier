import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/screens/profile/profile_menu.dart';
import 'package:jim/src/screens/profile/update_profile.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../constants/image_strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  //final UserController userController = Get.find();


  @override
  Widget build(BuildContext context) {
   // final String email = userController.email;
   // print(email);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white, // Set the background color of the Scaffold to white
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            color: Colors.white, // Optional: Set the container's background color to white
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(WelcomeScreenImage)),
                      ),
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
                          LineAwesomeIcons.pencil_alt_solid,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'xyznme',
                  style: GoogleFonts.anton(fontSize: 20),
                ),
                Text(
                  "email",
                  style: GoogleFonts.anton(fontSize: 20),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const UpdateProfileScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Edit Profile",
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog_solid,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                  title: "Billing Details",
                  icon: LineAwesomeIcons.wallet_solid,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                  title: "User Management",
                  icon: LineAwesomeIcons.user_check_solid,
                  onPress: () {},
                ),
                const Divider(),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                  title: "Information",
                  icon: LineAwesomeIcons.info_solid,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                  title: "Log Out",
                  icon: LineAwesomeIcons.sign_out_alt_solid,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {

                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
