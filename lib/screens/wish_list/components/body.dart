import 'package:e_commerce_app/providers/Product.dart';
import 'package:e_commerce_app/providers/WishList.dart';
import 'package:e_commerce_app/screens/details/details_screen.dart';
import 'package:e_commerce_app/screens/wish_list/components/item_card.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future? wish;
  @override
  void initState() {
    wish = Provider.of<WishListProvider>(context, listen: false)
        .fetchWishLists(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: wish,
      builder: (context, data) {
        if (data.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Consumer<WishListProvider>(builder: (ctx, wishListData, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await wishListData.fetchWishLists(context);
            },
            child: wishListData.wishList.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: ListView.builder(
                      itemCount: wishListData.wishList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Dismissible(
                          key: Key(wishListData.wishList[index].product!.id
                              .toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              Provider.of<Products>(context, listen: false)
                                  .updateProductFavorite(
                                      wishListData.wishList[index].product!.id);
                              Provider.of<WishListProvider>(context,
                                      listen: false)
                                  .removeFromWishList(context,
                                      wishListData.wishList[index].product!.id);
                            });
                          },
                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                SvgPicture.asset("assets/icons/Trash.svg"),
                              ],
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              List<dynamic> args = [
                                ProductDetailsArguments(
                                    product:
                                        wishListData.wishList[index].product),
                                ValueKey(
                                  '${wishListData.wishList[index].product!.id}',
                                )
                              ];

                              Navigator.pushNamed(
                                context,
                                DetailsScreen.routeName,
                                arguments: args,
                              );
                            },
                            child: ItemCard(
                              wishList: wishListData.wishList[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text("No Favorites to display"),
                  ),
          );
        });
      },
    );
  }
}
