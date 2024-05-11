import 'package:e_commerce_app/components/coustom_bottom_nav_bar.dart';
import 'package:e_commerce_app/enums.dart';
import 'package:e_commerce_app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "/notification";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List list = [
    [
      'Black Friday Sale',
      'Grab yours wishlist items at a reduced rate during the Black Friday Sale. Don\'t miss out',
      'https://www.consultantsreview.com/newstransfer/upload/zwhz1Black-Friday-Sale.jpg'
    ],
    [
      'Valentine\'s Day Offer',
      'Buy Chocolotes, roses and other items in this week and get discounted price.',
      'https://www.dealdaddy.shop/wp-content/uploads/Valentines-Day-Gift-Offer-2020-his-or-her-599x313.jpg'
    ],
    [
      'Weekend Sale',
      'Grab yours best items at a discounted rate during the weekend Sale.',
      'https://i.ytimg.com/vi/ub1CQZBPWYY/maxresdefault.jpg'
    ],
    [
      'Something Sale',
      'Something something allthing to a discounted rate.',
      'https://image.shutterstock.com/image-vector/brush-sale-banner-vector-260nw-1090866878.jpg'
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          "Notifications",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onPanUpdate: ((dis) {
          if (dis.delta.dx > 0) {
            //User swiped from left to right
            Navigator.of(context).pop();
          } else if (dis.delta.dx < 0) {
            //User swiped from right to left
            Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
          }
        }),
        child: list.isEmpty
            ? Center(
                child: Text(
                  "No Notifications available, Please check back later.",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      elevation: 0,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.notifications,
                              color: Colors.red,
                              size: 28,
                            ),
                            title: Text(
                              list[index][0],
                              style: TextStyle(
                                fontSize: 20,
                                color:
                                    Theme.of(context).textTheme.headline4!.color,
                              ),
                            ),
                            // isThreeLine: true,
                            // trailing: IconButton(
                            //   icon: Icon(Icons.arrow_right_outlined),
                            //   onPressed: () {},
                            // ),
                          ),
                          Container(
                            child: Image.network(
                              list[index][2].toString(),
                              width: double.infinity,
                              height: 140,
                              fit: BoxFit.fill,
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : LinearProgressIndicator();
                              },
                            ),
                          ),
                          Container(
                            child: Text(
                              list[index][1],
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: list.length,
              ),
      ),
      bottomNavigationBar:
          CustomBottomNavBar(selectedMenu: MenuState.notification),
    );
  }
}
