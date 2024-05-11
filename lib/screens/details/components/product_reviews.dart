import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/providers/Reviews.dart';
import 'package:e_commerce_app/screens/reviews.dart/review_list.dart';
import 'package:e_commerce_app/screens/reviews.dart/reviews.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductReviews extends StatefulWidget {
  final Product? product;

  ProductReviews(this.product);

  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  Future? future;

  @override
  void initState() {
    future = Provider.of<ProductReviewProvider>(context, listen: false)
        .addReview(widget.product!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, reviewData) {
        if (reviewData.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Consumer<ProductReviewProvider>(
          builder: (context, reviews, _) {
            return reviews.getProductReview(widget.product!.id) == null
                ? Container(
                    height: 100,
                    child: Text(
                      "Cannot fetch the ratings at the moment)",
                      // widget.product.title,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  )
                : reviews.getProductReview(widget.product!.id)!.reviews.isEmpty
                    ? Container(
                        height: 100,
                        child: Text(
                          "Ratings and Reviews (${reviews.getProductReview(widget.product!.id)!.reviews.length})",
                          // widget.product.title,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenHeight(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ratings and Reviews (${reviews.getProductReview(widget.product!.id)!.reviews.length})",
                                  // widget.product.title,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                GestureDetector(
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).buttonColor,
                                    ),
                                  ),
                                  onTap: () {
                                    var productArguments =
                                        Map<String, dynamic>();
                                    productArguments['id'] = widget.product!.id;
                                    productArguments['rating'] =
                                        widget.product!.rating;

                                    Navigator.pushNamed(
                                        context, ReviewScreen.routeName,
                                        arguments: productArguments);
                                  },
                                )
                              ],
                            ),
                          ),
                          ReviewList(
                              widget.product!.id,
                              reviews
                                  .getProductReview(widget.product!.id)!
                                  .reviews,
                              reviews
                                          .getProductReview(widget.product!.id)!
                                          .reviews
                                          .length >
                                      2
                                  ? 2
                                  : reviews
                                      .getProductReview(widget.product!.id)!
                                      .reviews
                                      .length),
                        ],
                      );
          },
        );
      },
    );
  }
}
