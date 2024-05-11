import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/models/ProcessPaymentRequest.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';

class PaymentMethodProvider with ChangeNotifier {
  List<PaymentMethod> _paymentMethods = [];

  List<PaymentMethod> get paymentMethods => [..._paymentMethods];

  ApiCalls apiCalls = new ApiCalls();

  Future<List<PaymentMethod>> fetchPaymentMethods() async {
    return paymentMethods;
  }

  addPaymentMethods(dynamic response) async {
    print(response);
    if (_paymentMethods.isEmpty) {
      final listOfPaymentMethods =
          response['update_section']['model']['PaymentMethods'];

      for (var eachPaymentMethod in listOfPaymentMethods) {
        _paymentMethods.add(PaymentMethod.fromMap(eachPaymentMethod));
      }
      print(_paymentMethods);
    }
  }

  PaymentMethod? getSelectedPaymentMethod() {
    PaymentMethod? paymentMethods = _paymentMethods.firstWhereOrNull(
        (paymentMethod) => paymentMethod.isSelected == true);
    return paymentMethods;
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    PaymentMethod? oldPaymentMethod = getSelectedPaymentMethod();
    if (oldPaymentMethod != null) {
      oldPaymentMethod.isSelected = false;
    }
    final selectedPaymentMethod = _paymentMethods.firstWhere(
        (paymentMethods) => paymentMethods.name == paymentMethod.name);
    selectedPaymentMethod.isSelected = true;
    notifyListeners();
  }

  Future<bool> savePaymentMethod(BuildContext context) async {
    final response = await apiCalls.postData(
        opcSavePaymentMethodUrl, getSelectedPaymentMethod()!.toMap());
    print(response);
    if (response != null) {
      print(opcSavePaymentInfoUrl);
      final responseFromInfo =
          await apiCalls.postFormData(opcSavePaymentInfoUrl, null);
      print('This is $responseFromInfo');

      if (responseFromInfo['paymentInfo'] != null) {
        print(
            'this is the payment info response ${responseFromInfo['paymentInfo']}');
        final processPaymentObj =
            ProcessPaymentRequest.fromMap(responseFromInfo['paymentInfo']);
        final responseFromConfirmOrder = await apiCalls.postData(
            opcConfirmOrderUrl, processPaymentObj.toMap());
        if (responseFromConfirmOrder['Success'] == true) {
          return true;
        }
        return false;
      }
    }
    return false;
  }
}

class PaymentMethod {
  String? methodType;
  String? name;
  bool? isSelected;
  // String

  PaymentMethod.fromMap(dynamic obj) {
    this.methodType = obj['PaymentMethodSystemName'].toString();
    this.name = obj['Name'].toString();
    this.isSelected = false;
  }

  Map<String, String> toMap() {
    Map<String, String> map = new Map();
    map['paymentMethod'] = this.methodType.toString();

    return map;
  }
}
