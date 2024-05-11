import 'package:e_commerce_app/screens/checkout/components/body.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  static String routeName = '/checkout';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        centerTitle: true,
      ),
      body: CheckoutBody(),
      // Body(),
      // bottomNavigationBar: CheckoutCard(),
    );
  }
}
