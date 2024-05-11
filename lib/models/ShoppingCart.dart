class ShoppingCart {
  Map<String, int?>? cartProducts;
  Map<String?, String?>? cartAttributes;
  String? giftCardCouponCode;
  String? discountCouponCode;
  String? countryId;
  String? stateProvinceId;
  String? zipPostalCode;

  ShoppingCart({
    this.cartProducts,
    this.cartAttributes,
    this.giftCardCouponCode,
    this.discountCouponCode,
    this.countryId,
    this.stateProvinceId,
    this.zipPostalCode,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();

    map['cartProducts'] = this.cartProducts;
    map['cartAttributes'] = this.cartAttributes;
    map['giftCardCouponCode'] = this.giftCardCouponCode;
    map['discountCouponCode'] = this.discountCouponCode;
    map['countryId'] = this.countryId;
    map['stateProvinceId'] = this.stateProvinceId;
    map['zipPostalCode'] = this.zipPostalCode;

    return map;
  }
}
