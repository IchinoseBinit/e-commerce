import 'package:e_commerce_app/components/rounded_icon_btn.dart';
import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPriceQuantity extends StatefulWidget {
  final Cart cart;

  CartPriceQuantity(this.cart);
  @override
  _CartPriceQuantityState createState() => _CartPriceQuantityState();
}

class _CartPriceQuantityState extends State<CartPriceQuantity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text(
          //   '\$${widget.cart.product.price}',
          //   style: TextStyle(
          //       fontWeight: FontWeight.w600,
          //       color: Theme.of(context).buttonColor),
          // ),
          RoundedIconBtn(
            icon: Icons.remove,

            // showShadow: true,
            press: () {
              setState(() {
                if (widget.cart.quantity! > 1) {
                  Provider.of<CartProvider>(context, listen: false).updateCart(
                      widget.cart.product.id, widget.cart.quantity! - 1);
                }
              });
            },
          ),
          SizedBox(
            width: getProportionateScreenWidth(20),
          ),
          Text(
            ' ${widget.cart.quantity}',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: getProportionateScreenWidth(20),
          ),
          RoundedIconBtn(
            icon: Icons.add,
            // showShadow: true,
            press: () {
              setState(() {
                Provider.of<CartProvider>(context, listen: false).updateCart(
                    widget.cart.product.id, widget.cart.quantity! + 1);
                // widget.wishList.quantity++;
              });
            },
          ),
        ],
      ),
    );
  }
}
