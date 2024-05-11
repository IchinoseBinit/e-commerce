import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';

class PickUpPointProvider with ChangeNotifier {
  List<PickUpPoint> _pickUpPoints = [];

  List<PickUpPoint> get pickUpPoints => [..._pickUpPoints];

  ApiCalls apiCalls = new ApiCalls();

  Future<List<PickUpPoint>> fetchPickUpPoints() async {
    return pickUpPoints;
  }

  addPickUpPoints(dynamic response) async {
    if (_pickUpPoints.isEmpty) {
      print(response);
      print(response['update_section']['model']['PickupPoints']);
      final listOfPickUpPoints =
          response['update_section']['model']['PickupPoints'];

      for (var eachPickUpPoint in listOfPickUpPoints) {
        _pickUpPoints.add(PickUpPoint.fromMap(eachPickUpPoint));
      }
      print(_pickUpPoints);
    }
  }

  PickUpPoint? getSelectedPickUpPoint() {
    return _pickUpPoints.firstWhereOrNull(
        (pickUpPoint) => pickUpPoint.selected == true);
  }

  void selectPickUpPoint(String? pickUpPointId) async {
    PickUpPoint? oldPickUpPoint = getSelectedPickUpPoint();
    if (oldPickUpPoint != null) {
      oldPickUpPoint.selected = false;
    }
    _pickUpPoints.sort((a, b) => a.name!.compareTo(b.name!));
    final selectedPickUpPoint = _pickUpPoints
        .firstWhere((oldPickPoint) => oldPickPoint.id == pickUpPointId);
    final pickUpPointIndex = _pickUpPoints.indexOf(selectedPickUpPoint);
    selectedPickUpPoint.selected = true;
    _pickUpPoints.removeAt(pickUpPointIndex);
    _pickUpPoints.insert(0, selectedPickUpPoint);
    notifyListeners();
  }

  void disSelectPickUpPoint() {
    _pickUpPoints.forEach((x) => x.selected = false);
  }
}

class PickUpPoint {
  String? id;
  String? name;
  bool? selected;
  int? pickUpFee;
  // int displayOrder;

  PickUpPoint({
    this.id,
    this.name,
    this.pickUpFee,
    this.selected = false,
  });

  PickUpPoint.fromMap(dynamic obj) {
    this.id = obj['Id'];
    this.name = obj['Name'];
    this.pickUpFee = obj['PickupFee'];
    this.selected = false;
  }
}
