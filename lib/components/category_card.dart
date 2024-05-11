import 'package:e_commerce_app/providers/Category.dart';
import 'package:e_commerce_app/screens/display_products/display.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    this.width,
    required this.category,
    this.onPress,
    this.toShowBottom = false,
  }) : super(key: key);

  final Category category;
  final double? width;
  final Function? onPress;
  final bool toShowBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (onPress != null) {
                onPress!();
              } else {
                Navigator.of(context)
                    .pushNamed(DisplayScreen.routeName, arguments: category);
              }
            },
            child: Container(
              decoration: category.selected!
                  ? BoxDecoration(
                      border: Border.all(color: Theme.of(context).buttonColor),
                      borderRadius: BorderRadius.circular(18),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border:
                          Border.all(color: Theme.of(context).cardTheme.color!),
                    ),
              width: getProportionateScreenWidth(width ?? 162),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  children: [
                    Image.memory(
                      category.images[0]!,
                      width: getProportionateScreenWidth(302),
                      fit: BoxFit.fill,
                    ),
                    Text(
                      category.name!,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: category.selected!
                              ? Theme.of(context).buttonColor
                              : Theme.of(context).textTheme.headline4!.color),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
