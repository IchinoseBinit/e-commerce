import 'package:e_commerce_app/screens/address/components/body.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  static const routeName = '/addressScreen';

  final _scaffKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Select Address"),
      ),
      body: Body(),
    );
  }
}
