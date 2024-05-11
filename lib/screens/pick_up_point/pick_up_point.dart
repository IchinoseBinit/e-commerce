import 'package:e_commerce_app/providers/PickUpPoint.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickUpPointScreen extends StatefulWidget {
  static const routeName = 'pickUpPoints';

  @override
  _PickUpPointScreenState createState() => _PickUpPointScreenState();
}

class _PickUpPointScreenState extends State<PickUpPointScreen> {
  Future? future;

  @override
  void initState() {
    future = Provider.of<PickUpPointProvider>(context, listen: false)
        .fetchPickUpPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Pick up Point'),
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
            return Consumer<PickUpPointProvider>(
              builder: (ctx, pickUpPointsData, child) {
                return pickUpPointsData.pickUpPoints.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              pickUpPointsData.pickUpPoints[index].name!,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            trailing: pickUpPointsData
                                        .pickUpPoints[index].selected ==
                                    true
                                ? Icon(
                                    Icons.done,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                : SizedBox.shrink(),
                            onTap: () {
                              pickUpPointsData.selectPickUpPoint(
                                  pickUpPointsData.pickUpPoints[index].id);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        itemCount: pickUpPointsData.pickUpPoints.length,
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
