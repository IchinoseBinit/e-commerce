import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/providers/ShippingMethod.dart';
import 'package:e_commerce_app/screens/payment_method/payment_method_screen.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:e_commerce_app/utilities/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingMethodScreen extends StatefulWidget {
  static const routeName = '/shippingMethod';

  @override
  _ShippingMethodScreenState createState() => _ShippingMethodScreenState();
}

class _ShippingMethodScreenState extends State<ShippingMethodScreen> {
  Future? future;

  @override
  void initState() {
    super.initState();
    future = Provider.of<ShippingMethodProvider>(context, listen: false)
        .fetchShippingMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Shipping Method"),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, shippingData) {
          if (shippingData.connectionState == ConnectionState.waiting) {
            return Container(
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
                Consumer<ShippingMethodProvider>(
                  builder: (context, shippingMethods, _) {
                    return Container(
                      height: getProportionateScreenHeight(
                        600,
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: shippingMethods.shippingMethods.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                shippingMethods.shippingMethods[index].value!,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              trailing: shippingMethods
                                      .shippingMethods[index].selected!
                                  ? Icon(
                                      Icons.done,
                                      color: Theme.of(context).iconTheme.color,
                                    )
                                  : SizedBox.shrink(),
                              onTap: () {
                                shippingMethods.selectShippingMethod(
                                    shippingMethods.shippingMethods[index]);
                              },
                            );
                          }),
                    );
                  },
                ),
                // Spacer(),
                Provider.of<ShippingMethodProvider>(context)
                            .getSelectedShippingMethod() ==
                        null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultButton(
                          text: "Payment",
                          icon: Icons.payment,
                          press: () async {
                            LoadingDialog.displayLoadingDialog(
                                context, "Loading");
                            await Provider.of<ShippingMethodProvider>(context,
                                    listen: false)
                                .saveShippingMethod(context);
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushNamed(PaymentMethodScreen.routeName);
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
