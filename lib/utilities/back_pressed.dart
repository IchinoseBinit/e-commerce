import 'dart:io';

import 'package:e_commerce_app/screens/splash/splash_loading.dart';
import 'package:flutter/material.dart';

class BackPressed {
  Future<bool?> onBackPressed(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            25,
          ),
        ),
        title: Text('Exit App'),
        content: Text('Do you really want to exit the app?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.pop(context, true);
              exit(0);
            },
          ),
        ],
      ),
    );
  }

  onBackPressedInSignInScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SplashLoadingScreen.routeName);
  }
}
