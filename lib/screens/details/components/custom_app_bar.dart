import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../size_config.dart';

class CustomAppBar extends PreferredSize {
  final double? rating;

  CustomAppBar({required this.rating})
      : super(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child: AppBar());

  @override
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Theme.of(context).buttonColor.withOpacity(0.8),
              Theme.of(context).buttonColor.withOpacity(0.6)
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: Row(
          children: [
            SizedBox(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Container(
                  // height: getProportionateScreenHeight(90),
                  width: getProportionateScreenWidth(50),
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: EdgeInsets.only(left: getProportionateScreenWidth(9)),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    "${rating!.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    "assets/icons/Star Icon.svg",
                    color: Theme.of(context).buttonColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
