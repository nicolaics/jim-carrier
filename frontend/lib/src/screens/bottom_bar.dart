
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jim/src/screens/try.dart';
import 'home_page.dart';
import 'previous_order.dart';
import 'chat_ui.dart';
import 'add_listing.dart';

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
        ()=> NavigationBar(

          elevation: 0,
            selectedIndex: controller.selectedindex.value,
            onDestinationSelected: (index) => controller.selectedindex.value=index,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(icon: Icon(Icons.document_scanner), label: "Previous"),
              NavigationDestination(icon: Icon(Icons.add), label: "Add Listing"),
              NavigationDestination(icon: Icon(Icons.chat), label: "Chat Bot"),
              NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ]
        ),
      ),
      body: Obx(()=>controller.screens[controller.selectedindex.value]),
    );
  }
}


class NavigationController extends GetxController{
  final Rx<int> selectedindex=0.obs;

  final screens=[const HomeScreen(), const Previous_Order_Screen(), const AddListingScreen(), const ChatScreen(), const TryScreen()];
}