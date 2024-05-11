import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '/components/product_review.dart';
// import '/providers/Order.dart';
// import '/screens/details/details_screen.dart';
import '/utils/size_config.dart';
// import '/utilities/loading_dialog.dart';

class OrderProductsCard extends StatelessWidget {
  final OrderProduct orderProduct;

  OrderProductsCard(this.orderProduct);

  displaySnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // final map = await ProductReview.showReviewDialogBox(
        //   context,
        // );
        // print(map);
        // if (map.isEmpty) {
        //   return;
        // }
        // LoadingDialog.displayLoadingDialog(context, 'Setting review');
        // final resultBool =
        //     await Provider.of<ProductReviewProvider>(context, listen: false)
        //         .postReview(orderProduct.product!.id!, map);
        // Navigator.of(context).pop();
        // if (resultBool) {
        //   displaySnackbar(context, 'Successfully reviewed the product');
        // } else {
        //   displaySnackbar(context, 'Cannot review the product now');
        // }
      },
      child: Card(
        elevation: 0,
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
                    child: orderProduct.product!.images == null
                        ? Text(
                            "No Image",
                            style: Theme.of(context)
                                .appBarTheme
                                .textTheme!
                                .bodyText1,
                          )
                        : Hero(
                            tag: ValueKey(
                                '${orderProduct.product!.id} from orders'),
                            child: Image.memory(
                                orderProduct.product!.images![0]!)),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderProduct.title,
                    style: TextStyle(fontSize: 16),
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '\$${orderProduct.unitPrice}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).buttonColor),
                      ),
                      Text(
                        ' x ${orderProduct.quantity}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  // CartPriceQuantity(cart),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  orderProduct.subTotal,
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                      color: Theme.of(context).buttonColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
