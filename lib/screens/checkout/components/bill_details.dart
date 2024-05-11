import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/providers/Address.dart';
import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/screens/shipping_address/shipping_address_screen.dart';
import 'package:e_commerce_app/screens/shipping_method/shipping_method_screen.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:e_commerce_app/utilities/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillDetails extends StatelessWidget {
  final bool? shipAddress;

  BillDetails(this.shipAddress);

  @override
  Widget build(BuildContext context) {
    final cartAmount =
        Provider.of<CartProvider>(context, listen: false).getTotalCartAmount();
    final billAmount =
        Provider.of<CartProvider>(context, listen: false).getTotalBillAmount();
    return Container(
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ListTile(
              leading: Text("Bill Amount:"),
              trailing: Text(
                "\$${cartAmount.toStringAsFixed(1)}",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.headline4!.color),
              ),
            ),
            ListTile(
              leading: Text("Delivery Charge:"),
              trailing: Text(
                "\$80",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            ListTile(
              leading: Text("Total:"),
              trailing: Text(
                "\$${billAmount.toStringAsFixed(1)}",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              margin: EdgeInsets.only(
                bottom: getProportionateScreenHeight(
                  6,
                ),
              ),
              padding: const EdgeInsets.all(6.0),
              child: DefaultButton(
                text: shipAddress! ? "Method" : "Shipping",
                icon: shipAddress!
                    ? Icons.payment
                    : Icons.add_circle_outline_rounded,
                press: () async {
                  if (Provider.of<Addresses>(context, listen: false)
                      .addresses
                      .isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'Please add an address first',
                      textAlign: TextAlign.center,
                    )));
                    return;
                  }
                  LoadingDialog.displayLoadingDialog(context, "Loading");
                  await Provider.of<Addresses>(context, listen: false)
                      .saveBilling(context, shipAddress!);
                  Navigator.of(context).pop();
                  shipAddress!
                      ? Navigator.of(context)
                          .pushNamed(ShippingMethodScreen.routeName)
                      : Navigator.of(context)
                          .pushNamed(ShippingAddressFormScreen.routeName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
