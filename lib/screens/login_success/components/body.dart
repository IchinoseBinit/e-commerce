import 'package:flutter/material.dart';
import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight! * 0.08),
          Image.asset(
            "assets/images/success.png",
            // color: Theme.of(context).buttonColor,
            height: MediaQuery.of(context).size.width > 460
                ? SizeConfig.screenHeight! * 0.2
                : SizeConfig.screenHeight! * 0.5, //40%
            fit: BoxFit.contain,
            width: double.infinity,
          ),
          // SizedBox(height: SizeConfig.screenHeight * 0.08),
          Text(
            "Login Success",
            style: TextStyle(
              fontSize: getProportionateScreenHeight(30),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          SizedBox(
            width: SizeConfig.screenWidth * 0.5,
            height: SizeConfig.screenHeight! * 0.08,
            child: DefaultButton(
              text: "Let's Shop",
              icon: Icons.shopping_bag_outlined,
              press: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
