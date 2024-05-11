import 'package:e_commerce_app/providers/WishList.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    Key? key,
    required this.wishList,
  }) : super(key: key);

  final WishList wishList;

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: Theme.of(context).cardTheme.color,
        child: Row(
          children: [
            SizedBox(
              width: 88,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: widget.wishList.product!.images!.isEmpty
                      ? Text(
                          "No Image",
                          style:
                              Theme.of(context).appBarTheme.textTheme!.bodyText1,
                        )
                      : Image.memory(widget.wishList.product!.images![0]!),
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.wishList.product!.title!,
                  style: TextStyle(fontSize: 16),
                  maxLines: 2,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '\$${widget.wishList.product!.price}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).buttonColor),
                    ),
                    Text(
                      ' x ${widget.wishList.quantity}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    // RoundedIconBtn(
                    //   icon: Icons.add,
                    //   showShadow: true,
                    //   press: () {
                    //     setState(() {
                    //       Provider.of<WishListProvider>(context, listen: false)
                    //           .updateWishList(widget.wishList.product.id,
                    //               widget.wishList.quantity + 1);
                    //       // widget.wishList.quantity++;
                    //     });
                    //   },
                    // ),
                    // SizedBox(
                    //   width: getProportionateScreenWidth(10),
                    // ),
                    // RoundedIconBtn(
                    //   icon: Icons.remove,
                    //   showShadow: true,
                    //   press: () {
                    //     setState(() {
                    //       if (widget.wishList.quantity > 1) {
                    //         Provider.of<WishListProvider>(context,
                    //                 listen: false)
                    //             .updateWishList(widget.wishList.product.id,
                    //                 widget.wishList.quantity - 1);
                    //       }
                    //     });
                    //   },
                    // ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
