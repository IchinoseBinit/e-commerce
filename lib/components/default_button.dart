import 'package:flutter/material.dart';

import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.icon,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        child: TextButton(
          onPressed: press as void Function()?,
          child: Container(
            height: SizeConfig.orientation == Orientation.landscape
                ? getProportionateScreenHeight(150)
                : getProportionateScreenHeight(56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).buttonColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text!,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(22),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(5),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: getProportionateScreenWidth(22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
