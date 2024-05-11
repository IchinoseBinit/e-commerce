import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/log_out.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProductAttributeProvider with ChangeNotifier {
  List<ProductWithAttribute> _productWithAttributes = [];

  List<ProductWithAttribute> get productWithAttributes =>
      [..._productWithAttributes];

  addProductAttribute(BuildContext context, Product product) async {
    if (getProductWithAttribute(product.id) != null) {
      return;
    }
    print(product.id);
    final url = '$fetchProductUrl/${product.id}';
    final response = await apiCalls.fetchData(url: url);
    print(response);

    final productAttributesResponse = response['ProductAttributes'];
    bool? isGiftCard;
    bool hasProductAttribute = false;
    if (response['GiftCard'] != null) {
      isGiftCard = response['GiftCard']['IsGiftCard'];
    }
    print(response);
    print(response['ProductAttributes']);
    if (response['ProductAttributes'] != null) {
      print("haga");
      if ((response['ProductAttributes'] as List).isNotEmpty) {
        hasProductAttribute = true;
      }
    }
    print("hi");
    print(isGiftCard);
    print(hasProductAttribute);

    Provider.of<Products>(context, listen: false)
        .updateProductDetails(product.id, isGiftCard, hasProductAttribute);

    _productWithAttributes
        .add(ProductWithAttribute.fromMap(product, productAttributesResponse));

    print("HI");
    print(_productWithAttributes.length);
    notifyListeners();
  }

  selectAttribute(
    String attributeId,
    ProductAttribute productAttribute,
  ) {
    final oldSelectedAttribute = productAttribute.hasSelected();
    if (oldSelectedAttribute != null) {
      oldSelectedAttribute.isSelected = false;
    }
    final newSelectedAttribute =
        productAttribute.getAttributeById(attributeId)!;
    newSelectedAttribute.isSelected = true;
    notifyListeners();
  }

  productAttributeToMap(String? prodId) {
    var map = Map<String, String>();
    final product = getProductWithAttribute(prodId);
    if (product != null) {
      product.productAttributes.forEach((attrib) {
        map[attrib.id!] = attrib.hasSelected()!.attributeId!;
      });
    }
    return map;
  }

  bool checkHasSelectedAllProductAttribute(String? prodId) {
    final product = getProductWithAttribute(prodId);
    bool toReturn = true;
    if (product != null) {
      if (product.productAttributes.isEmpty) {
        return false;
      }
      for (var attrib in product.productAttributes) {
        if (attrib.hasSelected() == null) {
          toReturn = false;
          break;
        }
      }
    } else {
      return false;
    }
    return toReturn;
  }

  ProductWithAttribute? getProductWithAttribute(String? productId) {
    return _productWithAttributes.firstWhereOrNull(
        (productWithAttribute) => productWithAttribute.product.id == productId);
  }
}

class ProductWithAttribute {
  late Product product;
  List<ProductAttribute> productAttributes = [];

  ProductWithAttribute.fromMap(Product product, dynamic obj) {
    this.product = product;

    for (var eachAttributeMapping in obj) {
      this
          .productAttributes
          .add(ProductAttribute.fromMap(eachAttributeMapping));
    }
  }
}

class ProductAttribute {
  String? productAttributeId;
  String? id;
  String? name;
  List<AttributeValues> attributeValuesList = [];

  ProductAttribute.fromMap(dynamic obj) {
    this.productAttributeId = obj['ProductAttributeId'].toString();
    this.id = obj['Id'].toString();
    this.name = obj['Name'].toString();

    for (var eachAttributeValues in obj['Values']) {
      this.attributeValuesList.add(
            AttributeValues.fromMap(
              eachAttributeValues,
            ),
          );
    }
  }

  int _getSelectedIndex() {
    return attributeValuesList.indexWhere(
      (attrib) => attrib.isSelected == true,
    );
  }

  AttributeValues? getAttributeById(String id) {
    return attributeValuesList
        .firstWhereOrNull((attrib) => attrib.attributeId == id);
  }

  AttributeValues? hasSelected() {
    int index = _getSelectedIndex();
    if (index < 0) {
      return null;
    }
    return attributeValuesList[index];
  }
}

class AttributeValues {
  late String name;
  String? attributeId;
  double? price;
  bool? isSelected;

  AttributeValues.fromMap(dynamic obj) {
    this.attributeId = obj['Id'].toString();
    this.name = obj['Name'].toString();
    this.price = obj['PriceAdjustmentValue'].toDouble();
    this.isSelected = false;
  }
}
