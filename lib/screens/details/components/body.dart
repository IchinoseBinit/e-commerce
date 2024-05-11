import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/providers/ProductAttributes.dart';
import 'package:e_commerce_app/screens/details/components/attributes.dart';
import 'package:e_commerce_app/screens/details/components/gift_card_details.dart';
import 'package:e_commerce_app/screens/details/components/product_reviews.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app/utilities/dialog.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:provider/provider.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final Product? product;
  final GlobalKey<ScaffoldState> scaffKey;
  final ValueKey productKey;

  const Body(
      {Key? key,
      required this.product,
      required this.scaffKey,
      required this.productKey})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future? future;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    future = Provider.of<ProductAttributeProvider>(context, listen: false)
        .addProductAttribute(context, widget.product!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(
          product: widget.product,
          productKey: widget.productKey,
        ),
        TopRoundedContainer(
          color: Theme.of(context).cardTheme.color,
          child: FutureBuilder(
            future: future,
            builder: (context, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final prod = Provider.of<Products>(context, listen: false)
                  .getProductById(widget.product!.id);
              return Column(
                children: [
                  ProductDescription(
                    product: prod,
                    scaffKey: widget.scaffKey,
                    pressOnSeeMore: () {},
                    formKey: _formKey,
                  ),
                  widget.product!.hasAdditionalParameter != null
                      ? prod!.hasProductAttributes!
                          ? Attributes(widget.product, widget.scaffKey)
                          : prod.isGiftCard == null
                              ? SizedBox.shrink()
                              : prod.isGiftCard!
                                  ? GiftCardDetails(_formKey)
                                  : SizedBox.shrink()
                      : SizedBox.shrink(),
                  TopRoundedContainer(
                    color: Theme.of(context).cardTheme.color,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.screenWidth * 0.15,
                        right: SizeConfig.screenWidth * 0.15,
                        bottom: getProportionateScreenHeight(40),
                        top: getProportionateScreenHeight(15),
                      ),
                      child: DefaultButton(
                        text: "Add To Cart",
                        press: () async {
                          final isCustomer = Provider.of<CustomerProvider>(
                                      context,
                                      listen: false)
                                  .customer !=
                              null;

                          if (isCustomer) {
                            final productWithAttributes =
                                Provider.of<ProductAttributeProvider>(context,
                                    listen: false);
                            if (prod!.isGiftCard!) {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                _formKey.currentState!.save();
                                final productsData = Provider.of<Products>(
                                    context,
                                    listen: false);
                                final giftDetailMap = productsData.values;
                                productsData
                                    .updateProductFavorite(widget.product!.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Item added to cart successfully!",
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(
                                      milliseconds: 600,
                                    ),
                                  ),
                                );
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addToCart(
                                  widget.product!,
                                  1,
                                  giftCardMap: giftDetailMap,
                                );
                              }
                            } else if (prod.hasProductAttributes!) {
                              if (productWithAttributes.getProductWithAttribute(
                                      widget.product!.id) !=
                                  null) {
                                final isAttributesValidated =
                                    productWithAttributes
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
                                  final attributeMap = productWithAttributes
                                      .productAttributeToMap(
                                          widget.product!.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Item added to cart successfully!",
                                        textAlign: TextAlign.center,
                                      ),
                                      duration: Duration(
                                        milliseconds: 600,
                                      ),
                                    ),
                                  );
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .addToCart(
                                    widget.product!,
                                    1,
                                    map: attributeMap,
                                  );
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Item added to cart successfully!",
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(
                                    milliseconds: 600,
                                  ),
                                ),
                              );
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(widget.product!, 1);
                            }
                          } else {
                            final result = await MyDialog().displayDialog(
                                context,
                                "Not Logged In",
                                "Please login first to add item to cart.\nDo you wish to go to login screen?");
                            if (result) {
                              Navigator.of(context)
                                  .pushNamed(SignInScreen.routeName);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  ProductReviews(widget.product),
                  // SizedBox(height: getProportionateScreenHeight(10),)
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
