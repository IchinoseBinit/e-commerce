import 'package:e_commerce_app/components/news_blog_card.dart';
import 'package:e_commerce_app/providers/Blog.dart';
import 'package:e_commerce_app/screens/home/components/section_title.dart';
import 'package:e_commerce_app/screens/news_blogs/news_blogs.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  Future? future;

  @override
  void initState() {
    future = Provider.of<BlogProvider>(context, listen: false).fetchBlog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SectionTitle(
          title: "Blogs",
          press: () {
            Navigator.of(context)
                .pushNamed(NewsBlogsScreen.routeName, arguments: "Blogs");
          },
        ),
      ),
      SizedBox(height: getProportionateScreenWidth(20)),
      FutureBuilder(
        future: future,
        builder: (context, blogConnectionData) {
          if (blogConnectionData.connectionState == ConnectionState.waiting) {
            return Container(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Consumer<BlogProvider>(
            builder: (context, blogData, _) {
              return blogData.blogList.isNotEmpty
                  ? Container(
                      height: getProportionateScreenHeight(190),
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: blogData.blogList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return NewsBlogCard(
                            key: Key(blogData.blogList[index].toString()),
                            obj: blogData.blogList[index],
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 120,
                      child: Center(
                        child: Text("No blogs to display"),
                      ),
                    );
            },
          );
        },
      )
    ]);
  }
}
