import 'package:e_commerce_app/providers/HomePage.dart';
import 'package:e_commerce_app/screens/home/components/home_page_products.dart';
import 'package:e_commerce_app/screens/home/components/new_products.dart';
import 'package:e_commerce_app/screens/home/components/products.dart';
import 'package:e_commerce_app/screens/home/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
// import 'special_categories.dart';

class Body extends StatelessWidget {
  Body(this.scaffKey);

  final GlobalKey<ScaffoldState> scaffKey;

  @override
  Widget build(BuildContext context) {
    Future future = Provider.of<HomePageProvider>(context, listen: false)
        .fetchHomeProducts(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(20)),

            // SpecialCategories(),

            FutureBuilder(
              future: future,
              builder: (context, homePageData) {
                if (homePageData.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Column(
                  children: [
                    Categories(),
                    DiscountBanner(),
                    SizedBox(height: getProportionateScreenWidth(10)),

                    // To Add
                    // PersonalizedProducts
                    // Recommended Products
                    // SuggestedProducts
                    //
                    HomePageProducts(scaffKey),
                    SizedBox(height: getProportionateScreenWidth(30)),
                    NewProducts(scaffKey),
                    SizedBox(height: getProportionateScreenWidth(30)),

                    // To Add
                    // GetCategoryFeaturedProducts
                    // GetHomePageBestSeller
                    // GetHomePageManufacturers
                    // ManufacturerFeaturedProducts

                    // News(),

                    // SizedBox(height: getProportionateScreenWidth(30)),
                    // Blog(),
                    // SizedBox(height: getProportionateScreenWidth(30)),

                    // To Add
                    // HomePagePolls

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: SectionTitle(
                        title: "Products",
                        press: () {},
                        toSeeMore: false,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ProductList(scaffKey),
                    SizedBox(height: getProportionateScreenHeight(20)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
