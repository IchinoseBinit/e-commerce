import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/providers/ProductAttributes.dart';
import 'package:e_commerce_app/providers/WishList.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app/utilities/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    required this.scaffKey,
    this.quantity,
    this.pressOnSeeMore,
    this.formKey,
  }) : super(key: key);

  final GlobalKey<FormState>? formKey;
  final Product? product;
  final int? quantity;
  final GestureTapCallback? pressOnSeeMore;

  final GlobalKey<ScaffoldState> scaffKey;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool maxLines = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Text(
                  widget.product!.title!,

                  style: Theme.of(context).textTheme.headline4,
                  maxLines: 3,
                  // textWidthBasis: ,
                ),
              ),
            ),
            Consumer<Products>(
              builder: (context, products, _) {
                return GestureDetector(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                      width: SizeConfig.orientation == Orientation.landscape
                          ? getProportionateScreenWidth(45)
                          : getProportionateScreenWidth(64),
                      decoration: BoxDecoration(
                        color: products
                                .getProductById(widget.product!.id)!
                                .isFavourite!
                            ? Theme.of(context).buttonColor.withOpacity(0.15)
                            : Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        color: products
                                .getProductById(widget.product!.id)!
                                .isFavourite!
                            ? Theme.of(context).buttonColor
                            : Color(0xFFDBDEE4),
                        height: SizeConfig.orientation == Orientation.landscape
                            ? getProportionateScreenWidth(12)
                            : getProportionateScreenWidth(16),
                      ),
                    ),
                  ),
                  onTap: () async {
                    print(widget.product!.isGiftCard);
                    // return;
                    final customer =
                        Provider.of<CustomerProvider>(context, listen: false)
                            .customer;
                    if (customer != null) {
                      if (products
                          .getProductById(widget.product!.id)!
                          .isFavourite!) {
                        ScaffoldMessenger.of(context).showSnackBar(
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
                        Provider.of<Products>(context, listen: false)
                            .updateProductFavorite(widget.product!.id);
                        await Provider.of<WishListProvider>(context,
                                listen: false)
                            .removeFromWishList(context, widget.product!.id);
                      } else {
                        if (widget.product!.isGiftCard!) {
                          if (!widget.formKey!.currentState!.validate()) {
                            return;
                          } else {
                            widget.formKey!.currentState!.save();
                            final productsData =
                                Provider.of<Products>(context, listen: false);
                            final map = productsData.values;
                            productsData
                                .updateProductFavorite(widget.product!.id);
                            if (!await Provider.of<WishListProvider>(context,
                                    listen: false)
                                .addToWishList(
                              context: context,
                              product: widget.product!,
                              giftCardMap: map,
                            )) {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                              ScaffoldMessenger.of(context).showSnackBar(
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
                          return;
                        } else if (widget.product!.hasProductAttributes!) {
                          print("k xa");

                          final productWithAttributes =
                              Provider.of<ProductAttributeProvider>(context,
                                  listen: false);
                          if (productWithAttributes.getProductWithAttribute(
                                  widget.product!.id) !=
                              null) {
                            final isAttributesValidated = productWithAttributes
                                .checkHasSelectedAllProductAttribute(
                                    widget.product!.id);
                            if (!isAttributesValidated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please select all the attributes first",
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(
                                    milliseconds: 600,
                                  ),
                                ),
                              );
                              return;
                            } else {
                              Provider.of<Products>(context, listen: false)
                                  .updateProductFavorite(widget.product!.id);
                              final attributeMap = productWithAttributes
                                  .productAttributeToMap(widget.product!.id);
                              print(attributeMap);
                              if (!await Provider.of<WishListProvider>(context,
                                      listen: false)
                                  .addToWishList(
                                context: context,
                                product: widget.product!,
                                map: attributeMap,
                              )) {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                ScaffoldMessenger.of(context).showSnackBar(
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
                            Provider.of<Products>(context, listen: false)
                                .updateProductFavorite(widget.product!.id);
                            if (!await Provider.of<WishListProvider>(context,
                                    listen: false)
                                .addToWishList(
                              context: context,
                              product: widget.product!,
                            )) {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                              ScaffoldMessenger.of(context).showSnackBar(
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
                          print("ki xo");
                          Provider.of<Products>(context, listen: false)
                              .updateProductFavorite(widget.product!.id);
                          if (!await Provider.of<WishListProvider>(context,
                                  listen: false)
                              .addToWishList(
                            context: context,
                            product: widget.product!,
                          )) {
                            ScaffoldMessenger.of(context).showSnackBar(
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
                            ScaffoldMessenger.of(context).showSnackBar(
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
                      }
                    } else {
                      final result = await MyDialog().displayDialog(
                          context,
                          "Not Logged In",
                          "Please login first to add item to wishlist.\nDo you wish to go to login screen?");
                      if (result) {
                        Navigator.of(context).pushNamed(SignInScreen.routeName);
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            "\$ ${widget.product!.price}",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(24),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).buttonColor,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        maxLines
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Text(
                  widget.product!.description!,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(
                      SizeConfig.orientation == Orientation.landscape ? 8 : 14,
                    ),
                  ),
                  textAlign: TextAlign.justify,
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Text(
                  widget.product!.description ?? 'No description',
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(
                      SizeConfig.orientation == Orientation.landscape ? 8 : 14,
                    ),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
        widget.product!.description == null
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: 10,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      maxLines = !maxLines;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        maxLines == false
                            ? "See More Detail"
                            : "See Less Detail",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).buttonColor),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Theme.of(context).buttonColor,
                      ),
                    ],
                  ),
                ),
              )
      ],
    );
  }
}
