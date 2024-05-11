import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List faqList = [
    [
      'Why E-commerce app?',
      'It has all the contents that you want to buy and is the best in the business.',
      false
    ],
    [
      'Is the buying possible in weekend days',
      'Our servers work 24/7. So, you can enjoy shopping anytime',
      false
    ],
    [
      'When can we get the discounted rates?',
      'Grab yours best items at a discounted rate during the weekend Sale.',
      false
    ],
    [
      'Something Sale',
      'Something something allthing to a discounted rate.',
      false
    ]
  ];

  // bool isToDisplay = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    faqList[index][0],
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline4!.color,
                        fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      faqList[index][2] ? Icons.remove : Icons.add,
                      color: Theme.of(context).buttonColor,
                      size: 29,
                    ),
                    onPressed: () {
                      setState(() {
                        faqList[index][2] = !faqList[index][2];
                      });
                    },
                  ),
                ),
                faqList[index][2]
                    ? Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          faqList[index][1],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline4!.color,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Container(
                        height: 1,
                        child: Text(""),
                      ),
              ],
            ),
          ),
        );
      },
      itemCount: faqList.length,
    );
  }
}
