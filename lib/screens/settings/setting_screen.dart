import 'package:e_commerce_app/providers/Country.dart';
import 'package:e_commerce_app/providers/Currency.dart';
import 'package:e_commerce_app/providers/Theme.dart';
import 'package:e_commerce_app/screens/address/address.dart';
import 'package:e_commerce_app/screens/color_screen/color_screen.dart';
import 'package:e_commerce_app/screens/settings/components/country.dart';
import 'package:e_commerce_app/screens/settings/components/currency.dart';
import 'package:e_commerce_app/screens/settings/components/password_screen.dart';
import 'package:e_commerce_app/screens/settings/components/theme_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text("Settings")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  title: Text("Country",
                      style: Theme.of(context).textTheme.bodyText1),
                  subtitle: Text(
                    Provider.of<CountryProvider>(context)
                                .getSelectedCountry() ==
                            null
                        ? 'No country selected'
                        : Provider.of<CountryProvider>(context)
                            .getSelectedCountry()!
                            .name!,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  trailing: Icon(Icons.arrow_right_alt_outlined,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    Navigator.of(context).pushNamed(CountryScreen.routeName);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Currency",
                      style: Theme.of(context).textTheme.bodyText1),
                  subtitle: Text(
                    Provider.of<CurrencyProvider>(context)
                                .getSelectedCurrency() ==
                            null
                        ? 'No Currency selected'
                        : Provider.of<CurrencyProvider>(context)
                            .getSelectedCurrency()!
                            .name!,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  trailing: Icon(Icons.arrow_right_alt_outlined,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    Navigator.of(context).pushNamed(CurrencyScreen.routeName);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Address Book",
                      style: Theme.of(context).textTheme.bodyText1),
                  trailing: Icon(Icons.arrow_right_alt_outlined,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    Navigator.of(context).pushNamed(AddressScreen.routeName);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Change Password",
                      style: Theme.of(context).textTheme.bodyText1),
                  trailing: Icon(
                    Icons.arrow_right_alt_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(PasswordScreen.routeName);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    "Language",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Icon(Icons.arrow_right_alt_outlined,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    // Navigator.of(context).pushNamed(CurrencyScreen.routeName);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    "General",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Icon(Icons.arrow_right_alt_outlined,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    // Navigator.of(context).pushNamed(CurrencyScreen.routeName);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    "Policies",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Icon(Icons.arrow_right_alt_outlined,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    // Navigator.of(context).pushNamed(CurrencyScreen.routeName);
                  },
                ),
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeData, child) {
                  return Card(
                    child: ListTile(
                      title: Text("Dark Theme",
                          style: Theme.of(context).textTheme.bodyText1),
                      trailing: Text(
                        themeData.themeMode!.toLowerCase(),
                      ),
                      onTap: () => Navigator.of(context)
                          .pushNamed(ThemeScreen.routeName),
                      // trailing: Switch(
                      //   value: themeData.darkTheme!,
                      //   activeTrackColor: Colors.purple,
                      //   activeColor: Colors.purpleAccent,
                      //   onChanged: ((value) {
                      //     themeData.darkTheme = value;
                      //   }),
                      // ),
                    ),
                  );
                },
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeData, child) {
                  return Card(
                    child: ListTile(
                      title: Text("Color",
                          style: Theme.of(context).textTheme.bodyText1),
                      subtitle: Text(
                        themeData.colorName!,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      trailing: Icon(Icons.arrow_right_alt_outlined,
                          color: Theme.of(context).iconTheme.color),
                      onTap: () {
                        Navigator.of(context).pushNamed(ColorScreen.routeName);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
