import 'package:e_commerce_app/providers/Address.dart';
import 'package:e_commerce_app/screens/address/components/address_form.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AddressFormScreen.routeName);
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
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Divider(),
          Consumer<Addresses>(
            builder: (context, addressData, _) {
              return addressData.addresses.isEmpty
                  ? Center(
                      child: Text(
                        "No Address found, Please add some!",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                  : getAddressList(context, addressData);
            },
          )
        ],
      ),
    );
  }

  Widget getAddressList(BuildContext context, Addresses addressData) {
    final addresses = addressData.addresses;
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            addressData.deleteAddress(addresses[index]!.id).then((message) {
              if (message.toString().isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      message.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            });
          },
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xFFFFE6E6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Spacer(),
                SvgPicture.asset("assets/icons/Trash.svg"),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 5.0,
            ),
            child: Card(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  onTap: () {
                    Provider.of<Addresses>(context, listen: false)
                        .selectAddress(addresses[index]!.id);
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.location_on,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${addresses[index]!.firstName} ${addresses[index]!.lastName}',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        '${addresses[index]!.phoneNumber}',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${addresses[index]!.city} ${addresses[index]!.address1}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline4!.color,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          AddressFormScreen.routeName,
                          arguments: addresses[index]!.id);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
