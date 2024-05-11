import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:e_commerce_app/utilities/no_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../urls.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _homeCategories = [];

  List<Category> get homeCategories => [..._homeCategories];

  List<Category> _categories = [];

  List<Category> get categories => [..._categories];

  ApiCalls apiCalls = new ApiCalls();

  fetchCategories() async {
    if (_categories.isNotEmpty) {
      return;
    }
    final response = await apiCalls.fetchData(url: fetchCategoryUrl);
    for (var eachCategory in response) {
      Category category = Category.fromMap(eachCategory);
      final pictureId = eachCategory['PictureId'];
      if (pictureId.isEmpty) {
        rootBundle.load("assets/images/no-image.png").then((byteData) {
          final bytes = byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
          category.images.add(bytes);
        });
      } else {
        // After the data is received, the image is retrieved using another http call
        // then the image retrieved as a binary format is saved in the instance of the product class
        final imageResponse =
            await apiCalls.fetchData(url: '$imageForProductUrl/$pictureId');
        // print(imageResponse);
        var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
        category.images.add(strImg);
      }
      // print(category);
      _categories.add(category);
    }
    _categories[0].selected = true;
    notifyListeners();
  }

  int indexOfSelectedCategory() {
    return _categories.indexWhere((category) => category.selected == true);
  }

  Category? getSelectedCategory() {
    int index = indexOfSelectedCategory();
    print(index);
    Category? selectedCategory;
    if (index >= 0) {
      selectedCategory = _categories[index];
    }
    return selectedCategory;
  }

  void selectCategory(BuildContext context, String? categoryId) {
    Category? oldSelectedCategory = getSelectedCategory();
    if (oldSelectedCategory != null) {
      oldSelectedCategory.selected = false;
    }
    final selectedCategory = _categories
        .firstWhereOrNull((oldCategory) => oldCategory.id == categoryId);
    if (selectedCategory != null) {
      // final categoryIndex = _categories.indexOf(selectedCategory);
      selectedCategory.selected = true;
      print(selectedCategory.name);

      notifyListeners();
    }
  }

  fetchHomePageCategories(BuildContext context) async {
    if (_homeCategories.isNotEmpty) {
      return;
    }

    final hiveCategories = await Hive.openBox('Categories');
    final hiveCategoryPictures = await Hive.openBox('CategoryPictures');

    if (hiveCategories.isNotEmpty) {
      for (var eachCategory in hiveCategories.values) {
        _homeCategories.add(
          await _addCategoryToList(
            eachCategory,
            hiveCategoryPictures,
          ),
        );
      }
      try {
        await InternetAddress.lookup('example.com');
        List<Category> _instantCategory = [];
        await hiveCategories.clear();

        apiCalls
            .fetchData(url: fetchHomePageCategoryUrl, context: context)
            .then(
          (responseDecoded) async {
            if (responseDecoded == null) {
              return;
            }
            for (var eachCategory in responseDecoded) {
              _instantCategory
                  .add(await _addCategoryToList(eachCategory, null));
              await hiveCategories.add(eachCategory);
            }
            if (_instantCategory.length == homeCategories.length) {
              await hiveCategoryPictures.clear();
              _instantCategory.forEach(
                (category) {
                  if (category.images.isNotEmpty) {
                    List<dynamic> _picList = [];

                    for (var img in category.images) {
                      _picList.add(img);
                    }
                    hiveCategoryPictures.put(category.id, _picList);
                  }
                },
              );
              _homeCategories.clear();
              _homeCategories = _instantCategory;
            }
          },
        );
      } on SocketException catch (_) {
        return 'noInternet';
      }
    } else {
      try {
        await InternetAddress.lookup('example.com');
        final response = await apiCalls.fetchData(
            url: fetchHomePageCategoryUrl, context: context);
        if (response == null) {
          return;
        }
        List<Category> _instantCategory = [];
        for (var eachCategory in response) {
          _instantCategory.add(await _addCategoryToList(eachCategory, null));
          await hiveCategories.add(eachCategory);
        }
        await hiveCategoryPictures.clear();
        _instantCategory.forEach(
          (category) {
            if (category.images.isNotEmpty) {
              List<dynamic> _picList = [];

              for (var img in category.images) {
                _picList.add(img);
              }
              hiveCategoryPictures.put(category.id, _picList);
            }
          },
        );
        _homeCategories.clear();
        _homeCategories = _instantCategory;
      } on SocketException catch (_) {
        return;
      }
    }
    notifyListeners();
  }

  _addCategoryToList(
      dynamic eachCategory, Box<dynamic>? hiveCategoryPictures) async {
    Category category = Category.fromMap(eachCategory);
    final pictureId = eachCategory['PictureModel']['Id'];

    if (hiveCategoryPictures == null) {
      if (pictureId.isEmpty) {
        category.images.add(await NoImage.getImage());
      } else {
        final imageResponse =
            await apiCalls.fetchData(url: '$imageForProductUrl/$pictureId');
        if (imageResponse != null) {
          var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
          category.images.add(strImg);
        } else {
          category.images.add(await NoImage.getImage());
        }
      }
    } else {
      if (hiveCategoryPictures.isNotEmpty) {
        final decodedImage = hiveCategoryPictures.get(category.id);
        if (decodedImage != null) {
          for (var img in decodedImage) {
            category.images.add(img);
          }
        }
      } else {
        final imageResponse =
            await apiCalls.fetchData(url: '$imageForProductUrl/$pictureId');
        if (imageResponse != null) {
          var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
          category.images.add(strImg);
        } else {
          category.images.add(await NoImage.getImage());
        }
      }
    }

    // final decodedImage = hiveCategoryPictures.get(category.id);

    // final pictureId = eachCategory['PictureModel']['Id'];
    // if (pictureId.isEmpty) {
    //   category.images.add(await NoImage.getImage());
    // } else {
    //   if (hiveCategoryPictures.isNotEmpty) {
    //     if (decodedImage != null) {
    //       category.images.add(decodedImage);
    //     } else {
    //       final imageResponse =
    //           await apiCalls.fetchData(url: '$imageForProductUrl/$pictureId');
    //       if (imageResponse != null) {
    //         var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
    //         await hiveCategoryPictures.put(category.id, strImg);
    //         category.images.add(strImg);
    //       } else {
    //         category.images.add(await NoImage.getImage());
    //       }
    //     }
    //   } else {
    //     final imageResponse =
    //         await apiCalls.fetchData(url: '$imageForProductUrl/$pictureId');
    //     if (imageResponse != null) {
    //       var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
    //       await hiveCategoryPictures.put(category.id, strImg);
    //       category.images.add(strImg);
    //     } else {
    //       category.images.add(await NoImage.getImage());
    //     }
    //   }
    // }
    return category;
  }
}

class Category {
  String? name;
  String? description;
  String? id;
  late List<Uint8List?> images;
  bool? selected;

  Category.fromMap(dynamic obj) {
    this.name = obj['Name'].toString();
    this.description = obj['Description'].toString();
    this.id = obj['Id'].toString();
    this.images = [];
    this.selected = false;
  }
}
