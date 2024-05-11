import 'package:flutter/material.dart';

import './components/body.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routeName = '/orderDetailsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
