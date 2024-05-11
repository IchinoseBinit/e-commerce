import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/providers/Theme.dart';
import 'package:e_commerce_app/providers/WishList.dart';
import 'package:e_commerce_app/screens/notifications/notification.dart';
import 'package:e_commerce_app/screens/wish_list/wish_list.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).darkTheme!;
    final isCustomer =
        Provider.of<CustomerProvider>(context, listen: false).customer != null;
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: isDark
                ? Color(0xFF1E1E1E).withOpacity(0.15)
                : Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: MenuState.home == selectedMenu
                        ? Theme.of(context).buttonColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    if (MenuState.home != selectedMenu) {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName(HomeScreen.routeName));
                    }
                  }),
              IconButton(
                icon: isCustomer
                    ? Stack(
                        alignment: Alignment.topRight,
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Heart Icon.svg",
                            color: MenuState.favourite == selectedMenu
                                ? Theme.of(context).buttonColor
                                : inActiveIconColor,
                          ),
                          Consumer<WishListProvider>(
                            builder: (context, wishData, _) {
                              return wishData.wishListCount != 0
                                  ? Positioned(
                                      top: SizeConfig.orientation ==
                                              Orientation.landscape
                                          ? -5
                                          : -3,
                                      right: SizeConfig.orientation ==
                                              Orientation.landscape
                                          ? -20
                                          : -10,
                                      child: Container(
                                        height: SizeConfig.orientation ==
                                                Orientation.landscape
                                            ? getProportionateScreenWidth(10)
                                            : getProportionateScreenWidth(16),
                                        width: getProportionateScreenWidth(16),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).buttonColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 1.5, color: Colors.white),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${wishData.wishListCount}",
                                            style: TextStyle(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      08),
                                              height: 1,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink();
                            },
                          )
                        ],
                      )
                    : Icon(
                        Icons.lock,
                        color: inActiveIconColor,
                      ),
                onPressed: () {
                  if (isCustomer) {
                    if (MenuState.favourite != selectedMenu) {
                      Provider.of<WishListProvider>(context, listen: false)
                          .wishList
                          .clear();
                      if (MenuState.home == selectedMenu) {
                        Navigator.pushNamed(context, WishListScreen.routeName);
                      } else {
                        Navigator.pushNamed(context, WishListScreen.routeName);
                      }
                    }
                  }
                },
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
                onPressed: () {},
              ),
              // IconButton(icon: ,),
              // IconBtnWithCounter(
              //   svgSrc: "assets/icons/Bell.svg",
              //   numOfitem: 3,
              //   press: () =>
              //       Navigator.pushNamed(context, NotificationScreen.routeName),
              // ),

              IconButton(
                icon: Stack(
                  alignment: Alignment.topRight,
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Bell.svg",
                      color: MenuState.notification == selectedMenu
                          ? Theme.of(context).buttonColor
                          : inActiveIconColor,
                    ),
                    Consumer<WishListProvider>(
                      builder: (context, wishData, _) {
                        return wishData.wishListCount != 0
                            ? Positioned(
                                top: MediaQuery.of(context).size.width > 460
                                    ? -5
                                    : -3,
                                right: MediaQuery.of(context).size.width > 460
                                    ? -20
                                    : -10,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width > 460
                                          ? getProportionateScreenWidth(10)
                                          : getProportionateScreenWidth(16),
                                  width: getProportionateScreenWidth(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).buttonColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${wishData.wishListCount == 0 ? 3 : 3}",
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(08),
                                        height: 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                onPressed: () {
                  if (MenuState.notification != selectedMenu) {
                    if (MenuState.home == selectedMenu) {
                      Navigator.pushNamed(
                          context, NotificationScreen.routeName);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, NotificationScreen.routeName);
                    }
                  }
                },
              ),

              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: MenuState.profile == selectedMenu
                      ? Theme.of(context).buttonColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  if (MenuState.profile != selectedMenu) {
                    if (MenuState.home == selectedMenu) {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, ProfileScreen.routeName);
                    }
                  }
                },
              ),
            ],
          )),
    );
  }
}
