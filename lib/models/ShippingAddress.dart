import 'package:e_commerce_app/providers/PaymentMethod.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ShippingAddress {
  Map<String, String>? addressAttributes;
  bool? pickUpInStore;
  String? pickUpPointId;
  String? shippingAddressId;
  String? shippingId;
  String? shippingFirstName;
  String? shippingLastName;
  String? shippingEmail;
  String? shippingCompany;
  String? shippingCountryId;
  String? shippingStateProvinceId;
  String? shippingCity;
  String? shippingAddress1;
  String? shippingZipPostalCode;
  String? shippingPhoneNumber;

  ShippingAddress({
    this.addressAttributes,
    this.pickUpInStore,
    this.pickUpPointId,
    this.shippingAddressId,
    this.shippingId,
    this.shippingFirstName,
    this.shippingLastName,
    this.shippingEmail,
    this.shippingCompany,
    this.shippingCountryId,
    this.shippingStateProvinceId,
    this.shippingCity,
    this.shippingAddress1,
    this.shippingZipPostalCode,
    this.shippingPhoneNumber,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();

    map["addressAttributes"] = this.addressAttributes;
    map["pickUpInStore"] = this.pickUpInStore;
    map["pickUpPointId"] = this.pickUpPointId;
    map["shippingAddressId"] = '';
    map["shippingId"] = '';
    map["shippingFirstName"] = this.shippingFirstName;
    map["shippingLastName"] = this.shippingLastName;
    map["shippingEmail"] = this.shippingEmail;
    map["shippingCompany"] = this.shippingCompany == null;
    map["shippingCountryId"] = this.shippingCountryId;
    map["shippingStateProvinceId"] = this.shippingStateProvinceId;
    map["shippingCity"] = this.shippingCity;
    map["shippingAddress1"] = this.shippingAddress1;
    map["shippingAddress2"] = '';
    map["shippingZipPostalCode"] = this.shippingZipPostalCode;
    map["shippingPhoneNumber"] = this.shippingPhoneNumber;

    return map;
  }

  ApiCalls apiCalls = new ApiCalls();
  postData(BuildContext context, ShippingAddress obj) async {
    final response = await apiCalls.postData(opcSaveShippingUrl, obj.toMap());
    if (obj.pickUpInStore!) {
      Provider.of<PaymentMethodProvider>(context, listen: false)
          .addPaymentMethods(response);
    }
  }
}
