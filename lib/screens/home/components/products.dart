import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';

import 'package:e_commerce_app/components/product_card.dart';
import 'package:e_commerce_app/providers/Product.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  ProductList(this.scaffKey);

  final GlobalKey<ScaffoldState> scaffKey;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Future? future;
  @override
  void initState() {
    super.initState();
    // future =
    //     Provider.of<Products>(context, listen: false).fetchProducts(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("changed");
    future =
        Provider.of<Products>(context, listen: true).fetchProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    // to clear the objects from memory
    // Provider.of<Products>(context, listen: false).clearProducts();
    return FutureBuilder(
      future: future,
      builder: (ctx, dataSnapshot) {
        // print("this is $dataSnapshot");
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        // if(dataSnapshot.data == null ){
        //   return CircularProgressIndicator();
        // }
        return Consumer<Products>(
          builder: (ctx, productsData, child) {
            print(productsData.products.length);
            return productsData.products.isNotEmpty
                ? GridView.builder(
                    // restorationId: ,
                    itemCount: productsData.products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: ProductCard(
                          width: 220,
                          scaffKey: widget.scaffKey,
                          productkey:
                              ValueKey('${productsData.products[index].id}'),
                          product: productsData.products[index],
                        ),
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
                  )
                : Center(
                    child: Text("No Products to display"),
                  );
          },
        );
      },
    );
  }
}
