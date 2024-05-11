import 'package:e_commerce_app/components/custom_drawer.dart';
import 'package:e_commerce_app/components/product_card.dart';
import 'package:e_commerce_app/providers/Category.dart';
import 'package:e_commerce_app/screens/home/components/home_header.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:e_commerce_app/utilities/searchQuery.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:provider/provider.dart';

class DisplayScreen extends StatefulWidget {
  static String routeName = '/display';

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final scaffKey = new GlobalKey<ScaffoldState>();

  bool _toShowCategory = false;

  Future? future;

  dynamic _choosedSortingName;

  List<DropdownMenuItem<dynamic>>? _sorting;

  List<DropdownMenuItem<dynamic>> getDropDownMenuItems(List<dynamic> _list) {
    List<DropdownMenuItem<dynamic>> items = [];
    for (var obj in _list) {
      items.add(
          new DropdownMenuItem(value: obj, child: new Text(obj.sortingName)));
    }
    return items;
  }

  bool _isInit = true;

  Category? arguments;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      arguments = ModalRoute.of(context)!.settings.arguments as Category?;
      if (arguments == null) {
        future = Provider.of<Products>(context, listen: false)
            .fetchSearchProduct(SearchQuery.queryStringController.text);
        _toShowCategory = false;
      } else {
        future = Provider.of<Products>(context, listen: false)
            .fetchCategoryProduct(arguments!.id);
        _toShowCategory = true;
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void getSortingItems() {
    if (_choosedSortingName == null) {
      _choosedSortingName =
          Provider.of<Products>(context, listen: false).sortOptions[0];
    }
    if (_sorting == null) {
      _sorting = getDropDownMenuItems(
          Provider.of<Products>(context, listen: false).sortOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffKey,
      appBar: _toShowCategory
          ? AppBar(
              title: Text("Products from ${arguments!.name} Category"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : PreferredSize(
              preferredSize: Size(0.0, 0.0),
              child: Container(),
            ),
      drawer: CustomDrawer(),
      body: WillPopScope(
        onWillPop: () {
          setState(() {
            SearchQuery.queryStringController.clear();
          });
          return Future.value(true);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _toShowCategory
                    ? SizedBox.shrink()
                    : SizedBox(height: getProportionateScreenHeight(20)),
                _toShowCategory ? SizedBox.shrink() : HomeHeader(),
                FutureBuilder(
                  future: future,
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Consumer<Products>(
                      builder: (ctx, productsData, child) {
                        if (_toShowCategory) {
                          if (productsData.sortOptions.isNotEmpty) {
                            getSortingItems();
                          }
                        } else {
                          if (productsData.sortOptions.isNotEmpty) {
                            getSortingItems();
                          }
                        }
                        return _toShowCategory
                            ? getCategoryDisplay(productsData)
                            : getSearchDisplay(productsData);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchDisplay(productsData) {
    return productsData.searchProducts.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                productsData.sortOptions.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(left: 22),
                        child: Row(
                          children: [
                            Text(
                              "Sort",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(20),
                            ),
                            DropdownButton(
                              style: Theme.of(context).textTheme.headline4,
                              items: _sorting,
                              value: _choosedSortingName,
                              onChanged: (dynamic value) {
                                setState(
                                  () {
                                    _choosedSortingName = value;
                                    future = Provider.of<Products>(context,
                                            listen: false)
                                        .sortedSearchProducts(
                                            _choosedSortingName.url);
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                GridView.builder(
                  itemCount: productsData.searchProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      scaffKey: scaffKey,
                      productkey: ValueKey(
                          '${productsData.searchProducts[index].id} from search'),
                      product: productsData.searchProducts[index],
                    );
                  },
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        SizeConfig.orientation == Orientation.landscape
                            ? 1.2
                            : 0.78,
                    mainAxisSpacing: 30,
                  ),
                  // Generate 100 widgets that display their index in the List.
                ),
              ],
            ),
          )
        : Container(
            height: 120,
            child: Center(
              child: Text("No Products to display"),
            ),
          );
  }

  Widget getCategoryDisplay(productsData) {
    return productsData.categoryProducts.isNotEmpty
        ? Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Container(
                margin: EdgeInsets.only(left: 22),
                child: Row(
                  children: [
                    Text(
                      "Sort",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    DropdownButton(
                      style: Theme.of(context).textTheme.headline4,
                      items: _sorting,
                      value: _choosedSortingName,
                      onChanged: (dynamic value) {
                        setState(
                          () {
                            _choosedSortingName = value;
                            future =
                                Provider.of<Products>(context, listen: false)
                                    .sortedCategoryProducts(
                                        _choosedSortingName.url);
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              GridView.builder(
                itemCount: productsData.searchProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    scaffKey: scaffKey,
                    productkey: ValueKey(
                        '${productsData.searchProducts[index].id} from category'),
                    product: productsData.categoryProducts[index],
                  );
                },
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85 / 1,
                ),
                // Generate 100 widgets that display their index in the List.
              ),
            ],
          )
        : Container(
            height: 120,
            child: Center(
              child: Text("No Products to display"),
            ),
          );
  }
}
