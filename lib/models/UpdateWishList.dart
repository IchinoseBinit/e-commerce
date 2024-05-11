class UpdateWishList {
  String? id;
  int? quantity;
  bool? removeFromWishList;

  UpdateWishList({
    this.id,
    this.quantity,
    this.removeFromWishList,
  });

  List<Map<String, dynamic>> toListOfMap() {
    List<Map<String, dynamic>> list = [];
    Map<String, dynamic> map = new Map();
    map['id'] = this.id;
    map['quantity'] = this.quantity;
    map['removeFromWishList'] = this.removeFromWishList;
    list.add(map);
    return list;
  }
}
