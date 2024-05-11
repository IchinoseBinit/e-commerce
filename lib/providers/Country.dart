import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';

class CountryProvider with ChangeNotifier {
  List<Country> _countries = [];

  List<Country> get states => [..._countries];

  ApiCalls apiCalls = new ApiCalls();
  fetchCountries() async {
    if (_countries.length > 10) {
      return;
    }
    final encodedResponse = await apiCalls.fetchData(url: countryUrl);
    print(encodedResponse);
    if (encodedResponse != null) {
      for (var country in encodedResponse) {
        // checking if the country is already added by calling the addCountry method from signin
        if (_countries.isNotEmpty) {
          bool toAdd = true;
          _countries.forEach((x) {
            if (x.id == country['Id']) {
              toAdd = false;
            }
          });
          if (toAdd) {
            _countries.add(Country.fromMap(country));
          }
        } else {
          // if the list is empty start adding as there is no chance of duplication.
          _countries.add(Country.fromMap(country));
        }
      }
      _countries.sort((a, b) => a.name!.compareTo(b.name!));
      final countryIndex = _countries.indexWhere(
        (a) => a.selected == true,
      );
      if (countryIndex >= 0) {
        final country = _countries[countryIndex];
        _countries.removeAt(countryIndex);
        _countries.insert(0, country);
      }

      notifyListeners();
    }
  }

  Future<void> addCountry(String? id) async {
    final fetchCountryUrl = '$countryUrl/$id';
    final countryResponse = await apiCalls.fetchData(url: fetchCountryUrl);
    final country = Country.fromMap(countryResponse);
    country.selected = true;
    _countries.add(country);
    notifyListeners();
  }

  Country? getSelectedCountry() {
    Country? selectedCountry = _countries
        .firstWhereOrNull((country) => country.selected == true);
    return selectedCountry;
  }

  void selectCountry(String? countryId) async {
    bool toAdd = true;
    if (_countries.isEmpty) {
      await addCountry(countryId);
      return;
    } else {
      _countries.forEach((x) async {
        if (x.id == countryId) {
          toAdd = false;
        }
      });
    }
    if (toAdd) {
      await addCountry(countryId);
      return;
    }
    Country? oldSelectedCountry = getSelectedCountry();
    if (oldSelectedCountry != null) {
      oldSelectedCountry.selected = false;
    }
    _countries.sort((a, b) => a.name!.compareTo(b.name!));
    final selectedCountry = _countries.firstWhereOrNull(
        (oldCountry) => oldCountry.id == countryId);
    if (selectedCountry != null) {
      final countryIndex = _countries.indexOf(selectedCountry);
      selectedCountry.selected = true;
      _countries.removeAt(countryIndex);
      _countries.insert(0, selectedCountry);
      notifyListeners();
    }
  }

  void disSelectCountry() {
    _countries.forEach((x) => x.selected = false);
  }
}

class Country {
  String? id;
  String? name;
  int? numericIsoCode;
  String? threeLetterIsoCode;
  bool? selected;

  Country({
    this.id,
    this.name,
    this.numericIsoCode,
    this.threeLetterIsoCode,
    this.selected = false,
  });

  Country.fromMap(dynamic obj) {
    this.id = obj['Id'].toString();
    this.name = obj['Name'].toString();
    this.numericIsoCode = obj['NumericIsoCode'].toInt();
    this.threeLetterIsoCode = obj['ThreeLetterIsoCode'].toString();
    this.selected = false;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['Id'] = this.id;
    map['Name'] = this.name;
    map['NumericIsoCode'] = this.numericIsoCode;
    map['ThreeLetterIsoCode'] = this.threeLetterIsoCode;
    return map;
  }
}
