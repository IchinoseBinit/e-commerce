import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/components/profile_pic.dart';
import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/screens/user_details/user_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDisplayScreen extends StatelessWidget {
  static const routeName = '/userDisplayScreen';
  @override
  Widget build(BuildContext context) {
    Customer? customer;
    var initValues = {};

    customer = Provider.of<CustomerProvider>(context, listen: false).customer;
    if (customer != null) {
      initValues = {
        'firstName': customer.firstName,
        'lastName': customer.lastName,
        'email': customer.email ?? 'No email',
        'phone': customer.phoneNumber ?? 'No phone',
        'address': 'No Address',
        'dateOfBirth': customer.dateOfBirth ?? 'No D.O.B.',
      };
    }
    // oldCustomer = Customer.fromMap(customer.toMap());

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: ProfilePicture(
                  isLoggedIn: false,
                ),
              ),
              Divider(),
              Center(
                child: Text(
                  "Hello, ${customer!.firstName} ${customer.lastName}",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text("Email Address"),
                  trailing: Text(
                    initValues['email'].toString(),
                    maxLines: 3,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.place_outlined),
                  title: Text("Address"),
                  trailing: Text(
                    initValues['address'].toString(),
                    maxLines: 3,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.call_outlined),
                  title: Text("Phone Number"),
                  trailing: Text(
                    initValues['phone'].toString(),
                    maxLines: 3,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.date_range_outlined),
                  title: Text("Date of Birth"),
                  trailing: Text(
                    initValues['dateOfBirth'],
                    maxLines: 3,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DefaultButton(
                text: "Edit",
                icon: Icons.edit_outlined,
                press: () {
                  Navigator.of(context).pushNamed(UserDetailScreen.routeName);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
