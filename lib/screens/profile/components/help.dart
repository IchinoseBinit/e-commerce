import 'package:e_commerce_app/screens/profile/components/faq_screen.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  static String routeName = "/help";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          "Help",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: FaqScreen(),
    );
  }
}
