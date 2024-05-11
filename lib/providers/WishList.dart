import 'dart:convert';

import 'package:e_commerce_app/models/ActionCart.dart';
import 'package:e_commerce_app/models/UpdateWishList.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../urls.dart';

class WishListProvider with ChangeNotifier {
  List<WishList> _wishList = [];

  List<WishList> get wishList => [..._wishList];

  ApiCalls apiCalls = new ApiCalls();

  int? _wishListCount;

  int get wishListCount => _wishListCount ?? 3;

  set wishListCount(int? value) {
    _wishListCount = value;
    notifyListeners();
  }

  fetchWishLists(BuildContext context) async {
    if (_wishList.isNotEmpty) {
      _wishList.clear();
    }
    await _callFromApi(context);
    notifyListeners();
  }

  _callFromApi(BuildContext context) async {
    final url = '$fetchWishListUrl';
    final encodedResponse = await apiCalls.fetchData(url: url);

    // print(encodedResponse);
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
      final productProvider = Provider.of<Products>(context, listen: false);
      if (productProvider.products.isNotEmpty) {
        final prod = productProvider.getProductById(productObj.id);
        if (prod != null && !prod.isFavourite!) {
          productProvider.updateProductFavorite(prod.id);
        }
      }
      _wishList.add(WishList(id, productObj, quantity));
    }
    _wishListCount = _wishList.length;
  }

  updateWishList(String productId, int quantity) async {
    var toBeUpdatedItemIndex = _wishList
        .indexWhere((wishListItem) => wishListItem.product!.id == productId);
    var toBeUpdatedItem = _wishList[toBeUpdatedItemIndex];
    _wishList[toBeUpdatedItemIndex].quantity = quantity;
    final response = await apiCalls.postData(
        updateWishListUrl,
        (new UpdateWishList(
                id: toBeUpdatedItem.id,
                quantity: quantity,
                removeFromWishList: false))
            .toListOfMap());
    if (response == null) {
      _wishList[toBeUpdatedItemIndex].quantity = toBeUpdatedItem.quantity;
    }

    notifyListeners();
  }

  Future<bool> addToWishList({
    BuildContext? context,
    required Product product,
    int? quantity,
    dynamic map,
    dynamic giftCardMap,
  }) async {
    final wishListUrl =
        '$actionCartUrl?productId=${product.id}&shoppingCartTypeId=2';

    var actionCart;
    if (map != null) {
      actionCart = new ActionCart(
        quantity: quantity,
        productAttribute: map,
      );
    } else if (giftCardMap != null) {
      actionCart = new ActionCart(
        quantity: quantity,
        giftCardSenderName: giftCardMap['senderName'],
        giftCardSenderEmail: giftCardMap['senderEmail'],
        giftCardReceipentName: giftCardMap['name'],
        giftCardReceipentEmail: giftCardMap['email'],
      );
    } else {
      actionCart = new ActionCart(
        quantity: quantity,
      );
    }
    final response = await apiCalls.postData(wishListUrl, actionCart.toMap());
    if (response != null) {
      if (response['success'] == true) {
        if (_wishListCount == null) _wishListCount = 0;
        _wishListCount = _wishListCount! + 1;
      } else {
        Provider.of<Products>(context!, listen: false)
            .updateProductFavorite(product.id);
        return false;
      }
    } else {
      Provider.of<Products>(context!, listen: false)
          .updateProductFavorite(product.id);
      return false;
    }
    notifyListeners();
    return true;
  }

  removeFromWishList(BuildContext context, String? productId) async {
    var toBeRemovedItemIndex = _wishList
        .indexWhere((wishListItem) => wishListItem.product!.id == productId);
    if (toBeRemovedItemIndex < 0) {
      _wishListCount = _wishListCount! - 1;
      notifyListeners();
      return;
    }
    var toBeRemovedItem = _wishList[toBeRemovedItemIndex];
    _wishList.removeAt(toBeRemovedItemIndex);
    final response = await apiCalls.postData(
        updateWishListUrl,
        (new UpdateWishList(
          id: toBeRemovedItem.id,
          quantity: 0,
          removeFromWishList: true,
        )).toListOfMap());
    if (response == null) {
      Provider.of<Products>(context, listen: false)
              .getProductById(productId)!
              .isFavourite =
          !Provider.of<Products>(context, listen: false)
              .getProductById(productId)!
              .isFavourite!;
      _wishList.insert(toBeRemovedItemIndex, toBeRemovedItem);
    } else {
      _wishListCount = _wishListCount! - 1;
    }
    notifyListeners();
  }

  clearWishListLocally() {
    _wishList.clear();
    notifyListeners();
  }
}

class WishList {
  String? id;
  Product? product;
  int? quantity;

  WishList(this.id, this.product, this.quantity);

  WishList.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.product = obj['product'];
    this.quantity = obj['quantity'];
  }
}
