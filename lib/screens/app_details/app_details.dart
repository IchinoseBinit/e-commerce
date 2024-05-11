import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './components/body.dart';

class AppDetailsScreen extends StatelessWidget {
  static const routeName = '/appDetailsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
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
      body: Body(),
    );
  }
}
