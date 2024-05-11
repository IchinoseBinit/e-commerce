import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:e_commerce_app/urls.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProductReviewProvider with ChangeNotifier {
  List<ProductReview> _productReviews = [];

  List<ProductReview> get productReviews => [..._productReviews];

  ApiCalls apiCalls = new ApiCalls();

  addReview(String? productId) async {
    final hiveReviews = await Hive.openBox('ProductReviews');
    final productReviewUrl = '$fetchProductReviewsUrl?productId=$productId';
    print(hiveReviews.get(productId));
    print(productReviewUrl);
    if (hiveReviews.get(productId) == null) {
      final response = await _addReview(productReviewUrl);
      if (response != null) {
        _productReviews.add(ProductReview.fromJson(response));
        await hiveReviews.put(productId, response);
      }
    }
    if (hiveReviews.isNotEmpty) {
      final review = hiveReviews.get(productId);
      if (review != null) {
        print(review);
        _productReviews.add(ProductReview.fromJson(review));
        _addReview(productReviewUrl).then((res) {
          if (res == null) {
            return;
          }
          _productReviews
              .removeWhere((prodReview) => prodReview.productId == productId);
          _productReviews.add(ProductReview.fromJson(res));
          hiveReviews.put(productId, res);
        });
      } else {
        final response = await _addReview(productReviewUrl);
        if (response != null) {
          _productReviews.add(ProductReview.fromJson(response));
          await hiveReviews.put(productId, response);
        }
      }
    } else {
      final response = await _addReview(productReviewUrl);
      if (response != null) {
        _productReviews.add(ProductReview.fromJson(response));
        await hiveReviews.put(productId, response);
      }
    }
  }

  postReview(String productId, dynamic obj) async {
    final url = '$setProductReview?productId=$productId';
    print(url);
    print(obj);
    final response = await apiCalls.postData(url, obj);
    if (response == 401) {
      return false;
    }
    print(response);
    if (response != null) {
      final productReview = getProductReview(productId);
      if (productReview != null) {
        _productReviews.remove(productReview);
      }
      return true;
    }
    return false;
  }

  Future<dynamic> _addReview(dynamic url) async {
    try {
      await InternetAddress.lookup('example.com');
      final encodedResponse = await apiCalls.fetchData(url: url);
      return encodedResponse;
    } on SocketException catch (_) {
      return null;
    }
  }

  ProductReview? getProductReview(String? productId) {
    return _productReviews.firstWhereOrNull(
        (productReview) => productReview.productId == productId);
  }

  Future<String> updateProductHelpfulness(
      String? productId, String? reviewId, bool wasHelpful) async {
    final reviewInstance = getProductReview(productId)!.getReview(reviewId);
    final url =
        '$setProducthelpfulnessUrl?productReviewId=$reviewId&productId=$productId&washelpful=$wasHelpful';
    final encodedResponse = await apiCalls.postData(url, null);
    var message = '';
    if (encodedResponse != null) {
      print(encodedResponse);
      message = encodedResponse['Result'];
      reviewInstance.helpfulYes = encodedResponse['TotalYes'] == null
          ? 1
          : encodedResponse['TotalYes'].toInt();
      reviewInstance.helpfulNo = encodedResponse['TotalNo'] == null
          ? 0
          : encodedResponse['TotalNo'].toInt();
    }
    notifyListeners();
    return message;
  }
}

class ProductReview {
  String? productId;
  List<Review> reviews = [];

  ProductReview.fromJson(dynamic obj) {
    this.productId = obj['ProductId'].toString();
    for (var eachReview in obj['Items']) {
      reviews.add(Review.fromJson(eachReview));
    }
  }

  Review getReview(String? reviewId) {
    return reviews.firstWhere((review) => review.reviewId == reviewId,
        orElse: null);
  }
}

class Review {
  String? reviewId;
  String? customerId;
  String? customerName;
  late String title;
  String? description;
  double? rating;
  late String writtenOn;
  int? helpfulYes;
  int? helpfulNo;
  late bool selected;

  Review.fromJson(dynamic obj) {
    this.reviewId = obj['Id'].toString();
    this.customerId = obj['CustomerId'].toString();
    this.customerName = obj['CustomerName'].toString();
    this.title = obj['Title'].toString();
    this.description = obj['ReviewText'].toString();
    this.rating = obj['Rating'].toDouble();
    this.helpfulYes = obj['Helpfulness']['HelpfulYesTotal'].toInt();
    this.helpfulNo = obj['Helpfulness']['HelpfulNoTotal'].toInt();
    this.writtenOn = obj['WrittenOnStr'].toString();
    this.selected = false;
  }
}
