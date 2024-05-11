import 'package:e_commerce_app/providers/Order.dart';
import 'package:e_commerce_app/screens/order_details/order_details_screen.dart';
import 'package:e_commerce_app/screens/orders/components/order_card.dart';
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
    super.initState();
    future = Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, orderData) {
        if (orderData.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            return orderProvider.orders.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: orderProvider.orders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            orderProvider.selectOrder(
                                context, orderProvider.orders[index].id);
                            Navigator.of(context)
                                .pushNamed(OrderDetailsScreen.routeName);
                          },
                          child: OrderCard(
                            order: orderProvider.orders[index],
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    child: Center(
                      child: Text(
                        "No Orders yet",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
