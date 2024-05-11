class ProcessPaymentRequest {
  String? orderCode;
  String? storeId;
  String? customerId;
  String? orderGuid;
  double? orderTotal;
  String? paymentMethodSystemName;
  String? creditCardType;
  String? creditCardName;

  String? creditCardNumber;
  int? creditCardExpireYear;
  int? creditCardExpireMonth;
  String? creditCardCvv2;
  bool? isRecurringPayment;

  String? initialOrderId;
  int? recurringCycleLength;
  int? recurringCyclePeriod;
  int? recurringTotalCycles;

  Map<String, dynamic>? customValues;

  ProcessPaymentRequest.fromMap(dynamic obj) {
    print('in processpaymentrequest model $obj');
    this.orderCode = obj['OrderCode'];
    this.storeId = obj['StoreId'];
    this.customerId = obj['CustomerId'];
    this.orderGuid = obj['OrderGuid'];
    this.orderTotal = obj['OrderTotal'].toDouble();
    this.paymentMethodSystemName = obj['PaymentMethodSystemName'];
    this.creditCardType = obj['CreditCardType'];
    this.creditCardName = obj['CreditCardName'];
    this.creditCardNumber = obj['CreditCardNumber'];
    this.creditCardExpireYear = obj['CreditCardExpireYear'].toInt();
    this.creditCardExpireMonth = obj['CreditCardExpireMonth'].toInt();
    this.creditCardCvv2 = obj['CreditCardCvv2'];
    this.isRecurringPayment = obj['IsRecurringPayment'];
    this.initialOrderId = obj['InitialOrderId'];
    this.recurringCycleLength = obj['RecurringCycleLength'].toInt();
    this.recurringCyclePeriod = obj['RecurringCyclePeriod'].toInt();
    this.recurringTotalCycles = obj['RecurringTotalCycles'].toInt();
    this.customValues = obj['CustomValues'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map["OrderCode"] = this.orderCode;
    map["StoreId"] = this.storeId;
    map["CustomerId"] = this.customerId;
    map["OrderGuid"] = this.orderGuid;
    map["OrderTotal"] = this.orderTotal;
    map["PaymentMethodSystemName"] = this.paymentMethodSystemName;
    map["CreditCardType"] = this.creditCardType;
    map["CreditCardName"] = this.creditCardName;
    map["CreditCardNumber"] = this.creditCardNumber;
    map["CreditCardExpireYear"] = this.creditCardExpireYear;
    map["CreditCardExpireMonth"] = this.creditCardExpireMonth;
    map["CreditCardCvv2"] = this.creditCardCvv2;
    map["IsRecurringPayment"] = this.isRecurringPayment;
    map["InitialOrderId"] = this.initialOrderId;
    map["RecurringCycleLength"] = this.recurringCycleLength;
    map["RecurringCyclePeriod"] = this.recurringCyclePeriod;
    map["RecurringTotalCycles"] = this.recurringTotalCycles;
    map["CustomValues"] = this.customValues;

    return map;
  }
}
