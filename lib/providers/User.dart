class User {
  String? _id;
  String? _fullName;

  User(this._id, this._fullName);

  User.fromMap(dynamic obj) {
    this._id = obj['id'];
    this._fullName = obj['fullname'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['fullname'] = _fullName;

    return map;
  }
}
