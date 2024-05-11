import 'package:e_commerce_app/providers/Address.dart';

class Billing {
  bool? shipToSameAddress;
  String? billingAddressId;
  String? newId;
  String? newFirstName;
  String? newLastName;
  String? newEmail;
  String? newCompany;
  String? newCountryId;
  String? newStateProvinceId;
  String? newCity;
  String? newAddress1;
  String? newAddress2;
  String? newZipPostalCode;
  String? newPhoneNumber;

  Billing({
    this.shipToSameAddress,
    this.billingAddressId,
    this.newId,
    this.newFirstName,
    this.newLastName,
    this.newEmail,
    this.newCompany,
    this.newCountryId,
    this.newStateProvinceId,
    this.newCity,
    this.newAddress1,
    this.newAddress2,
    this.newZipPostalCode,
    this.newPhoneNumber,
  });

  Billing.fromAddress(Address address, bool shipToSame) {
    this.billingAddressId = address.id;
    this.shipToSameAddress = shipToSame;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map['shipToSameAddress'] = this.shipToSameAddress;
    map['billingAddressId'] = this.billingAddressId;
    map['newFirstName'] = this.newFirstName;
    map['newLastName'] = this.newLastName;
    map['newEmail'] = this.newEmail;
    map['newCompany'] = this.newCompany;
    map['newCountryId'] = this.newCountryId;
    map['newStateProvinceId'] = this.newStateProvinceId;
    map['newCity'] = this.newCity;
    map['newAddress1'] = this.newAddress1;
    map['newAddress2'] = this.newAddress2;
    map['newZipPostalCode'] = this.newZipPostalCode;
    map['newPhoneNumber'] = this.newPhoneNumber;

    return map;
  }
}
