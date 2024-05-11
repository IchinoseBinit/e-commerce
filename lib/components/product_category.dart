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

class ProductCategoryCard extends StatelessWidget {
  const ProductCategoryCard({
    this.productkey,
    this.scaffKey,
    this.width = 180,
    // this.aspectRetio = 1,
    required this.product,
  }) : super(key: productkey);

  final GlobalKey<ScaffoldState>? scaffKey;
  final double width;
  final Product product;
  final ValueKey? productkey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(20),
        right: getProportionateScreenWidth(10),
      ),
      child: Card(
        child: Container(
          width: getProportionateScreenWidth(width),
          // height: getProportionateScreenHeight(590),
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

            // child: SingleChildScrollView(
            child: Consumer<Products>(
              builder: (context, productData, _) {
                return ListView(
                  shrinkWrap: true,
                  primary: false,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).buttonColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          // gradient: LinearGradient(
                          //   begin: Alignment.bottomLeft,
                          //   end: Alignment.topRight,
                          //   colors: [
                          //     Theme.of(context).buttonColor.withOpacity(0.8),
                          //     Theme.of(context).buttonColor.withOpacity(0.4)
                          //   ],
                          // ),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              right: 5,
                              top: 0,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () async {
                                  final customer =
                                      Provider.of<CustomerProvider>(context,
                                              listen: false)
                                          .customer;
                                  if (customer != null) {
                                    if (productData
                                        .getProductById(product.id)!
                                        .isFavourite!) {
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .updateProductFavorite(product.id);
                                      await Provider.of<WishListProvider>(
                                              context,
                                              listen: false)
                                          .removeFromWishList(
                                              context, product.id);
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
                                      if (product.hasProductAttributes ==
                                          true) {
                                        final productWithAttributes = Provider
                                            .of<ProductAttributeProvider>(
                                                context,
                                                listen: false);
                                        final isAttributesValidated =
                                            productWithAttributes
                                                .checkHasSelectedAllProductAttribute(
                                                    product.id);
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
                                      } else if (product
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
                                          .updateProductFavorite(product.id);
                                      if (!await Provider.of<WishListProvider>(
                                              context,
                                              listen: false)
                                          .addToWishList(
                                        context: context,
                                        product: product,
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
                                          .getProductById(product.id)!
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
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Hero(
                                // key: productkey,
                                tag: '$productkey',
                                child: product.images!.isEmpty
                                    ? Text("Image HEre")
                                    : Image.memory(
                                        productData
                                            .getProductById(product.id)!
                                            .images![0]!,
                                        // product.images[0],
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ],
                          // child:
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$ ${productData.getProductById(product.id)!.price}",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).buttonColor,
                            ),
                          ),
                          Spacer(),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Icon(
                                  Icons.star,
                                  color: Theme.of(context).buttonColor,
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${product.rating}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Text(
                        '${productData.getProductById(product.id)!.title} ',
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                );
              },
              // child:
            ),
            // ),
          ),
        ),
      ),
    );
  }
}
