import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/providers/HomePage.dart';
import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/screens/splash/splash_screen.dart';
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:e_commerce_app/utilities/log_out.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SplashLoadingScreen extends StatefulWidget {
  static const routeName = '/splashLoading';

  @override
  _SplashLoadingScreenState createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  getFirstWidget() {
    if (MySharedPreferences.sharedPreferences.containsKey('token')) {
      return HomeScreen.routeName;
    }
    return SplashScreen.routeName;
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    Future.delayed(Duration(seconds: 3)).then(
      (_) {
        Provider.of<CustomerProvider>(context, listen: false)
            .fetchDetails(context)
            .then(
              (value) => value != 'logout'
                  ? Provider.of<HomePageProvider>(context, listen: false)
                      .fetchHomeProducts(context)
                      .then(
                        (_) => Navigator.of(context)
                            .pushReplacementNamed(getFirstWidget()),
                      )
                  : LogOut().logout(context, toSplash: true),
            );
      },
    );

    // Timer(Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacementNamed(getFirstWidget());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).cardTheme.color,
        ),
        Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Theme.of(context).buttonColor,
                      radius: 50.0,
                      child: Icon(
                        Icons.shop,
                        size: 48.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Easy shopping',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontSize: 32,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
