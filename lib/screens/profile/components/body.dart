import 'package:e_commerce_app/components/profile_pic.dart';
import 'package:e_commerce_app/screens/notifications/notification.dart';
import 'package:e_commerce_app/screens/profile/components/help.dart';
import 'package:e_commerce_app/screens/settings/setting_screen.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app/screens/user_details/user_display.dart';
import 'package:e_commerce_app/utilities/logout_dialog.dart';
import 'package:e_commerce_app/utilities/show_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_menu.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late SharedPreferences sharedPreferences;

  bool _loading = true;
  bool _isLoggedIn = false;

  @override
  initState() {
    getLoginStatus().then((value) {
      if (value) {
        setState(() {
          _isLoggedIn = value;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    });
    super.initState();
  }

  Future<bool> getLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('token')) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isLoggedIn
              ? getLoggedInWidgets(
                  context,
                )
              : getLoggedOutWidget(
                  context,
                ),
    );
  }

  Widget getLoggedInWidgets(BuildContext context) {
    return Column(
      children: <Widget>[
        ProfilePicture(
          isLoggedIn: false,
        ),
        SizedBox(height: 20),
        ProfileMenu(
          text: "My Account",
          icon: "assets/icons/User Icon.svg",
          press: () {
            Navigator.pushNamed(context, UserDisplayScreen.routeName);
          },
        ),
        ProfileMenu(
          text: "Notifications",
          icon: "assets/icons/Bell.svg",
          press: () {
            Navigator.pushNamed(context, NotificationScreen.routeName);
          },
        ),
        ProfileMenu(
          text: "Settings",
          icon: "assets/icons/Settings.svg",
          press: () {
            Navigator.pushNamed(context, SettingScreen.routeName);
          },
        ),
        ProfileMenu(
          text: "Help Center",
          icon: "assets/icons/Question mark.svg",
          press: () {
            Navigator.pushNamed(context, HelpScreen.routeName);
          },
        ),
        ProfileMenu(
          text: "Log Out",
          icon: "assets/icons/Log out.svg",
          press: () async {
            await LogoutDialog().onLogoutPressed(context);
          },
        ),
      ],
    );
  }

  Widget getLoggedOutWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        ProfilePicture(
          isLoggedIn: _isLoggedIn,
        ),
        SizedBox(height: 20),
        ProfileMenu(
          text: "Url",
          icon: "assets/icons/Log out.svg",
          press: () {
            ShowBottomSheet().showBottomModal(context);
          },
        ),
        ProfileMenu(
          text: "Log In",
          icon: "assets/icons/Log out.svg",
          press: () {
            Navigator.of(context).pushNamed(SignInScreen.routeName);
          },
        ),
        ProfileMenu(
          text: "Help Center",
          icon: "assets/icons/Question mark.svg",
          press: () {
            Navigator.pushNamed(context, HelpScreen.routeName);
          },
        ),
      ],
    );
  }
}
