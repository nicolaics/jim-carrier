import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'home_page.dart';
import 'previous_order.dart';
import 'chat_ui.dart';
import 'profile_screen.dart';
import 'add_listing.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);
  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  int _bottomNavIndex = 0;

  final List<IconData> homeicons = [
    Icons.home,
    Icons.document_scanner,
    Icons.chat,
    Icons.person,
  ];

  // Replace the IndexedStack and directly display the selected page
  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return Previous_Order_Screen();
      case 2:
        return ChatScreen();
      case 3:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ['Home', 'Previous', 'Chat', 'Profile',][_bottomNavIndex],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          const Icon(Icons.notifications, color: Colors.black, size: 30.0),
        ],
      ),
      body: _getSelectedPage(_bottomNavIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: const AddListingScreen(),
              type: PageTransitionType.bottomToTop,
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Colors.red,
        activeColor: Colors.yellow,
        inactiveColor: Colors.black.withOpacity(0.5),
        icons: homeicons,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
