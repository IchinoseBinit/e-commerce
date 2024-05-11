import 'package:e_commerce_app/providers/Theme.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorScreen extends StatefulWidget {
  static const routeName = '/colors';

  @override
  _ColorScreenState createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  Future? future;

  @override
  void initState() {
    future =
        Provider.of<ThemeProvider>(context, listen: false).fetchColorThemes();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Color'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: future,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Consumer<ThemeProvider>(
              builder: (ctx, themeData, child) {
                return themeData.colorThemeList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color(
                                  themeData.colorThemeList[index].colorValue!),
                              // child: Container(
                              //   constraints: BoxConstraints(),
                              //   color: Color(
                              //       themeData.colorThemeList[index].colorValue),
                              // ),
                            ),
                            title: Text(
                              themeData.colorThemeList[index].colorName!,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            trailing: themeData
                                        .colorThemeList[index].isSelected ==
                                    true
                                ? Icon(
                                    Icons.done,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                : SizedBox.shrink(),
                            onTap: () {
                              themeData.updateColorTheme(
                                  themeData.colorThemeList[index].colorName,
                                  themeData.colorThemeList[index].colorValue);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        itemCount: themeData.colorThemeList.length,
                      )
                    : Container(
                        height: getProportionateScreenHeight(250),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
