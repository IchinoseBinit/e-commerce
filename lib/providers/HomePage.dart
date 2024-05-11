import 'package:e_commerce_app/providers/Category.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomePageProvider with ChangeNotifier {
  Future<void> fetchHomeProducts(BuildContext context) async {
    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchHomePageCategories(context);
    await Provider.of<Products>(context, listen: false)
        .fetchHomePageProducts(context);
    // await Provider.of<Products>(context, listen: false)
    //     .fetchHomePageNewProducts();
  }
}
