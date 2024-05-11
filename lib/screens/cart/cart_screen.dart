import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/providers/Cart.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future? future;
  @override
  void initState() {
    // fetchCart();
    super.initState();
    future = Provider.of<CartProvider>(context, listen: false).fetchCartList();
  }

  // void fetchCart() async {
  //   carts =
  //       await Provider.of<CartProvider>(context, listen: false).fetchCartList();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, cartList) {
          if (cartList.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Loading Your Cart"),
              ),
              body: Container(
                height: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          return Consumer<CartProvider>(
            builder: (context, cartsData, _) {
              return Scaffold(
                appBar: buildAppBar(context),
                body: cartsData.carts.isEmpty
                    ? Container(
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Center(
                            //   child:
                            Text(
                              'No items in cart\nPlease add some to browse',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            // ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: DefaultButton(
                                text: "Home",
                                icon: Icons.home,
                                press: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    : Body(),
                bottomNavigationBar: cartsData.carts.isEmpty
                    ? Container(
                        child: Text(''),
                      )
                    : CheckoutCard(),
              );
            },
          );
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
          ),
          Consumer<CartProvider>(
            builder: (context, carts, _) {
              return Text(
                "${carts.carts.length.toString()} items",
                style: Theme.of(context).textTheme.caption,
              );
            },
          ),
        ],
      ),
      actions: [
        Provider.of<CartProvider>(context).carts.isNotEmpty
            ? PopupMenuButton(
                color: Theme.of(context).cardTheme.color,
                onSelected: (dynamic _) {
                  Provider.of<CartProvider>(context, listen: false).clearCart();
                },
                itemBuilder: (context) {
                  return ['Clear'].map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    );
                  }).toList();
                },
              )
            : SizedBox.shrink()
      ],
    );
  }
}
