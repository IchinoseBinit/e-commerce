import 'package:e_commerce_app/utilities/log_out.dart';
import 'package:flutter/material.dart';

class LogoutDialog {
  Future<bool?> onLogoutPressed(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            25,
          ),
        ),
        title: Text('Logout'),
        content: Text('Are you sure you want to Logout?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              Navigator.pop(context, true);
              // exit(0);
              await LogOut().logout(context);
            },
          ),
        ],
      ),
    );
  }
}
