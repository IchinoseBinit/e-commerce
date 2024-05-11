import 'package:e_commerce_app/components/circular_update.dart';
import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/components/profile_pic.dart';
import 'package:e_commerce_app/providers/Customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  static String routeName = '/userDetail';
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _isUpdating = false;

  final dateController = TextEditingController();

  Customer? customer;
  var initValues = {};

  @override
  void initState() {
    customer = Provider.of<CustomerProvider>(context, listen: false).customer;
    print("This is $customer");
    if (customer != null) {
      initValues = {
        'firstName': customer!.firstName,
        'lastName': customer!.lastName,
        'email': customer!.email,
        'phone': customer!.phoneNumber,
        'address': '',
        'dateOfBirth': customer!.dateOfBirth,
      };
    }
    // oldCustomer = Customer.fromMap(customer.toMap());

    super.initState();
  }

  void presentDateTimePicker(initialDate) {
    showDatePicker(
      context: context,
      initialDate:
          initialDate == null ? DateTime(2001) : DateTime.parse(initialDate),
      firstDate: DateTime(1900),
      lastDate: DateTime(2011),
    ).then((pickedDate) {
      print("This is picked Date $pickedDate");
      if (pickedDate == null) {
        // addError(error: "Please choose a valid date");
        return;
      }
      setState(() {
        dateController.text = pickedDate.toIso8601String().substring(0, 10);
        customer!.dateOfBirth = pickedDate.toIso8601String();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Your Profile"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ProfilePicture(
                    isLoggedIn: true,
                  ),
                ),
                Divider(),
                TextFormField(
                  autofocus: true,
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: initValues['firstName'],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "First Name",
                    hintText: "Enter your First Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  onChanged: (newValue) => initValues['firstName'] = newValue,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: initValues['lastName'],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "Last Name",
                    hintText: "Enter your Last Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  onChanged: (newValue) => initValues['lastName'] = newValue,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: initValues['email'],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.mail_outline),
                    labelText: "Email Address",
                    hintText: "Enter your Email Address",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (newValue) => initValues['email'] = newValue,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: initValues['address'],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.place_outlined),
                    labelText: "Address",
                    hintText: "Enter your Address",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.streetAddress,
                  // validator: (value) =>
                  //     value.isEmpty ? 'Please enter your address' : null,
                  onChanged: (newValue) => initValues['address'] = newValue,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  // enabled: _canUpdate,
                  initialValue: initValues['phone'],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.call_outlined),
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  // validator: (value) =>
                  //     value.isEmpty ? 'Please enter your phone number' : null,
                  onChanged: (newValue) => customer!.phoneNumber = newValue,
                ),
                GestureDetector(
                  onTap: () {
                    presentDateTimePicker(customer!.dateOfBirth);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      style: Theme.of(context).textTheme.headline4,
                      // initialValue: customer.dateOfBirth,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.date_range_outlined),
                        labelText: "Date Of Birth",
                        hintText: "Enter your Date Of Birth",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      // validator: (value) =>
                      //     value.isEmpty ? 'Please enter your address' : null,
                      onChanged: (newValue) =>
                          initValues['dateOfBirth'] = newValue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: _isUpdating
                      ? CircularUpdate()
                      : DefaultButton(
                          text: "Save",
                          icon: Icons.save_outlined,
                          press: () async {
                            if (initValues['firstName'] ==
                                    customer!.firstName &&
                                initValues['lastName'] == customer!.lastName) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                                  content: Text(
                                    'Cannot Save without Editing fields',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            } else {
                              setState(() => _isUpdating = !_isUpdating);
                              customer!.firstName = initValues['firstName'];
                              customer!.lastName = initValues['lastName'];

                              await Provider.of<CustomerProvider>(context,
                                      listen: false)
                                  .updateCustomer(
                                      customer!, scaffoldKey, context);
                              setState(() => _isUpdating = !_isUpdating);
                            }
                          }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
