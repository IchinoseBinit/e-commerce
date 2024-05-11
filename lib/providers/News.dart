import 'dart:convert';
import 'dart:typed_data';

import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:e_commerce_app/utilities/no_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:html/parser.dart' show parse;

class NewsProvider with ChangeNotifier {
  List<News> _newsList = [];

  List<News> get newsList => [..._newsList];

  ApiCalls apiCalls = new ApiCalls();

  fetchNews() async {
    if (_newsList.isNotEmpty) {
      return;
    }
    final response = await apiCalls.fetchData(url: fetchNewsUrl);
    print("this is news");
    print(response);
    for (var eachNews in response['NewsItems']) {
      _newsList.add(await _addToNewsList(eachNews));
    }
    notifyListeners();
  }

  _addToNewsList(dynamic news) async {
    final pic = news['PictureModel'];
    News newNews = News.fromJson(news);
    // print(newNews);
    if (newNews.description == null) {
      newNews.description =
          news['Short'].replaceAll(new RegExp(r'<p>|</p>'), '');
    }
    if (parse(newNews.description).body != null)
      newNews.description = parse(newNews.description).body!.text;
    if (pic.isEmpty) {
      newNews.image = await NoImage.getImage();
    } else {
      var imageKey = pic['Id'];
      if (imageKey != null) {
        final imageResponse =
            await apiCalls.fetchData(url: '$imageForProductUrl/$imageKey');
        var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
        newNews.image = strImg;
      } else {
        newNews.image = await NoImage.getImage();
      }
    }
    return newNews;
  }
}

class News {
  late String id;
  String? title;
  Uint8List? image;
  String? description;

  News.fromJson(dynamic obj) {
    this.id = obj['Id'].toString();
    this.title = obj['Title'].toString();
    this.image = null;
    this.description = obj['Full'];
  }
}
