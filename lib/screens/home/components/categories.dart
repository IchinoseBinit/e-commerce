import 'package:e_commerce_app/components/home_category_card.dart';
import 'package:e_commerce_app/providers/Category.dart';
import 'package:e_commerce_app/screens/category/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class Categories extends StatefulWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future? future;

  @override
  void initState() {
    super.initState();
    future = Provider.of<CategoryProvider>(context, listen: false)
        .fetchHomePageCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Categories",
            press: () {
              Navigator.of(context).pushNamed(CategoryScreen.routeName);
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        FutureBuilder(
          future: future,
          builder: (context, categorySnapshot) {
            if (categorySnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Consumer<CategoryProvider>(
              builder: (context, categoryData, _) {
                return categoryData.homeCategories.isNotEmpty
                    ? Container(
                        height: SizeConfig.orientation == Orientation.landscape
                            ? getProportionateScreenHeight(
                                350,
                              )
                            : getProportionateScreenHeight(
                                135,
                              ),
                        child: ListView.builder(
                          addAutomaticKeepAlives: true,
                          shrinkWrap: true,
                          itemCount: categoryData.homeCategories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(
                                  5,
                                ),
                              ),
                              child: CategoryHomeCard(
                                category: categoryData.homeCategories[index],
                                width: 140,
                              ),
                            );
                            // return CategoryCard(
                            //   width: 120,
                            //   key: Key(categoryData.homeCategories[index].id),
                            //   category: categoryData.homeCategories[index],
                            // );
                          },
                        ),
                      )
                    : Center(
                        child: Text("No Categories to display"),
                      );
              },
            );
          },
        ),
      ],
    );
  }
}
