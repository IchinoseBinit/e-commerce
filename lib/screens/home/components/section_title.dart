import 'package:flutter/material.dart';

import '../../../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
    this.toSeeMore = true,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;
  final bool toSeeMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
          ),
        ),
        toSeeMore
            ? GestureDetector(
                onTap: press,
                child: Text(
                  "See More",
                  style: TextStyle(color: Color(0xFFBBBBBB)),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
