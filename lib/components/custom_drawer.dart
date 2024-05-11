import 'package:e_commerce_app/components/profile_pic.dart';
import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/screens/app_details/app_details.dart';
import 'package:e_commerce_app/screens/category/category.dart';
import 'package:e_commerce_app/screens/home/home_screen.dart';
import 'package:e_commerce_app/screens/orders/order_screen.dart';
import 'package:e_commerce_app/screens/profile/components/help.dart';
import 'package:e_commerce_app/screens/qr_code/qr_code.dart';
import 'package:e_commerce_app/screens/settings/setting_screen.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app/screens/user_details/user_display.dart';
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:e_commerce_app/utilities/database_connector.dart';
import 'package:e_commerce_app/utilities/dialog.dart';
import 'package:e_commerce_app/utilities/log_out.dart';
import 'package:e_commerce_app/utilities/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ConnectDatabase connectDatabase = new ConnectDatabase();

  var isExpanded = false;

  Customer? customer;

  bool _loading = true;
  bool _isLoggedIn = false;

  @override
  initState() {
    customer = Provider.of<CustomerProvider>(context, listen: false).customer;
    if (getLoginStatus()) {
      setState(() {
        _isLoggedIn = getLoginStatus();
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
    showAccounts(context);

    super.initState();
  }

  bool getLoginStatus() {
    final sharedPreferences = MySharedPreferences.sharedPreferences;
    if (sharedPreferences.containsKey('token')) {
      return true;
    }
    return false;
  }

  List<Widget> listOfWidget = [];
  showAccounts(BuildContext context) {
    connectDatabase.getCount().then(
      (userCount) {
        if (userCount > 1) {
          var tempList = [];
          connectDatabase.fetchAllUsers().then(
            (list) {
              for (var obj in list) {
                tempList.add(
                  ListTile(
                    title: Text(obj['fullname']),
                  ),
                );
                setState(
                  () {
                    listOfWidget = tempList.toList() as List<Widget>;
                  },
                );
              }
            },
          );
        } else {
          setState(() {
            listOfWidget.add(
              ListTile(
                leading: Icon(Icons.add_circle, color: Colors.white),
                title: Text(
                  'Add Account',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  MyDialog()
                      .displayDialog(context, "Add Account",
                          "This will log you out of the app!\nAre you sure you want to add account?")
                      .then((decision) {
                    print(decision);
                    if (decision) {
                      LogOut().logout(context);
                    }
                  });
                },
              ),
            );
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Container(
        color: Theme.of(context).cardTheme.color,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: _loading
              ? Container(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _isLoggedIn
                  ? _getLoggedInWidgets(context)
                  : _getLoggedOutWidgets(context),
        ),
      ),
    );
  }

  Widget _getLoggedOutWidgets(BuildContext context) {
    return Column(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).buttonColor.withOpacity(0.9),
          ),
          child: Center(
            child: ProfilePicture(
              isLoggedIn: false,
            ),
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.power_settings_new_outlined,
              // color: Colors.white,
            ),
            title: Text(
              "Log In",
              style: TextStyle(
                  // color: Colors.white,
                  ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(SignInScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.help_outline,
              // color: Colors.white,
            ),
            title: Text(
              "Help",
              style: TextStyle(
                  // color: Colors.white,
                  ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(HelpScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.info_outline,
              // color: Colors.white,
            ),
            title: Text(
              "Details",
              style: TextStyle(
                  // color: Colors.white,
                  ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(AppDetailsScreen.routeName);
            },
          ),
        ),
      ],
    );
  }

  Widget _getLoggedInWidgets(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          color: Theme.of(context).buttonColor.withOpacity(0.9),
          // Color.fromRGBO(155, 156, 163, 0.5),
        ),
        Container(
          color: Theme.of(context).buttonColor.withOpacity(0.9),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer!.userName == null
                          ? "Hello, Binit"
                          : "Hello, ${customer!.firstName}",
                      style: TextStyle(
                        color: Theme.of(context).cardTheme.color,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      customer!.email ?? "No email found",
                      style: TextStyle(
                        // color: Colors.white,
                        color: Theme.of(context).cardTheme.color,
                        fontSize: Theme.of(context).textTheme.caption!.fontSize,
                      ),
                    ),
                  ],
                ),
                ProfilePicture(
                  isLoggedIn: false,
                ),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: Text(
              "Home",
            ),
            onTap: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.person,
            ),
            title: Text(
              "Profile",
            ),
            onTap: () {
              Navigator.of(context).pushNamed(UserDisplayScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text(
              "Your Orders",
            ),
            onTap: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.category_outlined,
            ),
            title: Text(
              "Categories",
            ),
            onTap: () {
              Navigator.of(context).pushNamed(CategoryScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.qr_code,
            ),
            title: Text(
              "QR Code Scanner",
            ),
            onTap: () {
              Navigator.of(context).pushNamed(QrCodeScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.info_outline,
            ),
            title: Text(
              "Details",
            ),
            onTap: () {
              Navigator.of(context).pushNamed(AppDetailsScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.settings,
            ),
            title: Text(
              "Settings",
            ),
            onTap: () {
              Navigator.of(context).pushNamed(SettingScreen.routeName);
            },
          ),
        ),
        Divider(),
        Card(
          child: ListTile(
              leading: Icon(
                Icons.account_circle,
              ),
              title: Text(
                "Switch Account",
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              }),
        ),
        isExpanded
            ? ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: listOfWidget.length,
                itemBuilder: (ctx, index) {
                  return listOfWidget[index];
                },
              )
            : SizedBox(
                height: 0,
              ),
        Divider(),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.power_settings_new_outlined,
            ),
            title: Text(
              "Log Out",
            ),
            onTap: () {
              LogoutDialog().onLogoutPressed(context);
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
