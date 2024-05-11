import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';

class CurrencyProvider with ChangeNotifier {
  List<Currency> _currencies = [];

  List<Currency> get currencies => [..._currencies];

  ApiCalls apiCalls = new ApiCalls();
  fetchCurrencies() async {
    if (_currencies.isNotEmpty) {
      return;
    }
    final encodedResponse = await apiCalls.fetchData(url: currencyUrl);
    if (encodedResponse != null) {
      for (var currency in encodedResponse) {
        _currencies.add(Currency.fromMap(currency));
      }
      _currencies.sort((a, b) => a.name!.compareTo(b.name!));
      notifyListeners();
    }
  }

  Currency? getSelectedCurrency() {
    return _currencies.firstWhereOrNull((currency) => currency.selected == true);
  }

  void selectCountry(Currency currency) async {
    Currency? oldSelectedCurrency = getSelectedCurrency();
    if (oldSelectedCurrency != null) {
      oldSelectedCurrency.selected = false;
    }
    _currencies.sort((a, b) => a.name!.compareTo(b.name!));
    final selectedCurrency =
        _currencies.firstWhere((oldCurrency) => oldCurrency.id == currency.id);
    final countryIndex = _currencies.indexOf(selectedCurrency);
    selectedCurrency.selected = true;
    _currencies.removeAt(countryIndex);
    _currencies.insert(0, selectedCurrency);
    notifyListeners();
  }
}

class Currency {
  String? name;
  String? currencyCode;
  String? displayLocale;
  String? id;
  bool? selected;

  Currency({
    this.name,
    this.currencyCode,
    this.displayLocale,
    this.id,
    this.selected = false,
  });

  Currency.fromMap(dynamic obj) {
    this.name = obj['Name'].toString();
    this.currencyCode = obj['CurrencyCode'].toString();
    this.displayLocale = obj['DisplayLocale'].toString();
    this.id = obj['Id'].toString();
    this.selected = obj['Selected'] ?? false;
  }
}
