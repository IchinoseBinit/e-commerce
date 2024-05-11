import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Spacer(),
        Text(
          "TOKOTO",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 1),
        Container(
          height: MediaQuery.of(context).size.width > 460
              ? getProportionateScreenHeight(
                  150,
                )
              : getProportionateScreenHeight(265),
          child: Image.asset(
            image!,
            // height: getProportionateScreenHeight(265),
            width: getProportionateScreenWidth(235),
          ),
        ),
      ],
    );
  }
}
