import 'package:flutter/material.dart';

class MyDialog {
  Future<bool> displayDialog(
      BuildContext context, String title, String message) async {
    var toReturn = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            25,
          ),
        ),
        title: Text(title),
        content: Text(message),
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
              toReturn = true;
            },
          ),
        ],
      ),
    );
    return toReturn;
  }
}
