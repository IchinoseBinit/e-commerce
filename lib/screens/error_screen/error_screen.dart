import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  static const routeName = '/errorScreen';

  ErrorScreen(this.error, this.url);

  final error;
  final url;

  @override
  Widget build(BuildContext context) {
    print(error);

    return Scaffold(
      appBar: AppBar(
        title: Text("Error Screen"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        // child: Expanded(
        child: Container(
          child: Text(
            error.toString() + url,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        // ),
      ),
    );
  }
}
