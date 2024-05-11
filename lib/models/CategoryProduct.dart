class CategoryProduct {
  int? text;
  int? pageSizeOption;

  CategoryProduct({this.text, this.pageSizeOption});

  toMap() {
    Map<String, dynamic> map = new Map();
    map['pageSizeOptions'] = [
      {
        "disabled": true,
        "group": {"disabled": true, "name": "string"},
        "selected": true,
        "text": this.text,
        "value": "string"
      }
    ];
    map['pageSizeOption'] = this.pageSizeOption;
    map['orderBy'] = 0;
    map['viewMode'] = "string";
    return map;
  }
}
