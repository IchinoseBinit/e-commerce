import 'package:e_commerce_app/providers/Reviews.dart';
import 'package:e_commerce_app/screens/reviews.dart/review_list.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewScreen extends StatelessWidget {
  final ratings = [
    [
      'Wow splendind',
      '11 Nov 2020',
      'Ramesh Prasain',
      'Black',
      4.5,
      'One of the best product ever seen just loved it.',
      'assets/images/tshirt.png',
      false
    ],
    [
      'So good',
      '21 Dec 2020',
      'Ram Shrestha',
      'White',
      3.5,
      'Thanks for sending such an amazing product at my doorstep at right time.',
      'assets/images/wireless headset.png',
      false
    ],
    [
      'Bad quality',
      '15 Jan 2021',
      'Shyam Gurung',
      'White',
      1.5,
      'Very dissappointed with the product. The build quality is not furnished and very late delivery',
      'assets/images/shoes2.png',
      false
    ],
  ];
  static const routeName = '/reviews';
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> productArguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final productId = productArguments['id'];
    final productRating = productArguments['rating'].toDouble();
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      body: SingleChildScrollView(
        child: Consumer<ProductReviewProvider>(
          builder: (context, reviewData, _) {
            final productReviews =
                reviewData.getProductReview(productId)!.reviews;
            return productReviews.isEmpty
                ? Container(
                    child: Center(
                      child: Text("No reviews found"),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenHeight(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ratings and Reviews (${productReviews.length})",
                              // widget.product.title,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(18)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              child: Text(
                                'Average Ratings: ${productRating.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            FittedBox(
                              child: RatingBar.builder(
                                initialRating: productRating,
                                itemSize: getProportionateScreenWidth(20),
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ignoreGestures: true,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Theme.of(context).buttonColor,
                                ),
                                onRatingUpdate: (_) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      ReviewList(
                          productId, productReviews, productReviews.length),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
