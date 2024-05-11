import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  static String routeName = '/invoice';
  final snow = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var order = snow.year.toString() +
        snow.month.toString() +
        snow.day.toString() +
        '-' +
        snow.hour.toString() +
        snow.minute.toString() +
        snow.second.toString();
    print(snow);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Complete"),
      ),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Container(
              width: double.infinity,
              child: Text(
                "Your order has been successfully placed.",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(80),
            ),
            Text.rich(
              TextSpan(
                text: "Order Number:\t",
              ),
            ),
            Text(
              order,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline4!.color,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: DefaultButton(
                text: "Home",
                press: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName, (Route<dynamic> route) => false);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
