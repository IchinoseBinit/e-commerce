import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/components/category_card.dart';
import 'package:e_commerce_app/providers/Category.dart';
import 'package:e_commerce_app/providers/Theme.dart';
import 'package:e_commerce_app/screens/category/components/product_categories.dart';
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffKey;

  Body(this.scaffKey);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future? futureCategory, futureCategoryProducts;

  late CategoryProvider categoryProvider;
  var categoryId;
  CarouselController buttonCarouselController = CarouselController();
  OverlayState? overlayState;
  late OverlayEntry overlayEntry;
  double? scrolledValue;
  late bool _firstLogin;
  bool _isInit = true;
  bool _isRemoved = false;

  @override
  void initState() {
    super.initState();
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    futureCategory = categoryProvider.fetchCategories();
    _firstLogin =
        MySharedPreferences.sharedPreferences.getBool('firstLogin') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCategory,
      builder: (context, categoryData) {
        if (categoryData.connectionState == ConnectionState.waiting) {
          return Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Consumer<CategoryProvider>(
          builder: (context, categoryData, _) {
            if (_isInit) {
              if (_firstLogin) {
                if (categoryData.categories.isNotEmpty) {
                  SchedulerBinding.instance!
                      .addPostFrameCallback((_) => showInstructions());
                }
                _isInit = false;
                MySharedPreferences.sharedPreferences
                    .setBool('firstLogin', false);
              }
            }

            return categoryData.categories.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth * 0.32,
                        color: Color(0xFFb9e1ed).withOpacity(0.3),
                        // Theme.of(context).buttonColor.withOpacity(0.9),
                        child: CarouselSlider(
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            // reverse:
                            // aspectRatio: ,
                            height: MediaQuery.of(context).size.height,
                            viewportFraction:
                                SizeConfig.orientation == Orientation.landscape
                                    ? 0.55
                                    : 0.23,
                            // pageSnapping: false,
                            scrollDirection: Axis.vertical,
                            enlargeCenterPage: true,
                            initialPage: categoryData.indexOfSelectedCategory(),
                            onPageChanged: (index, _) {
                              if (categoryData.indexOfSelectedCategory() !=
                                  index)
                                changeCategory(categoryData.categories[index]);
                            },
                          ),
                          items: categoryData.categories
                              .map(
                                (category) => getCategoryDisplay(
                                  category,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      ProductCategories(widget.scaffKey),
                    ],
                  )
                : Center(
                    child: Text("No Categories to display"),
                  );
          },
        );
      },
    );
  }

  removeOverlay() {
    if (!_isRemoved) {
      overlayEntry.remove();
      _isRemoved = true;
    }
  }

  showInstructions() {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      opaque: false,
      // maintainState: true,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, darkTheme, _) {
          return Positioned(
            left: SizeConfig.orientation == Orientation.landscape
                ? SizeConfig.screenWidth * 0.035
                : SizeConfig.screenWidth * 0.033,
            top: SizeConfig.orientation == Orientation.landscape
                ? SizeConfig.screenHeight! * 0.25
                : SizeConfig.screenHeight! * 0.15,
            child: GestureDetector(
              onVerticalDragStart: (dx) {
                removeOverlay();
              },
              child: Container(
                height: SizeConfig.orientation == Orientation.landscape
                    ? SizeConfig.screenHeight! * 0.7
                    : SizeConfig.screenHeight! * 0.8,
                color: darkTheme.darkTheme! ? Colors.white70 : Colors.black54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward_outlined,
                      color: darkTheme.darkTheme! ? Colors.black : Colors.white,
                      size: SizeConfig.orientation == Orientation.landscape
                          ? getProportionateScreenWidth(20)
                          : getProportionateScreenWidth(40),
                      // color: ,
                    ),
                    Text(
                      "Swipe Up",
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: darkTheme.darkTheme!
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: getProportionateScreenWidth(16),
                            ),
                          ),
                    ),
                    SizedBox(
                      height: SizeConfig.orientation == Orientation.landscape
                          ? SizeConfig.screenHeight! * 0.01
                          : SizeConfig.screenHeight! * 0.08,
                    ),
                    Text(
                      "Or",
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: darkTheme.darkTheme!
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: getProportionateScreenWidth(20),
                            ),
                          ),
                    ),
                    SizedBox(
                      height: SizeConfig.orientation == Orientation.landscape
                          ? SizeConfig.screenHeight! * 0.01
                          : SizeConfig.screenHeight! * 0.08,
                    ),
                    Text(
                      "Swipe Down",
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: darkTheme.darkTheme!
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: getProportionateScreenWidth(16),
                            ),
                          ),
                    ),
                    Icon(
                      Icons.arrow_downward_outlined,
                      color: darkTheme.darkTheme! ? Colors.black : Colors.white,
                      size: SizeConfig.orientation == Orientation.landscape
                          ? getProportionateScreenWidth(20)
                          : getProportionateScreenWidth(40),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    overlayState!.insert(overlayEntry);

    Future.delayed(
      Duration(
        seconds: 3,
      ),
    ).then(
      (_) => removeOverlay(),
    );
  }

  changeCategory(Category category) {
    Provider.of<CategoryProvider>(context, listen: false)
        .selectCategory(context, category.id);
  }

  _changeOnClick(Category category) {
    changeCategory(category);
    int page = Provider.of<CategoryProvider>(context, listen: false)
        .indexOfSelectedCategory();
    print("this is $page and ${category.name}");
    buttonCarouselController.animateToPage(page);
  }

  Widget getCategoryDisplay(Category category) {
    return GestureDetector(
      onTap: () {
        print(categoryId);
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 6.0,
          bottom: 6.0,
          right: SizeConfig.orientation == Orientation.landscape ? 20 : 12,
        ),
        child: CategoryCard(
          toShowBottom: true,
          onPress: () {
            _changeOnClick(category);
          },
          category: category,
        ),
      ),
    );
  }
}
