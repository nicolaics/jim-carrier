// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:jim/src/api/bank_detail.dart';
import 'package:jim/src/screens/order/received_order.dart';
import 'package:jim/src/screens/profile/profile_screen.dart';
import '../../api/auth.dart';
import '../../base_class/login_google.dart';
import '../../auth/secure_storage.dart';
import '../auth/login_screen.dart';
import 'home_page.dart';
import '../order/previous_order.dart';
import '../listing/add_listing.dart';

class BottomBar extends StatefulWidget {
  final int initialIndex; // Add a parameter to accept the initial index

  const BottomBar(int i, {super.key, this.initialIndex = 0});

  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(NavigationController());
    controller.setInitialIndex(widget.initialIndex); // Set the initial index
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return WillPopScope(
      onWillPop: () async {
        // Show the AwesomeDialog on back press
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          title: 'Log Out',
          desc: 'Are you sure you want to log out?',
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            // If confirmed, navigate to the login page or close the app
            await logout(api: '/user/logout');
            await StorageService.deleteTokens();
            final controller = Controller();
            await controller.signOut();
            if (mounted) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          },
        ).show();
        return false; // Prevent the back button from navigating
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            selectedIndex: controller.selectedindex.value,
            onDestinationSelected: (index) async {
              if (index == 2) {
                //api call to check whether the bank details are present or not.
                dynamic response=await getBankDetail();
                if(response['status']=='success' && response['message']==null){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.topSlide,
                    title: 'Cannot Add Listing',
                    desc: 'Please Add Bank Details',
                    btnOkIcon: Icons.check,
                    btnOkOnPress: () {},
                  ).show();
                }else {
                  // Navigate to the Add Listing screen separately
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddListingScreen()),
                  );
                }
              } else {
                // Change the selected index for other screens
                controller.selectedindex.value = index;
              }
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.history), label: "History"),
              NavigationDestination(
                  icon: Icon(Icons.add), label: "Add Listing"),
              NavigationDestination(icon: Icon(Icons.card_travel), label: "Orders"),
              NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        ),
        body: Obx(() {
          // Return the screen only for selected indexes other than Add Listing
          if (controller.selectedindex.value != 2) {
            return controller.screens[controller.selectedindex.value];
          }
          return const SizedBox(); // Empty widget for Add Listing
        }),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedindex = 0.obs;

  final screens = [
    const HomeScreen(),
    const PreviousOrderScreen(),
    const AddListingScreen(),
    const ReceivedOrder(),
    const ProfileScreen(),
  ];

  void setInitialIndex(int index) {
    if (index >= 0 && index < screens.length) {
      selectedindex.value = index;
    }
  }
}
