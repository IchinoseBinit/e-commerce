import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/screens/sign_up/sign_up_screen.dart';

import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don’t have an account? ",
              style: TextStyle(fontSize: getProportionateScreenWidth(16)),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    color: Theme.of(context).buttonColor),
              ),
            ),
          ],
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "or ",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
                child: Text(
                  "Login Later",
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      color: Theme.of(context).buttonColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
