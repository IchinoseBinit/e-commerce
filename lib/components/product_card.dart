import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/providers/ProductAttributes.dart';
import 'package:e_commerce_app/providers/WishList.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app/utilities/dialog.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/screens/details/details_screen.dart';
import 'package:provider/provider.dart';

import '../size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    this.productkey,
    this.width,
    this.scaffKey,
    required this.product,
  }) : super(key: productkey);

  final GlobalKey<ScaffoldState>? scaffKey;
  final double? width;
  final Product? product;
  final ValueKey? productkey;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        // margin: EdgeInsets.symmetric(
        //   horizontal: 3.0,
        // ),
        width: getProportionateScreenWidth(width ?? 230),
        child: GestureDetector(
          onTap: () {
            List<dynamic> args = [
              ProductDetailsArguments(product: product),
              productkey
            ];

            Navigator.pushNamed(
              context,
              DetailsScreen.routeName,
              arguments: args,
            );
          },
          child: Consumer<Products>(
            builder: (context, productData, _) {
              return Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: SizeConfig.orientation == Orientation.landscape
                        ? SizeConfig.screenHeight! * 0.40
                        : getProportionateScreenHeight(160),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color == Colors.white
                            ? Colors.grey.shade100
                            : Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Container(
                          height:
                              SizeConfig.orientation == Orientation.landscape
                                  ? SizeConfig.screenHeight! * 0.08
                                  : getProportionateScreenHeight(30),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: getProportionateScreenHeight(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Icon(
                                        Icons.star,
                                        color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        '${product!.rating!.toStringAsFixed(2)}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () async {
                                  final customer =
                                      Provider.of<CustomerProvider>(context,
                                              listen: false)
                                          .customer;
                                  if (customer != null) {
                                    if (productData
                                        .getProductById(product!.id)!
                                        .isFavourite!) {
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .updateProductFavorite(product!.id);
                                      await Provider.of<WishListProvider>(
                                              context,
                                              listen: false)
                                          .removeFromWishList(
                                              context, product!.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Item removed from wishlist successfully!",
                                            textAlign: TextAlign.center,
                                          ),
                                          duration: Duration(
                                            milliseconds: 600,
                                          ),
                                        ),
                                      );
                                    } else {
                                      if (product!.hasProductAttributes ==
                                          true) {
                                        final productWithAttributes = Provider
                                            .of<ProductAttributeProvider>(
                                                context,
                                                listen: false);
                                        final isAttributesValidated =
                                            productWithAttributes
                                                .checkHasSelectedAllProductAttribute(
                                                    product!.id);
                                        if (!isAttributesValidated) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Please select other information first in the details page",
                                                textAlign: TextAlign.center,
                                              ),
                                              duration: Duration(
                                                milliseconds: 600,
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                      } else if (product!
                                          .hasAdditionalParameter!) {
                                        Navigator.pushNamed(
                                          context,
                                          DetailsScreen.routeName,
                                          arguments: ProductDetailsArguments(
                                              product: product),
                                        );
                                        return;
                                      }
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .updateProductFavorite(product!.id);
                                      if (!await Provider.of<WishListProvider>(
                                              context,
                                              listen: false)
                                          .addToWishList(
                                        context: context,
                                        product: product!,
                                      )) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Item could not be added to wishlist!",
                                              textAlign: TextAlign.center,
                                            ),
                                            duration: Duration(
                                              milliseconds: 600,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Item added to wishlist successfully!",
                                              textAlign: TextAlign.center,
                                            ),
                                            duration: Duration(
                                              milliseconds: 600,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    final result = await MyDialog().displayDialog(
                                        context,
                                        "Not Logged In",
                                        "Please login first to add item to wishlist.\nDo you wish to go to login screen?");
                                    if (result) {
                                      Navigator.of(context)
                                          .pushNamed(SignInScreen.routeName);
                                    }
                                    // LogOut().logout(context);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(
                                      getProportionateScreenWidth(8)),
                                  height: getProportionateScreenWidth(28),
                                  width: getProportionateScreenWidth(28),
                                  // decoration: BoxDecoration(
                                  //   color: product.isFavourite
                                  //       ? Theme.of(context)
                                  //           .buttonColor
                                  //           .withOpacity(0.15)
                                  //       : kSecondaryColor.withOpacity(0.1),
                                  //   shape: BoxShape.circle,
                                  // ),
                                  child: productData
                                          .getProductById(product!.id)!
                                          .isFavourite!
                                      ? Icon(
                                          Icons.favorite_outlined,
                                          color: Theme.of(context).buttonColor,
                                        )
                                      : Icon(
                                          Icons.favorite_border_outlined,
                                          color: Theme.of(context).buttonColor,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height:
                              SizeConfig.orientation == Orientation.landscape
                                  ? SizeConfig.screenHeight! * 0.30
                                  : SizeConfig.screenHeight! * 0.15,
                          child: Hero(
                            // key: productkey,
                            tag: '$productkey',
                            child: product!.images!.isEmpty
                                ? Text("Image HEre")
                                : Image.memory(
                                    productData
                                        .getProductById(product!.id)!
                                        .images![0]!,
                                    // product.images[0],
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: SizeConfig.orientation == Orientation.landscape
                        ? SizeConfig.screenHeight! * 0.10
                        : getProportionateScreenHeight(30),
                    margin: EdgeInsets.only(
                      top: getProportionateScreenHeight(
                        10,
                      ),
                    ),
                    child: Text(
                      "\$ ${productData.getProductById(product!.id)!.price}",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).buttonColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Spacer(),
                  Text(
                    '${productData.getProductById(product!.id)!.title} ',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(
                        13,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
