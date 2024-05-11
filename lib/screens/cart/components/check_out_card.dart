import 'package:e_commerce_app/providers/Cart.dart' as cart;
import 'package:e_commerce_app/screens/cart/components/checkout_attributes.dart';
import 'package:e_commerce_app/screens/checkout/checkout.dart';
import 'package:e_commerce_app/utilities/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_commerce_app/components/default_button.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkoutAttributes =
        Provider.of<cart.CartProvider>(context).checkoutAttributesList;
    return Container(
      height: MediaQuery.of(context).size.width > 460
          ? getProportionateScreenHeight(400)
          : getProportionateScreenHeight(210),
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Theme.of(context).cardTheme.color!.withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              checkoutAttributes.isEmpty
                  ? SizedBox.shrink()
                  : checkoutAttributes.length == 1
                      ? CheckoutAttributes(checkoutAttributes[0])
                      : SizedBox(
                          height: getProportionateScreenHeight(20),
                        ), //use a different screen with all the checkout attributes
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: getProportionateScreenWidth(40),
                    width: getProportionateScreenWidth(40),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/receipt.svg",
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Add voucher code",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Theme.of(context).buttonColor,
                  )
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total: "),
                  Consumer<cart.CartProvider>(builder: (context, cartData, _) {
                    return Text(
                      "\$${cartData.getTotalCartAmount().toStringAsFixed(1)}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.headline4!.color),
                    );
                  }),
                  SizedBox(
                    width: getProportionateScreenWidth(190),
                    child: DefaultButton(
                      text: "Check Out",
                      press: () async {
                        LoadingDialog.displayLoadingDialog(context, "Loading");
                        await Provider.of<cart.CartProvider>(context,
                                listen: false)
                            .startCheckout();
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(CheckoutScreen.routeName);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
