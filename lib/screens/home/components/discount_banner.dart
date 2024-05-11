import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/providers/Category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  DiscountBanner({
    Key? key,
  }) : super(key: key);

  final items = [
    {
      'headerText': 'A Summer Surpise',
      'bodyText': 'Cashback 20%',
      'color': Color(0xFF4A3298),
    },
    {
      'headerText': 'Dashain Offer',
      'bodyText': 'Buy 1 get 1 FREE',
      'color': Color(0xFF4A3298).withAlpha(180),
    },
    {
      'headerText': 'Chhath Special Xut',
      'bodyText': '50% Cashback',
      'color': Color(0xFF4A3298).withOpacity(0.8),
    },
  ];
  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<CategoryProvider>(context, listen: false).homeCategories;
    return categories.isNotEmpty
        ? CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              height: 200,
              // enlargeCenterPage: true,
              enableInfiniteScroll: true,
              viewportFraction: 1.12,
              aspectRatio: 1.5,
              initialPage: 1,
              autoPlayInterval: Duration(
                seconds: 3,
              ),
              autoPlayCurve: Curves.easeIn,
              autoPlayAnimationDuration: Duration(
                milliseconds: 800,
              ),
            ),
            // items: List.generate(
            //   items.length,
            //   (index) => buildImageWithText(items[index]),
            // ),
            items: List.generate(
              items.length,
              (index) => buildImage(categories[index], items[index]),
            ),
            // items: items
            //     .map(
            //       (element) => buildImage(element),
            //     )
            //     .toList(),
          )
        : Center(
            child: Text(
              "No discount banners available",
              style: Theme.of(context).textTheme.headline4,
            ),
          );
  }

  Widget buildImage(Category category, dynamic map) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(
          10,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(15),
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: MemoryImage(
            category.images[0]!,
          ),
          fit: BoxFit.cover,
        ),
      ),

      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "${map['headerText']}\n"),
            TextSpan(
              text: "${map['bodyText']}",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(24),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageWithText(dynamic map) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(15),
      ),
      decoration: BoxDecoration(
        color: map['color'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "${map['headerText']}\n"),
            TextSpan(
              text: "${map['bodyText']}",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(24),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
