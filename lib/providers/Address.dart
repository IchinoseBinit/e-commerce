import 'package:e_commerce_app/models/Billing.dart';
import 'package:e_commerce_app/providers/PickUpPoint.dart';
import 'package:e_commerce_app/providers/ShippingMethod.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Addresses with ChangeNotifier {
  List<Address?> _addresses = [];
  List<Address?> _existingAddress = [];

  List<Address?> get addresses => [..._addresses];
  List<Address?> get existingAddresses => [..._existingAddress];

  ApiCalls apiCalls = new ApiCalls();

  fetchExistingAddress() async {
    final response = await apiCalls.fetchData(url: onePageCheckoutUrl);
    final listOfAddresses = response['BillingAddress'];
    // print(listOfAddresses);
    for (var eachBillAddress in listOfAddresses['ExistingAddresses']) {
      _existingAddress.add(Address.fromMap(eachBillAddress));
    }
  }

  Future<void> addAddress(Address address) async {
    // final addAddressUrl = '$customerUrl/($email/AddAddress';
    // address.createdOn = DateTime.now();
    print(customerAddAddressUrl);
    final encodedResponse =
        await apiCalls.postData(customerAddAddressUrl, address.toMap());
    print(encodedResponse);
    print(encodedResponse['Address']);
    print(encodedResponse['Address']['Id']);
    if (encodedResponse != null) {
      address.id = encodedResponse['Address']['Id'];
      _addresses.add(address);
      if (existingAddresses.isNotEmpty) {
        _existingAddress.add(address);
      }
    }

    notifyListeners();
  }

  Address? getSelectedAddress() {
    return _addresses.first;
  }

  void selectAddress(String? addressId) {
    Address? toSelectAddress = findById(addressId);
    int toSelectAddressIndex = _addresses.indexOf(toSelectAddress);
    _existingAddress.removeAt(toSelectAddressIndex);
    _existingAddress.insert(0, toSelectAddress);
    notifyListeners();
  }

  void fetchAddresses(List<Address?> addressList) {
    _addresses = addressList;
    notifyListeners();
  }

  Future<void> saveBilling(BuildContext context, bool shipToSameAddress) async {
    // final address_id = ;
    final billObj =
        Billing.fromAddress(getSelectedAddress()!, shipToSameAddress);
    final response =
        await apiCalls.postData(opcSaveBillingUrl, billObj.toMap());
    print(response);
    if (response['Success'] == false) {
      print(response['Message']);
      return;
    }
    if (shipToSameAddress) {
      Provider.of<ShippingMethodProvider>(context, listen: false)
          .addShippingMethods(response);
    } else {
      Provider.of<PickUpPointProvider>(context, listen: false)
          .addPickUpPoints(response);
    }
  }

  Future<void> updateAddress(Address newAddress) async {
    final addressIndex =
        _addresses.indexWhere((address) => address!.id == newAddress.id);
    final existingAddress = _addresses[addressIndex]!;
    _addresses[addressIndex] = newAddress;
    // call the http method to update address
    final updateAddressUrl =
        '$customerEditAddressUrl?addressId=${existingAddress.id}';
    final response =
        await apiCalls.postData(updateAddressUrl, newAddress.toMap());
    print(response);
    // here no response and the index to replace is not given
    if (response == null) {
      _addresses[addressIndex] = existingAddress;
    }
    notifyListeners();
  }

  Future<dynamic> deleteAddress(String? addressId) async {
    final toBeRemovedAddressIndex =
        _addresses.indexWhere((address) => address!.id == addressId);
    final toBeRemovedAddress = _addresses[toBeRemovedAddressIndex]!;
    _addresses.removeAt(toBeRemovedAddressIndex);
    final deleteAddressUrl =
        '$customerDeleteAddressUrl?addressId=${toBeRemovedAddress.id}';
    print(deleteAddressUrl);
    final response = await apiCalls.postData(deleteAddressUrl, []);
    print(response);
    if (response == null) {
      _addresses.insert(toBeRemovedAddressIndex, toBeRemovedAddress);
      notifyListeners();
      return 'Could not delete the address';
    }
    _existingAddress = _addresses;
    notifyListeners();
    return "Successfully Deleted the address";
  }

  Address? findById(String? addressId) {
    final address = _addresses.firstWhere((address) => address!.id == addressId,
        orElse: () => null);
    return address;
  }
}

class Address {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryId;
  String? stateProvinceId;
  String? city;
  String? address1;
  String? zipPostalCode;
  String? phoneNumber;
  DateTime? createdOn;

  Address({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.countryId,
    this.stateProvinceId,
    this.city,
    this.address1,
    this.zipPostalCode,
    this.phoneNumber,
    this.createdOn,
  });

  Address.fromMap(dynamic obj) {
    this.id = obj['Id'];
    this.firstName = obj['FirstName'];
    this.lastName = obj['LastName'];
    this.email = obj['Email'];
    this.countryId = obj['CountryId'];
    this.stateProvinceId = obj['StateProvinceId'];
    this.city = obj['City'];
    this.address1 = obj['Address1'];
    this.zipPostalCode = obj['ZipPostalCode'];
    this.phoneNumber = obj['PhoneNumber'];
    if (obj['CreatedOnUtc'] != null) {
      this.createdOn = DateTime.parse(obj['CreatedOnUtc']);
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    // map['id'] = this.id;
    map['addressAttributes'] = {};
    map['firstName'] = this.firstName;
    map['lastName'] = this.lastName;
    map['email'] = this.email;
    map['countryId'] = this.countryId;
    map['stateProvinceId'] = this.stateProvinceId;
    map['city'] = this.city;
    map['address1'] = this.address1;
    map['zipPostalCode'] = this.zipPostalCode;
    map['phoneNumber'] = this.phoneNumber;

    return map;
  }
}
