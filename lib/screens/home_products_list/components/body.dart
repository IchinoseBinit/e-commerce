import 'package:e_commerce_app/components/product_card.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  Body(this.argument);

  final argument;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future? future;

  @override
  void initState() {
    if (widget.argument == 'Home Page Products') {
      future = Provider.of<Products>(context, listen: false)
          .fetchHomePageProducts(context);
    } else {
      print("hihi");
      future = Provider.of<Products>(context, listen: false)
          .fetchHomePageNewProducts(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, productData) {
          if (productData.connectionState == ConnectionState.waiting) {
            return Container(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Consumer<Products>(
            builder: (context, productsList, _) {
              var listOfProducts = [];
              if (widget.argument == 'Home Page Products') {
                listOfProducts = productsList.homePageProducts;
              } else {
                listOfProducts = productsList.homePageNewProducts;
              }
              return listOfProducts.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        GridView.builder(
                          itemCount: listOfProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              productkey: ValueKey(
                                  '${listOfProducts[index].id} from ${widget.argument}'),
                              product: listOfProducts[index],
                            );
                          },
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                          ),
                          // Generate 100 widgets that display their index in the List.
                        ),
                      ],
                    )
                  : Container(
                      height: 120,
                      child: Center(
                        child: Text("No Products to display"),
                      ),
                    );
            },
          );
        });
  }
}
