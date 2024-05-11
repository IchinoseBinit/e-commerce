import 'package:e_commerce_app/providers/Country.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryScreen extends StatefulWidget {
  static const routeName = '/countries';

  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  Future? future;

  @override
  void initState() {
    future =
        Provider.of<CountryProvider>(context, listen: false).fetchCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Country'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: future,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Consumer<CountryProvider>(
              builder: (ctx, countriesData, child) {
                print(countriesData.states.length);
                return countriesData.states.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              countriesData.states[index].name!,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            trailing: countriesData.states[index].selected ==
                                    true
                                ? Icon(
                                    Icons.done,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                : SizedBox.shrink(),
                            onTap: () {
                              countriesData.selectCountry(
                                  countriesData.states[index].id);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        itemCount: countriesData.states.length,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
