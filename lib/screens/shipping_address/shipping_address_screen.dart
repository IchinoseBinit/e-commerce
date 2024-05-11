import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/models/ShippingAddress.dart';
import 'package:e_commerce_app/providers/Country.dart';
import 'package:e_commerce_app/providers/PickUpPoint.dart';
import 'package:e_commerce_app/providers/State.dart';
import 'package:e_commerce_app/screens/payment_method/payment_method_screen.dart';
import 'package:e_commerce_app/screens/pick_up_point/pick_up_point.dart';
import 'package:e_commerce_app/screens/settings/components/country.dart';
import 'package:e_commerce_app/screens/shipping_method/shipping_method_screen.dart';
import 'package:e_commerce_app/screens/state_province/state_screen.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:e_commerce_app/utilities/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingAddressFormScreen extends StatefulWidget {
  static const routeName = '/shippingAddressForm';
  @override
  _ShippingAddressFormScreenState createState() =>
      _ShippingAddressFormScreenState();
}

class _ShippingAddressFormScreenState extends State<ShippingAddressFormScreen> {
  final _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _addressFormKey = GlobalKey<FormState>();
  ShippingAddress editedAddress = new ShippingAddress(
      shippingAddressId: '',
      shippingFirstName: '',
      shippingLastName: '',
      shippingEmail: '',
      shippingCountryId: '',
      shippingStateProvinceId: '',
      shippingCity: '',
      shippingAddress1: '',
      shippingZipPostalCode: '',
      shippingPhoneNumber: '',
      pickUpInStore: false,
      pickUpPointId: '',
      shippingId: '',
      shippingCompany: '');
  // var _isInit = true;
  // var _initValues = {
  //   'firstName': '',
  //   'lastName': '',
  //   'email': '',
  //   'countryId': '',
  //   'stateProvinceId': '',
  //   'city': '',
  //   'address1': '',
  //   'zipPostalCode': '',
  //   'phoneNumber': '',
  // };

  @override
  void initState() {
    super.initState();
    Provider.of<CountryProvider>(context, listen: false).disSelectCountry();
    Provider.of<StatesProvider>(context, listen: false).disSelectState();
    Provider.of<PickUpPointProvider>(context, listen: false)
        .disSelectPickUpPoint();
  }

  void saveForm() async {
    LoadingDialog.displayLoadingDialog(context, "Loading");

    if (Provider.of<CountryProvider>(context, listen: false)
                .getSelectedCountry() ==
            null ||
        Provider.of<StatesProvider>(context, listen: false)
                .getSelectedState() ==
            null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please input all the fields"),
        ),
      );
      return;
    }
    _addressFormKey.currentState!.save();
    editedAddress.shippingCountryId =
        Provider.of<CountryProvider>(context, listen: false)
            .getSelectedCountry()!
            .id;
    editedAddress.shippingStateProvinceId =
        Provider.of<StatesProvider>(context, listen: false)
            .getSelectedState()!
            .id;
    if (editedAddress.pickUpInStore!) {
      if (Provider.of<PickUpPointProvider>(context, listen: false)
              .getSelectedPickUpPoint() ==
          null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please input all the fields"),
          ),
        );
        return;
      }
      editedAddress.pickUpPointId =
          Provider.of<PickUpPointProvider>(context, listen: false)
              .getSelectedPickUpPoint()!
              .id;
    } else {
      editedAddress.pickUpPointId = '';
    }
    await editedAddress.postData(context, editedAddress);
    Navigator.of(context).pop();
    editedAddress.pickUpInStore!
        ? Navigator.of(context).pushNamed(PaymentMethodScreen.routeName)
        : Navigator.of(context).pushNamed(ShippingMethodScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        title: Text('Shipping Address'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(20),
            horizontal: getProportionateScreenWidth(10)),
        child: SingleChildScrollView(
          child: Form(
            key: _addressFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: editedAddress.shippingFirstName,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Please enter your first name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value == '' ? 'Please enter your first name' : null,
                  onChanged: ((value) {
                    editedAddress.shippingFirstName = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: editedAddress.shippingLastName,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Please enter your last name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value == '' ? 'Please enter your last name' : null,
                  onChanged: ((value) {
                    editedAddress.shippingLastName = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: editedAddress.shippingPhoneNumber,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Please enter your phone number',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value == '' ? 'Please enter your phone number' : null,
                  onChanged: ((value) {
                    editedAddress.shippingPhoneNumber = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: editedAddress.shippingEmail,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Please enter your email address',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value == '' ? 'Please enter your email' : null,
                  onChanged: ((value) {
                    editedAddress.shippingEmail = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                ListTile(
                  leading: Icon(Icons.location_city,
                      color: Theme.of(context).iconTheme.color),
                  title: Text("Country",
                      style: Theme.of(context).textTheme.headline4),
                  subtitle: Text(
                    Provider.of<CountryProvider>(context)
                                .getSelectedCountry() ==
                            null
                        ? "Choose Country"
                        : Provider.of<CountryProvider>(context)
                            .getSelectedCountry()!
                            .name!,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline4!.color,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_right_alt,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    Navigator.of(context).pushNamed(CountryScreen.routeName);
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                ListTile(
                  leading: Icon(Icons.location_history,
                      color: Theme.of(context).iconTheme.color),
                  title: Text("State",
                      style: Theme.of(context).textTheme.headline4),
                  subtitle: Text(
                    Provider.of<StatesProvider>(context).getSelectedState() ==
                            null
                        ? "Choose State"
                        : Provider.of<StatesProvider>(context)
                            .getSelectedState()!
                            .name!,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline4!.color,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_right_alt,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    Navigator.of(context).pushNamed(StateScreen.routeName);
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: editedAddress.shippingCity,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'Please enter your city',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value == '' ? 'Please enter your city' : null,
                  onChanged: ((value) {
                    editedAddress.shippingCity = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: editedAddress.shippingAddress1,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Please enter your address',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value == '' ? 'Please enter your address' : null,
                  onChanged: ((value) {
                    editedAddress.shippingAddress1 = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: editedAddress.shippingZipPostalCode,
                  decoration: InputDecoration(
                    labelText: 'Zip Code',
                    hintText: 'Please enter your zip code',
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) =>
                      value == '' ? 'Please enter your zip code' : null,
                  onChanged: ((value) {
                    editedAddress.shippingZipPostalCode = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: editedAddress.pickUpInStore,
                      onChanged: (value) {
                        setState(() {
                          editedAddress.pickUpInStore =
                              !editedAddress.pickUpInStore!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Pick Up Store",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                editedAddress.pickUpInStore!
                    ? ListTile(
                        leading: Icon(Icons.location_history,
                            color: Theme.of(context).iconTheme.color),
                        title: Text("Pick Up Point",
                            style: Theme.of(context).textTheme.headline4),
                        subtitle: Text(
                          Provider.of<PickUpPointProvider>(context)
                                      .getSelectedPickUpPoint() ==
                                  null
                              ? "Choose Pickup Point"
                              : Provider.of<PickUpPointProvider>(context)
                                  .getSelectedPickUpPoint()!
                                  .name!,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline4!.color,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_right_alt,
                            color: Theme.of(context).iconTheme.color),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PickUpPointScreen.routeName);
                        },
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: getProportionateScreenHeight(
                      editedAddress.pickUpInStore! ? 30 : 0),
                ),
                Center(
                  child: DefaultButton(
                    text: "Method",
                    icon: Icons.airplanemode_active,
                    press: () {
                      if (_addressFormKey.currentState!.validate()) {
                        saveForm();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
