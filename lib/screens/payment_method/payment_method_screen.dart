import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/providers/PaymentMethod.dart' as payment;
import 'package:e_commerce_app/screens/invoice/invoice.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:e_commerce_app/utilities/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatefulWidget {
  static const routeName = '/paymentMethod';

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future? future;

  @override
  void initState() {
    super.initState();
    future = Provider.of<payment.PaymentMethodProvider>(context, listen: false)
        .fetchPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Choose Payment Method"),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, shippingData) {
          if (shippingData.connectionState == ConnectionState.waiting) {
            return Container(
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SingleChildScrollView(
            child:
                // Expanded(
                //   child:
                Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.values,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<payment.PaymentMethodProvider>(
                  builder: (context, paymentMethods, _) {
                    return Container(
                      height: getProportionateScreenHeight(
                        600,
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: paymentMethods.paymentMethods.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                paymentMethods.paymentMethods[index].name!,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              trailing: paymentMethods
                                      .paymentMethods[index].isSelected!
                                  ? Icon(
                                      Icons.done,
                                      color: Theme.of(context).iconTheme.color,
                                    )
                                  : SizedBox.shrink(),
                              onTap: () {
                                paymentMethods.selectPaymentMethod(
                                    paymentMethods.paymentMethods[index]);
                              },
                            );
                          }),
                    );
                  },
                ),
                // Spacer(),
                Provider.of<payment.PaymentMethodProvider>(context)
                            .getSelectedPaymentMethod() ==
                        null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultButton(
                          text: "Order",
                          icon: Icons.done,
                          press: () async {
                            LoadingDialog.displayLoadingDialog(
                                context, "Loading");

                            if (await Provider.of<
                                        payment.PaymentMethodProvider>(context,
                                    listen: false)
                                .savePaymentMethod(context)) {
                              Provider.of<CartProvider>(context, listen: false)
                                  .clearCartLocally();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  InvoiceScreen.routeName,
                                  (Route<dynamic> route) => false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Error Occurred! Please try again later"),
                                ),
                              );
                            }
                          },
                        ),
                      ),
              ],
            ),
            // ),
          );
        },
      ),
    );
  }
}
