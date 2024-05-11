import 'package:e_commerce_app/providers/Currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyScreen extends StatefulWidget {
  static const routeName = '/currencies';

  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  Future? future;

  @override
  void initState() {
    future =
        Provider.of<CurrencyProvider>(context, listen: false).fetchCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Currency'),
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
            return Consumer<CurrencyProvider>(
              builder: (ctx, currenciesData, child) {
                print(currenciesData.currencies.length);
                return currenciesData.currencies.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              currenciesData.currencies[index].name!,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            trailing: currenciesData
                                        .currencies[index].selected ==
                                    true
                                ? Icon(
                                    Icons.done,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                : SizedBox.shrink(),
                            onTap: () {
                              currenciesData.selectCountry(
                                  currenciesData.currencies[index]);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        itemCount: currenciesData.currencies.length,
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
