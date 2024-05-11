import 'package:e_commerce_app/components/news_blog_card.dart';
import 'package:e_commerce_app/providers/News.dart';
import 'package:e_commerce_app/screens/home/components/section_title.dart';
import 'package:e_commerce_app/screens/news_blogs/news_blogs.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  Future? future;

  @override
  void initState() {
    future = Provider.of<NewsProvider>(context, listen: false).fetchNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SectionTitle(
          title: "News",
          press: () {
            Navigator.of(context)
                .pushNamed(NewsBlogsScreen.routeName, arguments: "News");
          },
        ),
      ),
      SizedBox(height: getProportionateScreenWidth(20)),
      FutureBuilder(
        future: future,
        builder: (context, newsData) {
          if (newsData.connectionState == ConnectionState.waiting) {
            return Container(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Consumer<NewsProvider>(
            builder: (context, newsData, _) {
              return newsData.newsList.isNotEmpty
                  ? Container(
                      height: getProportionateScreenHeight(190),
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: newsData.newsList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // return Text("Hello");
                          return NewsBlogCard(
                            key: Key(newsData.newsList[index].id),
                            obj: newsData.newsList[index],
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 120,
                      child: Center(
                        child: Text("No news to display"),
                      ),
                    );
            },
          );
        },
      )
    ]);
  }
}
