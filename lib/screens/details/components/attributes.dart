import 'package:e_commerce_app/providers/ProductAttributes.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Attributes extends StatefulWidget {
  Attributes(this.product, this.scaff);

  final product;
  final GlobalKey<ScaffoldState> scaff;

  @override
  _AttributesState createState() => _AttributesState();
}

class _AttributesState extends State<Attributes> {
  Future? future;

  @override
  void initState() {
    future = Provider.of<ProductAttributeProvider>(context, listen: false)
        .addProductAttribute(context, widget.product);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductAttributeProvider>(
      builder: (context, productAttributesData, _) {
        final listOfProductAttributes = productAttributesData
            .getProductWithAttribute(widget.product.id)!
            .productAttributes;
        return ListView.builder(
          itemCount: listOfProductAttributes.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            final productAttribute = listOfProductAttributes[index];
            // final elements = productAttribute.attributeValuesList;
            // final indexAttribute = productAttribute.hasSelected();

            // int attribIndex;
            // if (indexAttribute != null) {
            //   attribIndex =
            //       productAttribute.attributeValuesList.indexOf(indexAttribute);
            // } else {
            //   attribIndex = 0;
            // }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
              child: buildAttributeSelection(
                productAttributesData,
                productAttribute,
              ),
              // buildListTileSelection(
              //   productAttributesData,
              //   productAttribute,
              // ),
            );
          },
        );
      },
      // child:
    );
  }

  Widget buildListTileSelection(
    dynamic productAttributesData,
    ProductAttribute productAttribute,
  ) {
    return ListTile(
      title: Text(productAttribute.name!),
      subtitle: Text(productAttribute.hasSelected() == null
          ? 'Please select a value'
          : productAttribute.hasSelected()!.name),
      trailing: IconButton(
        icon: Icon(
          Icons.arrow_right_alt_outlined,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () async {
          updateSelectedAttribute(productAttributesData, productAttribute);
        },
      ),
      onTap: () async {
        updateSelectedAttribute(productAttributesData, productAttribute);
      },
    );
  }

  Widget buildAttributeSelection(
    dynamic productAttributesData,
    ProductAttribute productAttribute,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productAttribute.name!,
            style: Theme.of(context).textTheme.headline4,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width > 460
                ? getProportionateScreenHeight(110)
                : getProportionateScreenHeight(50),
            child: GestureDetector(
              onTap: () async {
                updateSelectedAttribute(
                    productAttributesData, productAttribute);
              },
              child: Card(
                borderOnForeground: false,
                child: Center(
                  child: Text(
                    productAttribute.hasSelected() == null
                        ? 'Please select a value'
                        : productAttribute.hasSelected()!.name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _getDropDownMenuItem(value) {
  //   DirectSelectItem<AttributeValues>(
  //       itemHeight: 56,
  //       value: value,
  //       itemBuilder: (context, value) {
  //         return Text(value.name);
  //       });
  // }

  // _getDslDecoration() {
  //   return BoxDecoration(
  //     border: BorderDirectional(
  //       bottom: BorderSide(width: 1, color: Colors.black12),
  //       top: BorderSide(width: 1, color: Colors.black12),
  //     ),
  //   );
  // }

  // List<Widget> _buildItems(List<AttributeValues> elements) {
  //   return elements
  //       .map(
  //         (val) => MySelectionItem(
  //           title: val.name,
  //         ),
  //       )
  //       .toList();
  // }

  buildColumnWithSelect() {
    // Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     Text(productAttribute.name),
    //     DirectSelectList<AttributeValues>(
    //         values: elements,
    //         // defaultItemIndex: 1,
    //         itemBuilder: (AttributeValues value) =>
    //             _getDropDownMenuItem(value),
    //         focusedItemDecoration: _getDslDecoration(),
    //         onItemSelectedListener: (item, index, context) {
    //           // updateSelectedAttribute(
    //           //     productAttributesData, productAttribute);
    //           // );
    //           // Scaffold.of(context).showSnackBar(
    //           //     SnackBar(content: Text(item.name)));
    //         })
    //     DirectSelect(
    //       itemExtent: 50.0,
    //       selectedIndex: attribIndex,
    //       backgroundColor: Colors.white,
    //       child: MySelectionItem(
    //         isForList: false,
    //         title: elements[attribIndex].name,
    //       ),
    //       onSelectedItemChanged: (newIndex) {
    //         print("vaayoooo ~~ mJJ AAYO");
    //         setState(() {
    //           attribIndex = newIndex;
    //         });
    //         // updateSelectedAttribute(
    //         //     productAttributesData, productAttribute);
    //       },
    //       items: _buildItems(elements),
    //     ),
    //     DirectSelect()
    //     DirectSelectList<String>(
    //     values: _cities,
    //     defaultItemIndex: 3,
    //     itemBuilder: (String value) => getDropDownMenuItem(value),
    //     focusedItemDecoration: _getDslDecoration(),
    //     onItemSelectedListener: (item, index, context) {
    //       Scaffold.of(context).showSnackBar(SnackBar(content: Text(item)));
    //     })
    //   ],
    // );
  }

  updateSelectedAttribute(ProductAttributeProvider productData,
      ProductAttribute productAttribute) async {
    final attributeId = await showManualBottomSheet(productAttribute);

    if (attributeId != '') {
      productData.selectAttribute(attributeId, productAttribute);
    }
  }

  showManualBottomSheet(ProductAttribute productAttribute) async {
    String? attributeId = '';
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text.rich(
                  TextSpan(
                    text: "Choose a variant of ",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: <InlineSpan>[
                      TextSpan(
                        text: productAttribute.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

                // Text(
                //   'Select a variant of ${productAttribute.name}',
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
              ),
              GridView.builder(
                itemCount: productAttribute.attributeValuesList.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      productAttribute.attributeValuesList.length > 3
                          ? 3
                          : productAttribute.attributeValuesList.length,
                  childAspectRatio:
                      productAttribute.attributeValuesList.length >= 3
                          ? 1.5 / 1
                          : 2.2 / 1,
                ),
                itemBuilder: (context, index) {
                  final attribute = productAttribute.attributeValuesList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        attributeId = attribute.attributeId;
                        Navigator.of(context).pop();
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 2,
                        color: attribute.isSelected!
                            ? Theme.of(context).buttonColor
                            : Colors.white,
                        shadowColor: attribute.isSelected!
                            ? Theme.of(context).buttonColor
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            attribute.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: attribute.isSelected!
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        });
    return attributeId;
  }
}

class MySelectionItem extends StatelessWidget {
  final String? title;
  final bool isForList;

  const MySelectionItem({Key? key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title!),
    );
  }
}
