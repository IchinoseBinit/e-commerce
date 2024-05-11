import 'dart:convert';

import 'package:e_commerce_app/models/ActionCart.dart';
import 'package:e_commerce_app/models/ShoppingCart.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../urls.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _carts = [];

  List<Cart> get carts => [..._carts];

  List<CheckoutAttributes> checkoutAttributesList = [];

  ApiCalls apiCalls = new ApiCalls();

  int? _cartCount;

  set cartCount(int? value) {
    _cartCount = value;
    notifyListeners();
  }

  Future<List<Cart>> fetchCartList() async {
    if (_carts.isNotEmpty) {
      // return _carts;
      _carts.clear();
      checkoutAttributesList.clear();
    }

    final encodedResponse = await apiCalls.fetchData(url: fetchCartListUrl);
    // print(encodedResponse);
    // Changing the items to cart objects
    for (var items in encodedResponse['Items']) {
      final id = items['Id'];
      final quantity = items['Quantity'].toInt();
      final productId = items['ProductId'].toString();
      final productUrl = '$fetchProductUrl/$productId';
      final productResponse = await apiCalls.fetchData(url: productUrl);
      final productObj = Product.fromMap(productResponse);
      List pics = productResponse['PictureModels'];
      if (productObj.description == null) {
        productObj.description = productResponse['ShortDescription'];
      } else if (productObj.description!.contains(new RegExp(r'<p>|</p>'))) {
        productObj.description =
            productObj.description!.replaceAll(new RegExp(r'<p>|</p>'), '');
      }

      // For image
      if (pics.isEmpty) {
        rootBundle.load("assets/images/no-image.png").then((byteData) {
          final bytes = byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
          productObj.images!.add(bytes);
        });
      } else {
        // After the data is received, the image is retrieved using another http call
        // then the image retrieved as a binary format is saved in the instance of the product class
        for (var pic in pics) {
          var imageKey = pic['Id'];
          final imageResponse =
              await apiCalls.fetchData(url: '$imageForProductUrl/$imageKey');
          var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
          productObj.images!.add(strImg);
        }
      }
      // _products.add(prod);
      _carts.add(Cart(id, productObj, quantity));
    }
    final checkOutAtrributes = encodedResponse['CheckoutAttributes'];
    if (checkoutAttributesList.isEmpty) {
      // print(checkOutAtrributes);
      for (var attribute in checkOutAtrributes) {
        // print(attribute);
        checkoutAttributesList.add(
          CheckoutAttributes.fromMap(attribute),
        );
      }
    }
    print("this is checkout");
    print(checkoutAttributesList.length);
    checkoutAttributesList.forEach((x) {
      x.checkoutDropDownList.first.selected = true;
    });
    _cartCount = _carts.length;
    notifyListeners();
    // makes the first attibute first option to selected.
    return _carts;
  }

  double getTotalCartAmount() {
    double sum = 0;
    carts.forEach((cart) => sum = sum + (cart.product.price! * cart.quantity!));
    return sum;
  }

  double getTotalBillAmount() {
    // get here the amount to add
    return getTotalCartAmount() + 80;
  }

  updateAttributes(String? attributesId, String? id) async {
    CheckoutAttributes checkout = checkoutAttributesList.firstWhere(
        (checkoutAttribute) => checkoutAttribute.id == attributesId,
        orElse: null);
    // if (checkout == null) {
    //   return;
    // }
    checkout.checkoutDropDownList.forEach((checkDrop) {
      if (checkDrop.id == id) {
        checkDrop.selected = true;
      } else {
        checkDrop.selected = false;
      }
    });
    final response = await apiCalls.postData(
        updateItemCartUrl,
        (new ShoppingCart(
          // if cartProducts is not initialized, it would send request as null and would get 500 error
          cartProducts: {},
          cartAttributes: {
            attributesId: id,
          },
        )).toMap());
    print(response);
    if (response == null) {
      print("Error");
    }
  }

  clearCartLocally() {
    _carts.clear();
    _cartCount = 0;
    notifyListeners();
  }

  Future<void> clearCart() async {
    final response = await apiCalls.fetchData(url: clearCartUrl);
    if (response != null) {
      _carts.clear();
      _cartCount = 0;
      notifyListeners();
    }
  }

  startCheckout() async {
    final shoppingCart = ShoppingCart();

    Map<String, int?> mapForQuantity = new Map();
    _carts.forEach((cart) {
      mapForQuantity['${cart.id}'] = cart.quantity;
    });

    shoppingCart.cartProducts = mapForQuantity;

    Map<String, String?> mapForAttributes = new Map();
    checkoutAttributesList.forEach((checkoutAttribute) {
      mapForAttributes['${checkoutAttribute.id}'] = checkoutAttribute
          .checkoutDropDownList
          .firstWhere((x) => x.selected == true, orElse: null)
          .id;
    });

    shoppingCart.cartAttributes = mapForAttributes;
    await apiCalls.postData(startCheckoutUrl, shoppingCart.toMap());
  }

  updateCart(String? productId, int quantity) async {
    var toBeUpdatedItemIndex =
        _carts.indexWhere((cartItem) => cartItem.product.id == productId);
    var toBeUpdatedItem = _carts[toBeUpdatedItemIndex];
    _carts[toBeUpdatedItemIndex].quantity = quantity;
    final response = await apiCalls.postData(
        updateItemCartUrl,
        (new ShoppingCart(cartProducts: {
          "${toBeUpdatedItem.id}": quantity,
        })).toMap());
    if (response == null) {
      _carts[toBeUpdatedItemIndex].quantity = toBeUpdatedItem.quantity;
    }
    notifyListeners();
  }

  getCartCount() {
    return _cartCount;
  }

  addToCart(
    Product product,
    int quantity, {
    dynamic map,
    dynamic giftCardMap,
  }) async {
    final cartUrl =
        '$actionCartUrl?productId=${product.id}&shoppingCartTypeId=1';
    var actionCart;
    if (map != null) {
      actionCart = new ActionCart(quantity: quantity, productAttribute: map);
    } else if (giftCardMap != null) {
      actionCart = new ActionCart(
          quantity: quantity,
          giftCardSenderName: giftCardMap['senderName'],
          giftCardSenderEmail: giftCardMap['senderEmail'],
          giftCardReceipentName: giftCardMap['name'],
          giftCardReceipentEmail: giftCardMap['email']);
    } else {
      actionCart = new ActionCart(quantity: quantity);
    }

    final response = await apiCalls.postData(cartUrl, actionCart.toMap());
    if (response != null) {
      // _carts.clear();
      // checkoutAttributesList.clear();
      if (_cartCount == null) {
        _cartCount = 1;
      }
      _cartCount = _cartCount! + 1;
    }
    notifyListeners();
  }

  removeFromCart(String? productId) async {
    var toBeRemovedItemIndex =
        _carts.indexWhere((cartItem) => cartItem.product.id == productId);
    if (toBeRemovedItemIndex < 0) {
      return;
    }
    var toBeRemovedItem = _carts[toBeRemovedItemIndex];
    _carts.removeAt(toBeRemovedItemIndex);

    final url = '$deleteItemFromCartUrl?id=${toBeRemovedItem.id}';
    final response = await apiCalls.postData(url, null);
    if (response == null) {
      _carts.insert(toBeRemovedItemIndex, toBeRemovedItem);
    }
    _cartCount = _carts.length;
    notifyListeners();
  }
}

class Cart {
  String? id;
  Product product;
  int? quantity;

  Cart(this.id, this.product, this.quantity);

  // Cart.fromMap(dynamic obj) {
  //   this.id = obj['id'];
  //   this.product = obj['product'];
  //   this.quantity = obj['quantity'];
  // }
}

class CheckoutAttributes {
  String? name;
  String? id;
  List<CheckoutDropDown> checkoutDropDownList = [];

  CheckoutAttributes(
    this.name,
    this.id,
    this.checkoutDropDownList,
  );

  CheckoutAttributes.fromMap(dynamic obj) {
    this.name = obj['Name'];
    this.id = obj['Id'];
    for (var value in obj['Values']) {
      this.checkoutDropDownList.add(CheckoutDropDown.fromMap(value));
    }
  }
}

class CheckoutDropDown {
  String? name;
  String? id;
  String? price;
  bool? selected;

  CheckoutDropDown(
    this.name,
    this.id,
    this.price,
  );

  CheckoutDropDown.fromMap(dynamic obj) {
    this.name = obj['Name'];
    this.id = obj['Id'];
    this.price = obj['PriceAdjustment'];
    this.selected = false;
  }
}
