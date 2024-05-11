import 'dart:io';

import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/providers/ProfilePic.dart';
import 'package:e_commerce_app/providers/WishList.dart';
import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/screens/splash/splash_screen.dart';
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

ApiCalls apiCalls = new ApiCalls();

class LogOut {
  Future<void> logout(BuildContext context, {bool toSplash = false}) async {
    // final response =
    //     await apiCalls.fetchData(url: logoutCustomerUrl, context: context);
    // print(response);
    await Hive.deleteFromDisk();
    await MySharedPreferences.sharedPreferences.remove('token');
    final appDir = await getTemporaryDirectory();
    final file = File('${appDir.path}/profile.jpg');
    Provider.of<CustomerProvider>(context, listen: false).removeCustomer();
    Provider.of<WishListProvider>(context, listen: false)
        .clearWishListLocally();
    Provider.of<Products>(context, listen: false).clearProductsLocally();
    Provider.of<CartProvider>(context, listen: false).clearCartLocally();
    Provider.of<ProfilePictureProvider>(context, listen: false)
        .clearProfilePic();

    if (await File('${appDir.path}/profile.jpg').exists()) {
      await file.delete();
    }
    if (toSplash) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          SplashScreen.routeName, (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (Route<dynamic> route) => false);
    }
  }
}
