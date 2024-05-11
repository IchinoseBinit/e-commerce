import 'package:e_commerce_app/components/product_card.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/screens/home/components/section_title.dart';
import 'package:e_commerce_app/screens/home_products_list/products_list.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewProducts extends StatefulWidget {
  NewProducts(this.scaffKey);

  final GlobalKey<ScaffoldState> scaffKey;
  @override
  _NewProductsState createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
  Future? future;

  @override
  void initState() {
    future = Provider.of<Products>(context, listen: false)
        .fetchHomePageNewProducts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SectionTitle(
          title: "New Products",
          press: () {
            Navigator.of(context).pushNamed(ProductListScreen.routeName,
                arguments: "Home Page New Products");
          },
        ),
      ),
      SizedBox(height: getProportionateScreenWidth(20)),
      FutureBuilder(
        future: future,
        builder: (context, homePageData) {
          if (homePageData.connectionState == ConnectionState.waiting) {
            return Container(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Consumer<Products>(
            builder: (context, homePageNewProducts, _) {
              return homePageNewProducts.homePageNewProducts.isNotEmpty
                  ? Container(
                      height: SizeConfig.orientation == Orientation.landscape
                          ? SizeConfig.screenHeight! * 1.15
                          : SizeConfig.screenHeight! * 0.32,
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount:
                            homePageNewProducts.homePageNewProducts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),
                            child: ProductCard(
                              width: 110,
                              scaffKey: widget.scaffKey,
                              productkey: ValueKey(
                                  '${homePageNewProducts.homePageNewProducts[index].id} from new'),
                              product: homePageNewProducts
                                  .homePageNewProducts[index],
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 120,
                      child: Center(
                        child: Text("No products to display"),
                      ),
                    );
            },
          );
        },
      )
    ]);
  }
}
