import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './components/body.dart';

class ProductListScreen extends StatelessWidget {
  static const routeName = 'productListScreen';

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("$argument"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Body(argument),
    );
  }
}
