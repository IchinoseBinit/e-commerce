import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/providers/PaymentMethod.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ShippingMethodProvider with ChangeNotifier {
  List<ShippingMethod> _shippingMethods = [];

  List<ShippingMethod> get shippingMethods => [..._shippingMethods];

  ApiCalls apiCalls = new ApiCalls();

  fetchShippingMethods() async {
    return shippingMethods;
  }

  addShippingMethods(dynamic response) async {
    if (_shippingMethods.isEmpty) {
      final listOfShippingMethods =
          response['update_section']['model']['ShippingMethods'];

      for (var eachShippingMethod in listOfShippingMethods) {
        _shippingMethods.add(ShippingMethod.fromMap(eachShippingMethod));
      }
      print(_shippingMethods);
    }
  }

  ShippingMethod? getSelectedShippingMethod() {
    ShippingMethod? shippingMethods = _shippingMethods.firstWhereOrNull(
        (shippingMethod) => shippingMethod.selected == true);
    return shippingMethods;
  }

  void selectShippingMethod(ShippingMethod shippingMethod) {
    ShippingMethod? oldShippingMethod = getSelectedShippingMethod();
    if (oldShippingMethod != null) {
      oldShippingMethod.selected = false;
    }
    // _shippingMethods.sort((a, b) => a.name.compareTo(b.name));
    ShippingMethod selectedShippingMethod = _shippingMethods.firstWhere(
        (shippingMethods) => shippingMethods.value == shippingMethod.value);
    selectedShippingMethod.selected = true;
    notifyListeners();
  }

  Future<void> saveShippingMethod(BuildContext context) async {
    final response = await apiCalls.postData(
        opcSaveShippingMethodUrl, getSelectedShippingMethod()!.toMap());
    await Provider.of<PaymentMethodProvider>(context, listen: false)
        .addPaymentMethods(response);
  }
}

class ShippingMethod {
  String? methodSystemName;
  String? value;
  bool? selected;

  ShippingMethod({
    this.methodSystemName,
    this.value,
    this.selected = false,
  });

  ShippingMethod.fromMap(dynamic obj) {
    this.methodSystemName =
        obj['ShippingRateComputationMethodSystemName'].toString();
    this.value = obj['Name'].toString();
    this.selected = false;
  }

  Map<String, String?> toMap() {
    Map<String, String?> map = new Map();
    map['shippingOption'] = this.methodSystemName;
    map['value'] = this.value;

    return map;
  }
}
