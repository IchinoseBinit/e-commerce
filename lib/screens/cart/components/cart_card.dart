import 'package:e_commerce_app/screens/cart/components/price_quantity.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/providers/Cart.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 0,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: getProportionateScreenWidth(100),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: cart.product.images!.isEmpty
                      ? Text(
                          "No Image",
                          style: Theme.of(context)
                              .appBarTheme
                              .textTheme!
                              .bodyText1,
                        )
                      : Hero(
                          tag: ValueKey('${cart.product.id} from cart'),
                          child: Image.memory(cart.product.images![0]!)),
                ),
              ),
            ),
            SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.product.title!,
                  style: TextStyle(fontSize: 16),
                  maxLines: 2,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(7),
                ),
                Text(
                  "\$${cart.product.price}",
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(7)),
                CartPriceQuantity(cart),
              ],
            ),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}
