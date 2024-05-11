class ActionCart {
  String? cartItemId;
  double? customerEnteredPrice;
  int? quantity;
  String? reservationId;
  DateTime? reservationDateFrom;
  DateTime? reservationDateTo;
  String? warehouseId;
  Map<String, String>? productAttribute;
  String? giftCardReceipentName;
  String? giftCardReceipentEmail;
  String? giftCardSenderName;
  String? giftCardSenderEmail;
  String? message;

  ActionCart.fromJson(dynamic obj) {
    this.cartItemId = obj['cartItemId'];
    this.customerEnteredPrice = obj['customerEnteredPrice'].toDouble();
    this.quantity = obj['quantity'].toInt();
    this.reservationId = obj['reservationId'];
    this.reservationDateFrom = DateTime.parse(obj['reservationDateFrom']);
    this.reservationDateTo = DateTime.parse(obj['reservationDateTo']);
    this.warehouseId = obj['warehouseId'];
    this.productAttribute = obj['productAttribute'];
    this.giftCardReceipentName = obj['giftCardReceipentName'];
    this.giftCardReceipentEmail = obj['giftCardReceipentEmail'];
    this.giftCardSenderName = obj['giftCardSenderName'];
    this.giftCardSenderEmail = obj['giftCardSenderEmail'];
    this.message = obj['message'];
  }

  ActionCart({
    this.cartItemId,
    this.customerEnteredPrice,
    this.quantity,
    this.reservationId,
    this.reservationDateFrom,
    this.reservationDateTo,
    this.warehouseId,
    this.productAttribute,
    this.giftCardReceipentName,
    this.giftCardReceipentEmail,
    this.giftCardSenderName,
    this.giftCardSenderEmail,
    this.message,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map['cartItemId'] = this.cartItemId ?? "";
    map['customerEnteredPrice'] = this.customerEnteredPrice ?? "";
    map['quantity'] = this.quantity ?? 1;
    map['reservationId'] = this.reservationId ?? "";
    map['reservationDateFrom'] = this.reservationDateFrom ?? "";
    map['reservationDateTo'] = this.reservationDateTo ?? "";
    map['warehouseId'] = this.warehouseId ?? "";
    map['productAttribute'] = this.productAttribute;
    map['giftCardReceipentName'] = this.giftCardReceipentName ?? "";
    map['giftCardReceipentEmail'] = this.giftCardReceipentEmail ?? "";
    map['giftCardSenderName'] = this.giftCardSenderName ?? "";
    map['giftCardSenderEmail'] = this.giftCardSenderEmail ?? "";
    map['message'] = this.message ?? "";

    return map;
  }
}
