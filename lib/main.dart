import 'package:e_commerce_app/providers/Address.dart';
import 'package:e_commerce_app/providers/Blog.dart';
import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/providers/Category.dart';
import 'package:e_commerce_app/providers/Country.dart';
import 'package:e_commerce_app/providers/Currency.dart';
import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/providers/HomePage.dart';
import 'package:e_commerce_app/providers/News.dart';
import 'package:e_commerce_app/providers/Order.dart';
import 'package:e_commerce_app/providers/PaymentMethod.dart';
import 'package:e_commerce_app/providers/PickUpPoint.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/providers/ProductAttributes.dart';
import 'package:e_commerce_app/providers/ProfilePic.dart';
import 'package:e_commerce_app/providers/Reviews.dart';
import 'package:e_commerce_app/providers/ShippingMethod.dart';
import 'package:e_commerce_app/providers/State.dart';
import 'package:e_commerce_app/providers/Theme.dart';
import 'package:e_commerce_app/providers/WishList.dart';
import 'package:e_commerce_app/screens/splash/splash_loading.dart';
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/routes.dart';
import 'package:e_commerce_app/theme.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
// import '../_config.yml';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocument = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocument.path);
  MySharedPreferences.sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Addresses(),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CountryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrencyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishListProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StatesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ShippingMethodProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentMethodProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PickUpPointProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductReviewProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BlogProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomePageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfilePictureProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductAttributeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // title: 'Flutter Demo',
            // themeMode: ThemeMode.system,
            theme: theme(themeData.darkTheme!, themeData.colorTheme!),
            // home: SplashScreen(),
            // We use routeName so that we dont need to remember the name
            initialRoute: SplashLoadingScreen.routeName,
            routes: routes,
          );
        },
      ),
    );
  }
}
