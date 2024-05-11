import 'package:flutter/material.dart';

import './components/body.dart';

class NewsBlogsScreen extends StatelessWidget {
  static const routeName = '/newsBlogScreen';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments!;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments as String),
        centerTitle: true,
      ),
      body: Body(arguments),
    );
  }
}
