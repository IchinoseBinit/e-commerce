import 'package:e_commerce_app/components/custom_drawer.dart';
import 'package:e_commerce_app/screens/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/components/coustom_bottom_nav_bar.dart';
import 'package:e_commerce_app/enums.dart';
import 'package:e_commerce_app/size_config.dart';

import 'components/body.dart';
import 'package:e_commerce_app/utilities/back_pressed.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //Call this for setting height and width according to device size
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        body: WillPopScope(
          onWillPop: (() =>
              BackPressed().onBackPressed(context).then((value) => value!)),
          child: GestureDetector(
            child: Body(_scaffoldKey),
            onPanUpdate: ((dis) {
              if (dis.delta.dx > 0) {
                //User swiped from left to right

                _scaffoldKey.currentState!.openDrawer();
                // here write the code to open drawer
              } else if (dis.delta.dx < 0) {
                //User swiped from right to left
                Navigator.of(context).pushNamed(NotificationScreen.routeName);
              }
            }),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedMenu: MenuState.home,
        ));
  }
}

//         bottomNavigationBar:
//  Consumer<WishListProvider>(builder: (context, wishData, _) {
//           return CustomBottomNavBar(
//               selectedMenu: MenuState.home, quantity: wishData.wishListCount);
//         }));
