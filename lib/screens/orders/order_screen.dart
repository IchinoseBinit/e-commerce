import 'package:flutter/material.dart';

import './components/body.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orderScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
