import 'package:flutter/material.dart';

import './components/body.dart';

class CategoryScreen extends StatelessWidget {
  final scaffKey = new GlobalKey<ScaffoldState>();

  static const routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffKey,
      appBar: AppBar(
        title: Text(
          "Categories",
          style: Theme.of(context).appBarTheme.textTheme!.headline1,
        ),
        centerTitle: true,
      ),
      body: Body(scaffKey),
    );
  }
}
