import 'package:e_commerce_app/providers/State.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StateScreen extends StatefulWidget {
  static const routeName = '/states';

  @override
  _StateScreenState createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {
  Future? future;

  @override
  void initState() {
    future = Provider.of<StatesProvider>(context, listen: false).fetchStates();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select State'),
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
            return Consumer<StatesProvider>(
              builder: (ctx, statesData, child) {
                print(statesData.states.length);
                return statesData.states.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              statesData.states[index].name!,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            trailing: statesData.states[index].selected == true
                                ? Icon(
                                    Icons.done,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                : SizedBox.shrink(),
                            onTap: () {
                              statesData
                                  .selectState(statesData.states[index].id);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        itemCount: statesData.states.length,
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
