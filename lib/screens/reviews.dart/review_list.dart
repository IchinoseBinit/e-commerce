import 'package:e_commerce_app/providers/Reviews.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatefulWidget {
  final String? productId;
  final List<Review> reviews;
  final count;

  ReviewList(this.productId, this.reviews, this.count);

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  // var _isToShowDescription = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductReviewProvider>(
      builder: (context, reviewData, _) {
        return reviewData.getProductReview(widget.productId)!.reviews.isEmpty
            ? SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Theme.of(context).cardTheme.color,
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          // excludeFromSemantics: ,
                          onTap: () {
                            setState(() {
                              reviewData
                                      .getProductReview(widget.productId)!
                                      .reviews[i]
                                      .selected =
                                  !reviewData
                                      .getProductReview(widget.productId)!
                                      .reviews[i]
                                      .selected;
                            });
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                                // height: 80,
                                color: Theme.of(context).cardTheme.color,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  color: Theme.of(context).cardTheme.color,
                                  child: Card(
                                    elevation: 0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            // mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FittedBox(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${reviewData.getProductReview(widget.productId)!.reviews[i].rating}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4!
                                                                  .color,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: Theme.of(context)
                                                            .buttonColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    getProportionateScreenWidth(
                                                        5),
                                              ),
                                              Text(
                                                reviewData
                                                    .getProductReview(
                                                        widget.productId)!
                                                    .reviews[i]
                                                    .title,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline4!
                                                      .color,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                reviewData
                                                    .getProductReview(
                                                        widget.productId)!
                                                    .reviews[i]
                                                    .writtenOn,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // reviewData
                                        //         .getProductReview(
                                        //             widget.productId)
                                        //         .reviews[i]
                                        //         .selected
                                        //     ?
                                        Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  reviewData
                                                              .getProductReview(
                                                                  widget
                                                                      .productId)!
                                                              .reviews[i]
                                                              .helpfulYes! >
                                                          reviewData
                                                              .getProductReview(
                                                                  widget
                                                                      .productId)!
                                                              .reviews[i]
                                                              .helpfulNo!
                                                      ? Icons.thumb_up
                                                      : Icons.thumb_down,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          2),
                                                ),
                                                Text(
                                                  reviewData
                                                              .getProductReview(
                                                                  widget
                                                                      .productId)!
                                                              .reviews[i]
                                                              .helpfulYes! >
                                                          reviewData
                                                              .getProductReview(
                                                                  widget
                                                                      .productId)!
                                                              .reviews[i]
                                                              .helpfulNo!
                                                      ? reviewData
                                                          .getProductReview(
                                                              widget.productId)!
                                                          .reviews[i]
                                                          .helpfulYes
                                                          .toString()
                                                      : reviewData
                                                          .getProductReview(
                                                              widget.productId)!
                                                          .reviews[i]
                                                          .helpfulNo
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .headline4!
                                                          .color,
                                                      fontSize: 14),
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          20),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${reviewData.getProductReview(widget.productId)!.reviews[i].description}',
                                                    maxLines: 15,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline4!
                                                            .color,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        // : SizedBox.shrink(),
                                        // reviewData
                                        //         .getProductReview(
                                        //             widget.productId)
                                        //         .reviews[i]
                                        //         .selected
                                        //     ?
                                        Padding(
                                            padding: EdgeInsets.all(
                                              getProportionateScreenWidth(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Do you find this review helpful?",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          5),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.thumb_up,
                                                    size:
                                                        getProportionateScreenWidth(
                                                      25,
                                                    ),
                                                    color:
                                                        // reviewData
                                                        //             .getProductReview(
                                                        //                 widget
                                                        //                     .productId)
                                                        //             .reviews[i]
                                                        //             .customerId ==
                                                        //         Provider.of<CustomerProvider>(
                                                        //                 context,
                                                        //                 listen:
                                                        //                     false)
                                                        //             .customer
                                                        //             .email
                                                        //     ? Theme.of(context)
                                                        //         .buttonColor
                                                        //     :
                                                        Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                  ),
                                                  onPressed: () async {
                                                    final message = await Provider
                                                            .of<ProductReviewProvider>(
                                                                context,
                                                                listen: false)
                                                        .updateProductHelpfulness(
                                                            widget.productId,
                                                            reviewData
                                                                .getProductReview(
                                                                    widget
                                                                        .productId)!
                                                                .reviews[i]
                                                                .reviewId,
                                                            true);
                                                    if (message.isNotEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            message,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.thumb_down,
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                    size:
                                                        getProportionateScreenWidth(
                                                      25,
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final message = await Provider
                                                            .of<ProductReviewProvider>(
                                                                context,
                                                                listen: false)
                                                        .updateProductHelpfulness(
                                                            widget.productId,
                                                            reviewData
                                                                .getProductReview(
                                                                    widget
                                                                        .productId)!
                                                                .reviews[i]
                                                                .reviewId,
                                                            false);
                                                    if (message.isNotEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            message,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ))
                                        // : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        );
                      },
                      itemCount: widget.count,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
