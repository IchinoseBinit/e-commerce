import 'package:e_commerce_app/providers/Order.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Order? order;
  final Color? orderCardColor;

  OrderCard({this.order, this.orderCardColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: orderCardColor != null
          ? orderCardColor
          : Theme.of(context).textTheme.headline4!.color == Colors.white
              ? Theme.of(context).textTheme.headline4!.color!.withOpacity(0.2)
              : Colors.white.withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Code: ${order!.orderCode}',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Spacer(),
                Text(
                  order!.orderTotal,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(5),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.screenWidth * 0.5,
                  child: Text(
                    'Email: ${order!.customerEmail}',
                    maxLines: 4,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Spacer(),
                Text(
                  'Order Number: ${order!.orderNumber}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(8),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Container(
                    width: SizeConfig.screenWidth * 0.3,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.shopping_bag),
                        SizedBox(
                          width: getProportionateScreenWidth(5),
                        ),
                        Text(
                          order!.orderStatus,
                          maxLines: 4,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.3,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.payment),
                      SizedBox(
                        width: getProportionateScreenWidth(5),
                      ),
                      Text(
                        order!.paymentStatus,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.3,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.local_shipping),
                      SizedBox(
                        width: getProportionateScreenWidth(5),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 5,
                        child: Text(
                          order!.shippingStatus,
                          maxLines: 4,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
