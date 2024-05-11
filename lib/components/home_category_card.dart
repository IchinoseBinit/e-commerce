import 'package:e_commerce_app/providers/Category.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class CategoryHomeCard extends StatelessWidget {
  const CategoryHomeCard({
    this.width,
    required this.category,
  });

  final double? width;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        width: getProportionateScreenWidth(width ?? 230),
        height: SizeConfig.orientation == Orientation.landscape
            ? SizeConfig.screenHeight! * 0.9
            : getProportionateScreenHeight(140),
        child: GestureDetector(
          onTap: () {
            // List<dynamic> args = [
            //   ProductDetailsArguments(product: product),
            //   productkey
            // ];

            // Navigator.pushNamed(
            //   context,
            //   DetailsScreen.routeName,
            //   arguments: args,
            // );
          },
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: SizeConfig.orientation == Orientation.landscape
                    ? SizeConfig.screenHeight! * 0.28
                    : SizeConfig.screenHeight! * 0.12,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color == Colors.white
                        ? Colors.grey.shade100
                        : Colors.black,
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: SizeConfig.orientation == Orientation.landscape
                      ? SizeConfig.screenHeight! * 0.28
                      : SizeConfig.screenHeight! * 0.13,
                  width: double.infinity * 0.1,
                  child: category.images.isEmpty
                      ? Text("Image HEre")
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                          child: Image.memory(
                            category.images[0]!,
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
              ),
              Container(
                height: SizeConfig.orientation == Orientation.landscape
                    ? SizeConfig.screenHeight! * 0.12
                    : getProportionateScreenHeight(25),
                margin: EdgeInsets.only(
                  top: getProportionateScreenHeight(
                    1,
                  ),
                ),
                child: Text(
                  " ${category.name}",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(
                      13,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          // ),
        ),
      ),
    );
  }
}
