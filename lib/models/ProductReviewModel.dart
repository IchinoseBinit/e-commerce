class ProductReviewModel {
  late String title;
  late String description;
  late int rating;

  ProductReviewModel(
    this.title,
    this.description,
    this.rating,
  );

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();

    final attributes = {
      'title': this.title,
      'reviewText': this.description,
      'rating': this.rating,
    };

    map['addProductReview'] = attributes;

    return map;
  }
}
