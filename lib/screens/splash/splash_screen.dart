import 'package:flutter/material.dart';
import 'package:e_commerce_app/screens/splash/components/body.dart';
import 'package:e_commerce_app/size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) { 
    SizeConfig().init(context);
    // You have to call it on your starting screen
    return Scaffold(
      body: Body(),
    );
  }
}
