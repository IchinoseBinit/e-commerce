import 'package:e_commerce_app/components/icon_btn_with_counter.dart';
import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/providers/Theme.dart';
import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/utilities/searchQuery.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/screens/cart/cart_screen.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import 'search_field.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  // method to check in which route the app currently is
  bool _checkRoute() {
    final currentRouteName = HomeScreen.routeName;
    bool isNewRouteSameAsCurrent = false;
    var route = ModalRoute.of(context);

    if (route != null) {
      if (route.settings.name == currentRouteName) {
        isNewRouteSameAsCurrent = true;
      }
    }
    return isNewRouteSameAsCurrent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: getProportionateScreenWidth(46),
            width: getProportionateScreenWidth(46),
            // decoration: BoxDecoration(
            //   color: kSecondaryColor.withOpacity(0.1),
            //   shape: BoxShape.circle,
            // ),
            child: IconButton(
              icon: Icon(
                _checkRoute() ? Icons.menu : Icons.arrow_back,
                size: 24,
              ),
              onPressed: () {
                if (_checkRoute()) {
                  Scaffold.of(context).openDrawer();
                } else {
                  setState(() {
                    SearchQuery.queryStringController.clear();
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeData, __) {
              return Expanded(
                child: SearchField(
                  themeProvider: themeData,
                ),
              );
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cartData, _) {
              print("this is ${cartData.getCartCount()}");
              return IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfitem: cartData.getCartCount() ?? 0,
                press: () => Navigator.pushNamed(context, CartScreen.routeName),
              );
            },
          ),
        ],
      ),
    );
  }
}
