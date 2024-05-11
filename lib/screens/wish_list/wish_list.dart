import 'package:e_commerce_app/components/coustom_bottom_nav_bar.dart';
import 'package:e_commerce_app/enums.dart';
import 'package:flutter/material.dart';

import './components/body.dart';

class WishListScreen extends StatelessWidget {
  static const routeName = '/wishlist';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Favorites"),
      ),
      body: Body(),
      bottomNavigationBar:
          CustomBottomNavBar(selectedMenu: MenuState.favourite),
    );
  }
}
