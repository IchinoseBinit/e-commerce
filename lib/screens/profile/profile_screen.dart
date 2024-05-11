import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/screens/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/components/coustom_bottom_nav_bar.dart';
import 'package:e_commerce_app/enums.dart';

import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SizedBox.expand(
        child: GestureDetector(
          child: Body(),
          onPanUpdate: ((dis) {
            if (dis.delta.dx > 0) {
              //User swiped from left to right
              Navigator.pushReplacementNamed(
                  context, NotificationScreen.routeName);
            }
          }),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
