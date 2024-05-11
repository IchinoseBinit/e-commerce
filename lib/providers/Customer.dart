import 'dart:io';
import 'dart:math';

import 'package:e_commerce_app/models/PasswordModel.dart';
import 'package:e_commerce_app/providers/Address.dart';
import 'package:e_commerce_app/providers/Country.dart';
import 'package:e_commerce_app/providers/WishList.dart';
import 'package:e_commerce_app/providers/Cart.dart';
import 'package:e_commerce_app/providers/User.dart';
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:e_commerce_app/utilities/database_connector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerProvider with ChangeNotifier {
  Customer? _customer;

  Customer? get customer => _customer;

  ApiCalls apiCalls = new ApiCalls();

  removeCustomer() {
    _customer = null;
    notifyListeners();
  }

  Future<dynamic> fetchDetails(context) async {
    final email = MySharedPreferences.sharedPreferences.getString('email');
    print(email);

    // await MySharedPreferences.sharedPreferences
    //     .setString('url', 'http://google.com');
    // print();
    // baseUrl = MySharedPreferences.sharedPreferences.get('url');
    if (email == null) {
      return 'splash';
    }
    print("my name is this");
    try {
      await InternetAddress.lookup('example.com');
    } on SocketException catch (_) {
      return 'noInternet';
    }
    final customer =
        await apiCalls.fetchData(url: customerUrl, context: context);

    // get 401 status code when the token is expired
    if (customer == 401) {
      return 'splash';
    }
    if (customer == 403) {
      return 'splash';
    }
    print(customer);

    if (customer != null) {
      print("Hi");
      // var id = customer['Id'];
      String fullname = '';
      if (customer['FirstName'] != null || customer['LastName'] != null) {
        if (customer['FirstName'] != null) {
          fullname = customer['FirstName'];
        }
        if (customer['LastName'] != null) {
          fullname += customer['LastName'];
        }
      }
      Provider.of<CustomerProvider>(context, listen: false)
          .fetchCustomer(Customer.fromMap(customer));
      if (customer['CountryId'] != null) {
        Provider.of<CountryProvider>(context, listen: false)
            .addCountry(customer['CountryId']);
      }
      var id = Random().nextInt(10).toString();
      User user = new User(id, fullname);
      ConnectDatabase connectDatabase = new ConnectDatabase();
      connectDatabase.addUser(user);
      // List addresses = customer['Addresses'];
      final addressResponse =
          await apiCalls.fetchData(url: customerAddressesUrl);
      print(cartCountUrl);
      final countResponse = await apiCalls.fetchData(url: cartCountUrl);

      print(countResponse);
      if (countResponse != null) {
        // print(countResponse['WishListCount']);
        Provider.of<WishListProvider>(context, listen: false).wishListCount =
            countResponse['WishListCount'];
        Provider.of<CartProvider>(context, listen: false).cartCount =
            countResponse['CartCount'];
        // print(countResponse['CartCount']);
      }
      List addresses = addressResponse['Addresses'];

      List<Address?> listAddress = [];
      for (dynamic address in addresses) {
        listAddress.add(Address.fromMap(address));
      }

      Provider.of<Addresses>(context, listen: false)
          .fetchAddresses(listAddress);
      notifyListeners();
    } else {
      return 'logout';
    }
  }

  void fetchCustomer(Customer cust) {
    _customer = cust;
    notifyListeners();
  }

  Future<dynamic> updateCustomerPassword(
      String oldPassword, String newPassword) async {
    final response = await apiCalls.postData(
      customerChangePasswordUrl,
      PasswordModel.changePassword(
        oldPassword: oldPassword,
        password: newPassword,
      ).toChangePasswordMap(),
    );
    print("this is");
    print(response);
    if (response != 401) {
      return response['Success'] == true ? true : response['Errors'];
    } else {
      return response;
    }
  }

  forgotPassword(String email) async {
    final response = await apiCalls.postData(
      customerPasswordRecoveryUrl,
      PasswordModel.passwordRecovery(email: email).toPasswordRecoveryMap(),
    );
    if (response != null) {
      return true;
    }
    return false;
  }

  recoverPassword(
    String token,
    String email,
    String password,
  ) async {
    final url = '$customerPasswordRecoveryConfirmUrl?token=$token&email=$email';
    print(url);
    print(PasswordModel.confirmPasswordRecovery(
      password: password,
    ).toConfirmPasswordMap());
    final response = await apiCalls.postData(
      url,
      PasswordModel.confirmPasswordRecovery(
        password: password,
      ).toConfirmPasswordMap(),
    );
    if (response != 401) {
      return response['Success'] == true ? true : response['Errors'];
    } else {
      return response;
    }
  }

  Future<void> updateCustomer(Customer newCustomer,
      GlobalKey<ScaffoldState> scaff, BuildContext context) async {
    // call the http method to update address
    final updateCustomerUrl = '$customerUrl';

    final response =
        await apiCalls.postData(updateCustomerUrl, newCustomer.toMap());
    print(response);
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).textTheme.headline4!.color,
          content: Text(
            'Cannot update profile currently',
            textAlign: TextAlign.center,
          ),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).textTheme.headline4!.color,
          content: Text(
            'Successfully updated',
            textAlign: TextAlign.center,
          ),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
    }
    notifyListeners();
  }
}

class Customer {
  // String id;
  // String customerGuId;
  String? userName;
  String? email;
  String? phoneNumber;
  String? gender;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? countryId;

  Customer({
    // this.id,
    // this.customerGuId,
    this.userName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.countryId,
  });

  Customer.fromMap(dynamic obj) {
    // this.id = obj['Id'];
    // this.customerGuId = obj['CustomerGuid'];
    this.userName = obj['Username'];
    this.email = obj['Email'];
    this.phoneNumber = obj['Phone'];
    this.gender = obj['Gender'];
    this.firstName = obj['FirstName'];
    this.lastName = obj['LastName'];
    this.dateOfBirth = obj['DateOfBirth'];
    this.countryId = obj['CountryId'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();

    map['addressAttributes'] = {};
    map['email'] = this.email;
    map['firstName'] = this.firstName;
    map['lastName'] = this.lastName;
    map['newsLetter'] = true;

    return map;
  }

  Map<String, dynamic> toMapWithMoreData() {
    Map<String, dynamic> map = Map();
    // map['id'] = this.id;
    // map['customerGuid'] = this.customerGuId;
    map["allowUsersToChangeEmail"] = true;
    map["checkUsernameAvailabilityEnabled"] = true;
    map["allowUsersToChangeUsernames"] = true;
    map["usernamesEnabled"] = true;
    map["genderEnabled"] = true;
    map["dateOfBirthEnabled"] = true;
    map['username'] = this.userName;
    map['addressAttributes'] = {};
    map['email'] = this.email;
    map['phone'] = this.phoneNumber;
    map['gender'] = this.gender;
    map['firstName'] = this.firstName;
    map['lastName'] = this.lastName;
    map['newsLetter'] = true;
    map['dateOfBirthDay'] = this.dateOfBirth!.substring(8, 10);
    map['dateOfBirthMonth'] = this.dateOfBirth!.substring(5, 7);
    map['dateOfBirthYear'] = this.dateOfBirth!.substring(0, 4);
    map["dateOfBirthRequired"] = true;
    map['countryId'] = this.countryId;

    return map;
  }
}
