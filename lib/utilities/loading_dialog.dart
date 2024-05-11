import 'package:flutter/material.dart';

class LoadingDialog {
  static displayLoadingDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              25,
            ),
          ),
          height: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Center(
                  child: Text(message,
                      style: Theme.of(context).textTheme.headline4)),
            ],
          ),
        );
      },
    );
  }
}
