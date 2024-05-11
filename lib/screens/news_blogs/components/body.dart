import 'package:e_commerce_app/components/news_blog_card.dart';
import 'package:e_commerce_app/providers/Blog.dart';
import 'package:e_commerce_app/providers/News.dart';
import 'package:e_commerce_app/screens/news_blogs/components/news_blog_display.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final String argument;

  Body(this.argument);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future? future;
  @override
  void initState() {
    super.initState();
    if (widget.argument == 'News') {
      future = Provider.of<NewsProvider>(context, listen: false).fetchNews();
    } else {
      future = Provider.of<BlogProvider>(context, listen: false).fetchBlog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, futureData) {
        if (futureData.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return widget.argument == 'News' ? getNewsWidgets() : getBlogWidgets();
      },
    );
  }

  Widget getNewsWidgets() {
    return Consumer<NewsProvider>(builder: (context, newsData, _) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            height: getProportionateScreenHeight(220),
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 4.0,
            ),
            child: NewsBlogCard(
              obj: newsData.newsList[index],
            ),
          );
        },
        itemCount: newsData.newsList.length,
        shrinkWrap: true,
        primary: false,
      );
    });
  }

  Widget getBlogWidgets() {
    return Consumer<BlogProvider>(
      builder: (context, blogData, _) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              height: getProportionateScreenHeight(220),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              child: NewsBlogCard(
                obj: blogData.blogList[index],
              ),
            );
          },
          itemCount: blogData.blogList.length,
          shrinkWrap: true,
          primary: false,
        );
      },
    );
  }
}
