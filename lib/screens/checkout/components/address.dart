import 'package:e_commerce_app/providers/Address.dart';
import 'package:e_commerce_app/screens/address/address.dart';
import 'package:e_commerce_app/screens/address/components/address_form.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddressDetails extends StatefulWidget {
  const AddressDetails({
    Key? key,
  }) : super(key: key);
  @override
  _AddressDetailsState createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  Future? future;

  @override
  void initState() {
    super.initState();
    future =
        Provider.of<Addresses>(context, listen: false).fetchExistingAddress();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, adddressData) {
          if (adddressData.connectionState == ConnectionState.waiting) {
            return Container(
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(children: [
              Consumer<Addresses>(
                builder: (context, existingAddressData, _) {
                  return existingAddressData.addresses.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AddressFormScreen.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: getProportionateScreenHeight(100),
                            // decoration: BoxDecoration(border: BoxBorder.lerp()),
                            color: Colors.blue.shade200,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    ' Add Address',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: Text(
                            '${existingAddressData.existingAddresses[0]!.firstName} ${existingAddressData.existingAddresses[0]!.lastName}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .color),
                          ),
                          subtitle: Text(
                              '${existingAddressData.existingAddresses[0]!.address1}, ${existingAddressData.existingAddresses[0]!.phoneNumber}'),
                          trailing: GestureDetector(
                            child: Text(
                              'Edit',
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AddressScreen.routeName,
                              );
                            },
                          ),
                        );
                },
              )
            ]),
          );
        });
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             address == null
//                 ? Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Container(
//                       height: 80,
//                       color: Colors.blueAccent.shade100,
//                       child: Center(
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context)
//                                 .pushNamed(AddressFormScreen.routeName);
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.add),
//                               Text(
//                                 "Add Address",
//                                 style: Theme.of(context).textTheme.headline4,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : ListTile(
//                     leading: Icon(
//                       Icons.location_on,
//                       color: Theme.of(context).iconTheme.color,
//                     ),
//                     title: Text(
//                       '${address.firstName} ${address.lastName}',
//                       style: TextStyle(
//                           color: Theme.of(context).textTheme.headline4.color),
//                     ),
//                     subtitle:
//                         Text('${address.address1}, ${address.phoneNumber}'),
//                     trailing: GestureDetector(
//                       child: Text(
//                         'Edit',
//                       ),
//                       onTap: () {
//                         Navigator.of(context)
//                             .pushNamed(AddressScreen.routeName);
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
