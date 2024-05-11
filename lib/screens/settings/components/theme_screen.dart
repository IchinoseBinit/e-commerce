import 'package:e_commerce_app/providers/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  static const routeName = '/themeScreen';

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProvider>(context).themeMode;
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Theme"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCard(context, 'Light', themeMode == 'light'),
            buildCard(context, 'Dark', themeMode == 'dark'),
            buildCard(context, 'System', themeMode == 'system'),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, String name, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (name.toLowerCase() == 'system') {
          var brightness = MediaQuery.of(context).platformBrightness;
          Provider.of<ThemeProvider>(context, listen: false)
              .setDarkTheme(name.toLowerCase(), bright: brightness);
        } else {
          Provider.of<ThemeProvider>(context, listen: false)
              .setDarkTheme(name.toLowerCase());
        }
      },
      child: Card(
        child: ListTile(
          title: Text(
            name,
            style: Theme.of(context).textTheme.headline4,
          ),
          trailing: isSelected
              ? Icon(
                  Icons.done_outlined,
                  color: Theme.of(context).iconTheme.color,
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
