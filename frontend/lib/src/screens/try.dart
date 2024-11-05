import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jim/src/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jim/src/screens/login_screen.dart';
import 'package:jim/src/screens/profile_menu.dart';
import 'package:jim/src/screens/update_profile.dart';
import 'package:jim/src/screens/all_datas.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants/image_strings.dart';

class TryScreen extends StatefulWidget {
  const TryScreen({super.key});

  @override
  State<TryScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TryScreen> {
  final TextEditingController _searchController = TextEditingController();
 // final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
  //  final String email = userController.email;
  //  print(email);
    return Scaffold(
      body: SingleChildScrollView(
          child:Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: 35),
                Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 1, // Adjust the width to make the border thicker or thinner
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: AssetImage(WelcomeScreenImage),
                            fit: BoxFit.cover, // Ensures the image fits well within the circle
                          ),
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
                                LineAwesomeIcons.pencil_alt_solid, size: 20.0, color: Colors.black)
                        ),
                      )
                    ]
                ),
                const SizedBox(height: 10),
                Text('xyzname', style: GoogleFonts.anton(fontSize: 20),),
                Text('email', style: GoogleFonts.anton(fontSize: 20),),
                const SizedBox(height: 20),
                SizedBox(width:200,
                  child: ElevatedButton(
                      onPressed: () => Get.to(()=> const UpdateProfileScreen()),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, side: BorderSide.none, shape: const StadiumBorder()),
                      child: Text("Edit Profile", style: TextStyle(color: Colors.black, fontSize: 20))),
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
                SizedBox(height: 10),
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
                  onPress: () async{
                    final controller = Controller();
                    await controller.signOut();
                    if(mounted){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const LoginScreen()));
                    }
                  },
                )
              ],
            ),
          )
      ),
    );
  }
}
