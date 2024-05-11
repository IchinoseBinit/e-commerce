import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/providers/Order.dart';
import 'package:e_commerce_app/screens/order_details/components/order_products_card.dart';
import 'package:e_commerce_app/screens/orders/components/order_card.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future? future;

  @override
  void initState() {
    future = Provider.of<OrderProvider>(context, listen: false)
        .fetchOrderProducts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, orderProductData) {
        print(orderProductData);
        if (orderProductData.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Consumer<OrderProvider>(
          builder: (context, orderProducts, _) {
            final listOfProducts =
                orderProducts.getSelectedOrder()!.orderProducts;
            return listOfProducts.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: OrderCard(
                            order: orderProducts.getSelectedOrder(),
                            orderCardColor: Theme.of(context).cardTheme.color,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2,
                            color: Theme.of(context).cardTheme.color,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                    getProportionateScreenWidth(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Your Ordered ${listOfProducts.length == 1 ? 'Product' : 'Products'}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                      Spacer(),
                                      Text(
                                        "Quantity: ${listOfProducts.length}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: listOfProducts.length,
                                  itemBuilder: (context, index) {
                                    return OrderProductsCard(
                                        listOfProducts[index]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: Center(
                      child: Text(
                        "Cannot fetch the products at the moment!\nPlease try again later",
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
