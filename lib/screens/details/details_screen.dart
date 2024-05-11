import 'package:flutter/material.dart';

import '../../providers/Product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    List<dynamic>? args;
    args = ModalRoute.of(context)!.settings.arguments as List<dynamic>?;
    final agrs = args![0];
    final productKey = args[1];
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(rating: agrs.product.rating),
      body: Body(
        product: agrs.product,
        scaffKey: scaffoldKey,
        productKey: productKey,
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product? product;

  ProductDetailsArguments({required this.product});
}
