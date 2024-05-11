import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/models/CategoryProduct.dart';
import 'package:e_commerce_app/utilities/no_image.dart';
import 'package:flutter/material.dart';

import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/providers/WishList.dart';

import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' show parse;

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> searchProducts = [];

  List<Product> categoryProducts = [];

  List<Product> homePageProducts = [];

  List<Product> homePageNewProducts = [];

  List<Product> get products => [..._products];

  List<SortOptions> sortOptions = [];

  ApiCalls apiCalls = new ApiCalls();

  Map<String, String?> values = {
    'name': '',
    'email': '',
    'senderName': '',
    'senderEmail': '',
  };

  var numberOfProductsInOneCall = 6;

  Product? getProductById(String? productId) {
    List<Product> merged = _products +
        searchProducts +
        categoryProducts +
        homePageProducts +
        homePageNewProducts;
    return merged.firstWhereOrNull((product) => product.id == productId);
  }

  void clearProducts() {
    _products.clear();
  }

  fetchSearchProduct(String searchValue) async {
    if (searchProducts.isNotEmpty) {
      searchProducts.clear();
    }
    final searchUrl = '$searchProductUrl?q=$searchValue';

    await _addSearchProduct(searchUrl);
  }

  fetchHomePageProducts(BuildContext context) async {
    if (homePageProducts.isNotEmpty) {
      return;
    }

    final hiveProducts = await Hive.openBox('HomePageProducts');
    final hivePictures = await Hive.openBox('HomePageProductsPictures');
    if (hiveProducts.isNotEmpty) {
      for (var product in hiveProducts.values) {
        homePageProducts.add(
          await _addProductsToList(
            product,
            hivePictures: hivePictures,
          ),
        );
      }
      try {
        await InternetAddress.lookup('example.com');

        List<Product> _instantHomePageProducts = [];
        await hiveProducts.clear();
        apiCalls
            .fetchData(url: fetchHomePageProductsUrl, context: context)
            .then(
          (responseDecoded) async {
            if (responseDecoded == null) {
              return;
            }
            for (var product in responseDecoded) {
              _instantHomePageProducts.add(await _addProductsToList(product));
              await hiveProducts.add(product);
            }
            await hivePictures.clear();
            _instantHomePageProducts.forEach((prod) {
              if (prod.images!.isNotEmpty) {
                List<dynamic> _picList = [];

                for (var img in prod.images!) {
                  _picList.add(img);
                }
                hivePictures.put(prod.id, _picList);
              }
            });
            homePageProducts.clear();
            homePageProducts = _instantHomePageProducts;
            notifyListeners();
          },
        );
      } on SocketException catch (_) {
        return;
      }
    } else {
      try {
        await InternetAddress.lookup('example.com');
        final response = await apiCalls.fetchData(
            url: fetchHomePageProductsUrl, context: context);
        if (response == null) {
          return;
        }
        List<Product> _instantHomePageProducts = [];
        for (var product in response) {
          _instantHomePageProducts.add(
            await _addProductsToList(
              product,
              hivePictures: hivePictures,
            ),
          );
          await hiveProducts.add(product);
        }
        await hivePictures.clear();

        _instantHomePageProducts.forEach((prod) {
          if (prod.images!.isNotEmpty) {
            List<dynamic> _picList = [];

            for (var img in prod.images!) {
              _picList.add(img);
            }
            hivePictures.put(prod.id, _picList);
          }
        });
        homePageProducts.clear();
        homePageProducts = _instantHomePageProducts;
      } on SocketException catch (_) {
        return;
      }
    }
    notifyListeners();
  }

  fetchHomePageNewProducts(BuildContext context) async {
    if (homePageNewProducts.isNotEmpty) {
      return;
    }
    final hiveNewProducts = await Hive.openBox('HomePageNewProducts');
    final hivePictures = await Hive.openBox('HomePageNewProductsPictures');
    if (hiveNewProducts.isNotEmpty) {
      for (var product in hiveNewProducts.values) {
        homePageNewProducts
            .add(await _addProductsToList(product, hivePictures: hivePictures));
      }
      try {
        await InternetAddress.lookup('example.com');

        List<Product> _instantHomeNewPageProducts = [];
        await hiveNewProducts.clear();
        apiCalls
            .fetchData(url: fetchHomePageNewProductsUrl, context: context)
            .then(
          (responseDecoded) async {
            if (responseDecoded != null) {
              for (var product in responseDecoded) {
                _instantHomeNewPageProducts.add(
                  await _addProductsToList(
                    product,
                  ),
                );
                await hiveNewProducts.add(product);
              }
              await hivePictures.clear();
              _instantHomeNewPageProducts.forEach((prod) {
                if (prod.images!.isNotEmpty) {
                  List<dynamic> _picList = [];

                  for (var img in prod.images!) {
                    _picList.add(img);
                  }
                  hivePictures.put(prod.id, _picList);
                }
              });
              homePageNewProducts.clear();
              homePageNewProducts = _instantHomeNewPageProducts;
            }
          },
        );
      } on SocketException catch (_) {
        return;
      }
    } else {
      try {
        await InternetAddress.lookup('example.com');
        final response = await apiCalls.fetchData(
            url: fetchHomePageNewProductsUrl, context: context);
        if (response != null) {
          List<Product> _instantHomePageNewProducts = [];
          for (var product in response) {
            _instantHomePageNewProducts.add(
              await _addProductsToList(
                product,
                hivePictures: hivePictures,
              ),
            );
            await hivePictures.clear();

            _instantHomePageNewProducts.forEach((prod) {
              if (prod.images!.isNotEmpty) {
                List<dynamic> _picList = [];

                for (var img in prod.images!) {
                  _picList.add(img);
                }
                hivePictures.put(prod.id, _picList);
              }
            });
            await hiveNewProducts.add(product);
          }

          homePageNewProducts.clear();
          homePageNewProducts = _instantHomePageNewProducts;
        }
      } on SocketException catch (_) {
        return;
      }
    }
    notifyListeners();
  }

  Future<void> fetchCategoryProduct(String? categoryId) async {
    final categoryProductsUrl =
        '$fetchProductByCategoryUrl?categoryId=$categoryId';
    await _addCategoryProduct(categoryProductsUrl);
    notifyListeners();
  }

  _addCategoryProduct(String url) async {
    final encodedResponse = await apiCalls.postData(
        url, CategoryProduct(text: 1, pageSizeOption: 1).toMap());
    if (sortOptions.isNotEmpty) {
      sortOptions.clear();
    }
    if (encodedResponse['Products'].length > 1) {
      for (var sort in encodedResponse['PagingFilteringContext']
          ['AvailableSortOptions']) {
        sortOptions.add(SortOptions.fromMap(sort));
      }
    }
    if (categoryProducts.isNotEmpty) {
      categoryProducts.clear();
    }
    for (var product in encodedResponse['Products']) {
      categoryProducts.add(await _addProductsToList(product));
    }
    for (var product in encodedResponse['Products']) {
      // print();
      if (categoryProducts.isEmpty) {
        categoryProducts.add(await _addProductsToList(product));
      } else {
        final prod = categoryProducts.firstWhereOrNull(
            (element) => element.title == product['Name'].toString());
        print('yeiho ${prod == null ? "xaiaa" : prod.title}');
        if (prod == null) {
          categoryProducts.add(await _addProductsToList(product));
        }
      }
    }
    // categoryProducts.forEach(
    //   (element) {
    //     bool hasItem = false;
    //     for (var product in encodedResponse['Products']) {
    //       print(product['Name']);
    //       if (element.title == product['Name'].toString()) {
    //         hasItem = true;
    //       }
    //     }
    //     if (!hasItem) {
    //       print('remove vo hai ${element.title}');
    //       categoryProducts.remove(element);
    //       print("HHahaha");
    //     }
    //   },
    // );
    print('response ko length ${encodedResponse['Products'].length}');
    print("after adding ${categoryProducts.length}");
    // print();
  }

  Future<Product> _addProductsToList(dynamic product,
      {Box<dynamic>? hivePictures}) async {
    final pics = [];
    print(product['DefaultPictureModel'].length);
    pics.add(product['DefaultPictureModel']);
    if (product['SecondPictureModel'] != null) {
      if (product['SecondPictureModel']['Id'] != null) {
        pics.add(product['SecondPictureModel']);
      }
    }
    Product newProd = Product.fromSearchJson(product);
    if (product['AttributeMappings'] != null) {
      if ((product['AttributeMappings'] as List).isNotEmpty) {
        newProd.hasProductAttributes = true;
      } else {
        newProd.hasProductAttributes = false;
      }
    } else {
      newProd.hasProductAttributes = false;
    }

    if (newProd.description == null) {
      newProd.description =
          product['ShortDescription'].replaceAll(new RegExp(r'<p>|</p>'), '');
    } else if (newProd.description!.contains(new RegExp(r'<p>|</p>'))) {
      newProd.description =
          newProd.description!.replaceAll(new RegExp(r'<p>|</p>'), '');
    }
    for (var pic in pics) {
      await addPicture(pic, newProd, hivePictures: hivePictures);
    }
    return newProd;
  }

  addPicture(dynamic pic, Product newProd, {Box<dynamic>? hivePictures}) async {
    if (pic.isEmpty) {
      newProd.images!.add(await NoImage.getImage());
    } else {
      if (hivePictures == null) {
        var imageKey = pic['Id'];
        if (imageKey != null) {
          final imageResponse =
              await apiCalls.fetchData(url: '$imageForProductUrl/$imageKey');
          var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
          newProd.images!.add(strImg);
        } else {
          newProd.images!.add(await NoImage.getImage());
        }
      } else {
        if (hivePictures.isNotEmpty) {
          final decodedImageList = hivePictures.get(newProd.id);
          if (decodedImageList != null) {
            for (var imgStr in decodedImageList) {
              newProd.images!.add(imgStr);
            }
          }
        } else {
          var imageKey = pic['Id'];
          if (imageKey != null) {
            final imageResponse =
                await apiCalls.fetchData(url: '$imageForProductUrl/$imageKey');
            var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
            newProd.images!.add(strImg);
          } else {
            newProd.images!.add(await NoImage.getImage());
          }
        }
      }
    }
    return newProd;
  }

  _addSearchProduct(String url) async {
    final encodedResponse = await apiCalls.fetchData(url: url);
    if (sortOptions.isNotEmpty) {
      sortOptions.clear();
    }
    if (encodedResponse['Products'].length > 1) {
      for (var sort in encodedResponse['PagingFilteringContext']
          ['AvailableSortOptions']) {
        sortOptions.add(SortOptions.fromMap(sort));
      }
    }
    for (var product in encodedResponse['Products']) {
      searchProducts.add(await _addProductsToList(product));
    }
    notifyListeners();
  }

  sortedSearchProducts(String url) async {
    searchProducts.clear();
    await _addSearchProduct(url);
  }

  sortedCategoryProducts(String url) async {
    categoryProducts.clear();
    await _addCategoryProduct(url);
  }

  updateProductFavorite(String? id) {
    getProductById(id)!.isFavourite = !getProductById(id)!.isFavourite!;
    notifyListeners();
  }

  Future<void> fetchProducts(BuildContext context) async {
    if (_products.isNotEmpty) {
      return;
    }

    dynamic customer =
        Provider.of<CustomerProvider>(context, listen: false).customer;

    if (customer != null) {
      await Provider.of<WishListProvider>(context, listen: false)
          .fetchWishLists(context);
    }
    final hiveProducts = await Hive.openBox('Products');
    final hivePictures = await Hive.openBox('ProductPictures');

    // Select Values for Products API
    const oDataSelectValues =
        '&\$Select=Id,IsGiftCard,Name,Price,FullDescription,ShortDescription,ApprovedRatingSum,ApprovedTotalReviews';

    // Expand values for Products API
    const oDataExpandValues =
        '&\$expand=Pictures(\$Select=PictureId),AttributeMappings(\$Select=Id)';
    if (hiveProducts.isNotEmpty) {
      _products = await addProductsFromApi(
          context, hiveProducts.values.first, hivePictures);
      notifyListeners();
      try {
        print("calling the api");
        await InternetAddress.lookup('example.com');
        var url = '$fetchProductUrl?$oDataSelectValues$oDataExpandValues';
        apiCalls.fetchData(url: url).then(
          (response) async {
            if (response == null) {
              return;
            }
            dynamic productList;
            if (response is List) {
              productList = response;
            } else {
              productList = response['value'];
            }
            print("got theresult from api");

            final list = await addProductsFromApi(context, productList, null);
            if (_products.length == list.length) {
              await hiveProducts.clear();
              await hiveProducts.add(productList);
            }
            _products.clear();
            _products = list;
          },
        );
      } on SocketException catch (_) {
        return;
      }
    } else {
      try {
        await InternetAddress.lookup('example.com');
        var productToSkip = 0;
        var list = ['something'];
        // creating a empty list to access the blocks in while loop
        List<dynamic> storingForDatabse = [];
        // for getting all the values to database

        // http://localhost:8081/RegisterdUserApi/odata/Product/Get?$top=5&$Select=ProductType,Id,IsGiftCard,Name,Price,FullDescription,ShortDescription,Pictures,AttributeMappings
        while (list.isNotEmpty) {
          var url =
              '$fetchProductUrl?\$top=$numberOfProductsInOneCall&\$skip=$productToSkip$oDataSelectValues$oDataExpandValues';
          productToSkip += numberOfProductsInOneCall;
          final encodedResponse = await apiCalls.fetchData(url: url);
          print(encodedResponse);
          print(productToSkip);

          if (encodedResponse != null) {
            if (encodedResponse.isEmpty) {
              list = [];
            } else {
              dynamic productList;
              if (encodedResponse is List) {
                productList = encodedResponse;
              } else {
                productList = encodedResponse['value'];
              }
              storingForDatabse = storingForDatabse + productList!;
              _products += await addProductsFromApi(context, productList, null);
              notifyListeners();
            }
          }
        }
        // await hiveProducts.add(storingForDatabse);
      } on SocketException catch (_) {
        return;
      }
    }
    notifyListeners();
  }

  addProductsFromApi(BuildContext context, dynamic productList,
      Box<dynamic>? hivePictures) async {
    List<Product> newList = [];

    for (var product in productList) {
      newList.add(
        await addEachProduct(
          context,
          product,
          hivePictures: hivePictures,
        ),
      );
    }
    // print(newList);
    if (hivePictures != null) {
      if (_products.length == 0 || _products.length == newList.length) {
        if (hivePictures.isNotEmpty) {
          await hivePictures.clear();
        }
        newList.forEach(
          (prod) {
            if (prod.images!.isNotEmpty) {
              List<dynamic> _picList = [];

              for (var img in prod.images!) {
                _picList.add(img);
              }
              hivePictures.put(prod.id, _picList);
            }
          },
        );
      }
    }

    List<WishList> wishList =
        Provider.of<WishListProvider>(context, listen: false).wishList;
    if (wishList.isNotEmpty) {
      newList.forEach((prod) {
        wishList.forEach((wishListItem) {
          if (wishListItem.product!.id == prod.id) {
            prod.isFavourite = true;
          }
        });
      });
    }
    return newList;
  }

  Future<Product> addEachProduct(
    BuildContext context,
    dynamic product, {
    Box<dynamic>? hivePictures,
  }) async {
    List pics = [];
    if (product['Pictures'] != null) {
      pics = product['Pictures'];
    } else {
      print(product['DefaultPictureModel'].length);
      pics.add(product['DefaultPictureModel']);
      if (product['SecondPictureModel'] != null) {
        if (product['SecondPictureModel']['Id'] != null) {
          pics.add(product['SecondPictureModel']);
        }
      }
    }
    Product prod = Product.fromMap(product);

    if (prod.description == null) {
      prod.description = product['ShortDescription'];
    }
    if (parse(prod.description).body != null)
      prod.description = parse(prod.description).body!.text;
    if (product['AttributeMappings'] != null) {
      if ((product['AttributeMappings'] as List).isNotEmpty) {
        prod.hasProductAttributes = true;
        prod.hasAdditionalParameter =
            prod.hasAdditionalParameter! ? true : true;
      }
    }

    // For image
    if (pics.isEmpty) {
      prod.images!.add(await NoImage.getImage());
    } else {
      if (hivePictures == null) {
        for (var pic in pics) {
          String? imageKey;
          if (pic['Id'] == null) {
            imageKey = pic['PictureId'];
          } else {
            imageKey = pic['Id'];
          }
          final imageResponse =
              await apiCalls.fetchData(url: '$imageForProductUrl/$imageKey');
          var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
          prod.images!.add(strImg);
        }
      } else {
        if (hivePictures.isNotEmpty) {
          final decodedImageList = hivePictures.get(prod.id);
          if (decodedImageList != null) {
            for (var imgStr in decodedImageList) {
              prod.images!.add(imgStr);
            }
          }
        } else {
          for (var pic in pics) {
            var imageKey = pic['PictureId'];
            final imageResponse =
                await apiCalls.fetchData(url: '$imageForProductUrl/$imageKey');
            if (imageResponse != 404) {
              var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
              prod.images!.add(strImg);
            } else {}
          }
        }
      }
    }
    return prod;
  }

  clearProductsLocally() {
    _products.clear();
    searchProducts.clear();
    categoryProducts.clear();
    homePageProducts.clear();
    homePageNewProducts.clear();
    notifyListeners();
  }

  updateProductDetails(
      String? productId, bool? isGiftCard, bool hasProductAttribute) {
    final prod = getProductById(productId);
    if (prod != null) {
      prod.isGiftCard = isGiftCard;
      prod.hasProductAttributes = hasProductAttribute;
    }
    notifyListeners();
  }

  // selectAttribute(
  //   String attributeId,
  //   ProductAttribute productAttribute,
  // ) {
  //   final oldSelectedAttribute = productAttribute.hasSelected();
  //   if (oldSelectedAttribute != null) {
  //     oldSelectedAttribute.isSelected = false;
  //   }
  //   final newSelectedAttribute = productAttribute.getAttributeById(attributeId);
  //   newSelectedAttribute.isSelected = true;
  //   notifyListeners();
  // }

  // productAttributeToMap(String prodId) {
  //   Map<String, dynamic> map = Map<String, String>();
  //   final product = getProductById(prodId);
  //   if (product != null) {
  //     product.productAttributes.forEach((attrib) {
  //       map[attrib.id] = attrib.hasSelected().attributeId;
  //     });
  //   }
  //   return map;
  // }

  // bool checkHasSelectedAllProductAttribute(String prodId) {
  //   final product = getProductById(prodId);
  //   bool toReturn = true;
  //   if (product != null) {
  //     for (var attrib in product.productAttributes) {
  //       if (attrib.hasSelected() == null) {
  //         toReturn = false;
  //         break;
  //       }
  //     }
  //   } else {
  //     return false;
  //   }
  //   return toReturn;
  // }
}

class SortOptions {
  String? sortingName;
  String? url;

  SortOptions.fromMap(dynamic obj) {
    this.sortingName = obj['Text'];
    this.url = obj['Value'];
  }
}

class Product {
  String? id;
  String? title, description;
  List<Uint8List?>? images;
  List<Color>? colors;
  bool? hasProductAttributes;
  bool? isGiftCard;
  bool? hasAdditionalParameter;
  double? rating, price;
  bool? isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    // required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });

  Product.fromOdataMap(dynamic obj) {
    this.id = obj['Id'].toString();
    this.images = [];
    this.isGiftCard = obj['IsGiftCard'];
    this.hasAdditionalParameter = isGiftCard == null ? false : isGiftCard;
    this.rating = obj['ApprovedRatingSum'].toDouble() == 0
        ? obj['ApprovedRatingSum'].toDouble()
        : obj['ApprovedRatingSum'].toDouble() /
            obj['ApprovedTotalReviews'].toDouble();

    this.isFavourite = false;
    this.isPopular = false;
    this.title = obj['Name'];
    this.price = obj['Price'].toDouble();
    this.description = obj['FullDescription'];
  }

  Product.fromMap(dynamic obj) {
    // print(obj);
    this.id = obj['Id'].toString();
    this.images = [];
    this.colors = [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white
    ];
    if (obj['GiftCard'] != null) {
      this.isGiftCard = obj['GiftCard']['IsGiftCard'];
    } else {
      this.isGiftCard = obj['IsGiftCard'];
    }
    this.hasAdditionalParameter = isGiftCard! ? true : false;
    // this.hasProductAttributes =
    if (obj['ProductReviewOverview'] == null) {
      this.rating = obj['ApprovedRatingSum'].toDouble() == 0
          ? obj['ApprovedRatingSum'].toDouble()
          : obj['ApprovedRatingSum'].toDouble() /
              obj['ApprovedTotalReviews'].toDouble();
    } else {
      final ratings = obj['ProductReviewOverview'];
      this.rating = ratings['RatingSum'].toDouble() == 0
          ? ratings['RatingSum'].toDouble()
          : ratings['RatingSum'].toDouble() /
              ratings['TotalReviews'].toDouble();
    }
    // this.productAttributes = [];

    this.isFavourite = false;
    this.isPopular = false;
    this.title = obj['Name'];
    if (obj['ProductPrice'] == null) {
      this.price = obj['Price'].toDouble();
    } else {
      this.price = obj['ProductPrice']['PriceValue'].toDouble();
    }
    this.description = obj['FullDescription'];
  }

  Product.fromSearchJson(dynamic obj) {
    this.id = obj['Id'].toString();
    this.images = [];
    this.colors = [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white
    ];
    this.hasAdditionalParameter = obj['HasAdditionalParameter'] ?? false;
    this.rating = obj['ReviewOverviewModel']['RatingSum'].toDouble() == 0
        ? obj['ReviewOverviewModel']['RatingSum'].toDouble()
        : obj['ReviewOverviewModel']['RatingSum'].toDouble() /
            obj['ReviewOverviewModel']['TotalReviews'].toDouble();
    this.isFavourite = false;
    this.isPopular = false;
    this.title = obj['Name'];
    this.price = obj['ProductPrice']['PriceValue'];
    this.description = obj['FullDescription'];
  }
}
