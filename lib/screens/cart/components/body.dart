import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/screens/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartListData, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await cartListData.fetchCartList();
          },
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10)),
              child: ListView.builder(
                itemCount: cartListData.carts.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        Provider.of<CartProvider>(context, listen: false)
                            .removeFromCart(
                                cartListData.carts[index].product.id);
                      });
                    },
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFE6E6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Spacer(),
                          SvgPicture.asset("assets/icons/Trash.svg"),
                        ],
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        List<dynamic> args = [
                          ProductDetailsArguments(
                              product: cartListData.carts[index].product),
                          ValueKey(
                            '${cartListData.carts[index].product.id} from cart',
                          ),
                        ];

                        Navigator.pushNamed(
                          context,
                          DetailsScreen.routeName,
                          arguments: args,
                        );
                      },
                      child: CartCard(
                        cart: cartListData.carts[index],
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
