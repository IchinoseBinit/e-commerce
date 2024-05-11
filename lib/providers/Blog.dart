import 'dart:convert';
import 'dart:typed_data';

import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:e_commerce_app/utilities/no_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:html/parser.dart' show parse;

class BlogProvider with ChangeNotifier {
  List<Blog> _blogList = [];

  List<Blog> get blogList => [..._blogList];

  ApiCalls apiCalls = new ApiCalls();

  fetchBlog() async {
    if (_blogList.isNotEmpty) {
      print(fetchBlogUrl);

      return;
    }
    print(fetchBlogUrl);
    final response = await apiCalls.fetchData(url: fetchBlogUrl);
    print("this is blog");
    print(response);
    for (var eachNews in response['Items']) {
      _blogList.add(await _addToBlogList(eachNews));
    }
    notifyListeners();
  }

  _addToBlogList(dynamic blog) async {
    final pic = blog['PictureModel'];
    Blog newBlog = Blog.fromJson(blog);
    if (newBlog.description == null) {
      newBlog.description =
          blog['Short'].replaceAll(new RegExp(r'<p>|</p>'), '');
    }
    if (parse(newBlog.description).body != null)
      newBlog.description = parse(newBlog.description).body!.text;
    if (pic == null) {
      newBlog.image = await NoImage.getImage();
    } else {
      var imageKey = pic['Id'];
      if (imageKey != null) {
        final imageResponse =
            await apiCalls.fetchData(url: '$imageForProductUrl/$imageKey');
        var strImg = Base64Codec().decode(imageResponse['PictureBinary']);
        newBlog.image = strImg;
      } else {
        newBlog.image = await NoImage.getImage();
      }
    }

    return newBlog;
  }
}

class Blog {
  String? title;
  String? description;
  Uint8List? image;

  Blog.fromJson(dynamic obj) {
    this.title = obj['Title'].toString();
    this.description = obj['Full'];
    this.image = null;
  }
}
