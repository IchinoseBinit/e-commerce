import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';

class StatesProvider with ChangeNotifier {
  List<States> _states = [];

  List<States> get states => [..._states];

  ApiCalls apiCalls = new ApiCalls();
  fetchStates() async {
    if (_states.length > 10) {
      return;
    }

    await _callFromApi();
    notifyListeners();
  }

  _callFromApi() async {
    final encodedResponse = await apiCalls.fetchData(url: stateUrl);
    print(encodedResponse);
    if (encodedResponse != null) {
      dynamic stateList = encodedResponse;
      for (var state in stateList) {
        // checking if the state is already added by calling the addState method from signin
        if (_states.isNotEmpty) {
          bool toAdd = true;
          _states.forEach((x) {
            if (x.id == state['Id']) {
              toAdd = false;
            }
          });
          if (toAdd) {
            _states.add(States.fromMap(state));
          }
        } else {
          // if the list is empty start adding as there is no chance of duplication.
          _states.add(States.fromMap(state));
        }
      }
      _states.sort((a, b) => a.name!.compareTo(b.name!));

      _states.sort((a, b) => a.name!.compareTo(b.name!));
      final stateIndex = _states.indexWhere(
        (a) => a.selected == true,
      );
      if (stateIndex >= 0) {
        final _state = _states[stateIndex];
        _states.removeAt(stateIndex);
        _states.insert(0, _state);
      }
    }
  }

  Future<void> addState(String? id) async {
    final fetchStateUrl = '$stateUrl/$id';
    final stateResponse = await apiCalls.fetchData(url: fetchStateUrl);
    print(stateResponse);
    States newState = States.fromMap(stateResponse[0]);
    print(newState.name);
    newState.selected = true;
    _states.add(newState);
    // notifyListeners();
  }

  States? getSelectedState() {
    States? selectedState =
        _states.firstWhereOrNull((state) => state.selected == true);
    return selectedState;
  }

  String? getStateName(String id) {
    return _states.firstWhereOrNull((state) => state.id == id)!.name;
  }

  void selectState(String? stateId) async {
    bool toAdd = true;
    if (_states.isEmpty) {
      await addState(stateId);
      return;
    } else {
      _states.forEach((x) async {
        if (x.id == stateId) {
          toAdd = false;
        }
      });
    }
    if (toAdd) {
      print("Yoo");
      await addState(stateId);
      return;
    }
    States? oldSelectedState = getSelectedState();
    if (oldSelectedState != null) {
      oldSelectedState.selected = false;
    }
    _states.sort((a, b) => a.name!.compareTo(b.name!));
    final selectedState =
        _states.firstWhereOrNull((oldState) => oldState.id == stateId);
    if (selectedState != null) {
      final countryIndex = _states.indexOf(selectedState);
      selectedState.selected = true;
      _states.removeAt(countryIndex);
      _states.insert(0, selectedState);
      notifyListeners();
    }
  }

  void disSelectState() {
    _states.forEach((x) => x.selected = false);
  }
}

class States {
  String? id;
  String? name;
  // int numericIsoCode;
  // String threeLetterIsoCode;
  bool? selected;

  States({
    this.id,
    this.name,
    // this.numericIsoCode,
    // this.threeLetterIsoCode,
    this.selected = false,
  });

  States.fromMap(dynamic obj) {
    this.id = obj['Id'].toString();
    this.name = obj['Name'].toString();
    // this.numericIsoCode = obj['NumericIsoCode'].toInt();
    // this.threeLetterIsoCode = obj['ThreeLetterIsoCode'].toString();
    this.selected = false;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['Id'] = this.id;
    map['Name'] = this.name;
    // map['NumericIsoCode'] = this.numericIsoCode;
    // map['ThreeLetterIsoCode'] = this.threeLetterIsoCode;
    return map;
  }
}
