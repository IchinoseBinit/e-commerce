import 'package:e_commerce_app/screens/app_details/components/blog.dart';
import 'package:e_commerce_app/screens/app_details/components/news.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        children: [
          News(),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Blog(),
        ],
      ),
    );
  }
}
