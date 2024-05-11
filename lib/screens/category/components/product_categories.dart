import 'package:e_commerce_app/components/product_card.dart';
import 'package:e_commerce_app/providers/Category.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCategories extends StatefulWidget {
  ProductCategories(this.scaffKey);
  final GlobalKey<ScaffoldState> scaffKey;

  @override
  _ProductCategoriesState createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  Future? future;
  List<DropdownMenuItem<dynamic>>? _sorting;

  List<DropdownMenuItem<dynamic>> getDropDownMenuItems(List<dynamic> _list) {
    List<DropdownMenuItem<dynamic>> items = [];
    for (var obj in _list) {
      items.add(
          new DropdownMenuItem(value: obj, child: new Text(obj.sortingName)));
    }
    return items;
  }

  dynamic _choosedSortingName;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    future = Provider.of<Products>(context, listen: false).fetchCategoryProduct(
        Provider.of<CategoryProvider>(context, listen: true)
            .getSelectedCategory()!
            .id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, categoryProductsData) {
        if (categoryProductsData.connectionState == ConnectionState.waiting) {
          return Container(
            height: 120,
            width: SizeConfig.screenWidth / 2,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Consumer<Products>(
          builder: (context, productsData, _) {
            if (productsData.sortOptions.isNotEmpty) {
              getSortingItems();
            }
            return productsData.categoryProducts.isNotEmpty
                ? SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        // color: Theme.of(context).buttonColor.withOpacity(0.1),
                      ),
                      margin: EdgeInsets.only(
                        top: getProportionateScreenHeight(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productsData.sortOptions.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.only(left: 22),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sort",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(20),
                                      ),
                                      DropdownButton(
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        items: _sorting,
                                        value: _choosedSortingName,
                                        onChanged: (dynamic value) {
                                          setState(
                                            () {
                                              _choosedSortingName = value;
                                              future = Provider.of<Products>(
                                                      context,
                                                      listen: false)
                                                  .sortedCategoryProducts(
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
                          Container(
                            // color: Colors.black,
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: GridView.builder(
                              itemCount: productsData.categoryProducts.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: ProductCard(
                                    scaffKey: widget.scaffKey,
                                    productkey: ValueKey(
                                        '${productsData.categoryProducts[index].id} from category cards'),
                                    product:
                                        productsData.categoryProducts[index],
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              primary: false,

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: SizeConfig.orientation ==
                                        Orientation.landscape
                                    ? 1.6
                                    : 1,
                                mainAxisSpacing: 30,
                              ),
                              // Generate 100 widgets that display their index in the List.
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Text("No Products to display"),
                    ),
                  );
          },
        );
      },
    );
  }
}
