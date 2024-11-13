import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/src/screens/try.dart';
import 'home_page.dart';
import '../order/previous_order.dart';
import '../chat/chat_ui.dart';
import '../listing/add_listing.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          elevation: 0,
          selectedIndex: controller.selectedindex.value,
          onDestinationSelected: (index) => controller.selectedindex.value = index,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.document_scanner), label: "Previous"),
            NavigationDestination(icon: Icon(Icons.add), label: "Add Listing"),
            NavigationDestination(icon: Icon(Icons.chat), label: "Chat Bot"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedindex.value]),
    );
  }
}

class NavigationController extends GetxController {
  // Set the initial index to 0 to show the HomeScreen first
  final Rx<int> selectedindex = 0.obs;

  // Define the list of screens
  final screens = [
    const HomeScreen(),
    const PreviousOrderScreen(),
    const AddListingScreen(),
    const ChatScreen(),
    const TryScreen(),
  ];
}
