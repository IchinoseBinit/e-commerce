import 'package:e_commerce_app/screens/checkout/components/address.dart';
import 'package:e_commerce_app/screens/checkout/components/bill_details.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';

class CheckoutBody extends StatefulWidget {
  @override
  _CheckoutBodyState createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  bool? shippingAddress = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Expanded(
          Flexible(child: AddressDetails()),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                Checkbox(
                  value: shippingAddress,
                  onChanged: (value) {
                    setState(() {
                      shippingAddress = value;
                    });
                  },
                  activeColor: Theme.of(context).buttonColor,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),
                Text(
                  'Same Shipping Address',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          Spacer(),
          BillDetails(shippingAddress),
        ],
      ),
    );
  }
}
