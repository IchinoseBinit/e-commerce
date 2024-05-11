import 'package:e_commerce_app/components/circular_update.dart';
import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/providers/Address.dart';
import 'package:e_commerce_app/providers/Country.dart';
import 'package:e_commerce_app/providers/State.dart';
import 'package:e_commerce_app/screens/settings/components/country.dart';
import 'package:e_commerce_app/screens/state_province/state_screen.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressFormScreen extends StatefulWidget {
  static const routeName = '/addressForm';
  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _addressFormKey = GlobalKey<FormState>();

  bool _isUpdating = false;
  bool _isDeleting = false;
  Address? editedAddress = new Address(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    countryId: '',
    stateProvinceId: '',
    city: '',
    address1: '',
    zipPostalCode: '',
    phoneNumber: '',
    createdOn: null,
  );
  var _isInit = true;
  var _initValues = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'countryId': '',
    'stateProvinceId': '',
    'city': '',
    'address1': '',
    'zipPostalCode': '',
    'phoneNumber': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final addressId = ModalRoute.of(context)!.settings.arguments as String?;
      if (addressId != null) {
        editedAddress =
            Provider.of<Addresses>(context, listen: false).findById(addressId);
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Provider.of<CountryProvider>(context, listen: false)
              .selectCountry(editedAddress!.countryId);
          Provider.of<StatesProvider>(context, listen: false)
              .selectState(editedAddress!.stateProvinceId);
        });
        _initValues = {
          'firstName': editedAddress!.firstName!,
          'lastName': editedAddress!.lastName!,
          'email': editedAddress!.email!,
          'countryId': editedAddress!.countryId!,
          'stateProvinceId': editedAddress!.stateProvinceId!,
          'city': editedAddress!.city!,
          'address1': editedAddress!.address1!,
          'zipPostalCode': editedAddress!.zipPostalCode!,
          'phoneNumber': editedAddress!.phoneNumber!,
        };
      } else {
        Provider.of<CountryProvider>(context, listen: false).disSelectCountry();
        Provider.of<StatesProvider>(context, listen: false).disSelectState();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> saveForm() async {
    _addressFormKey.currentState!.save();
    // check here whether the id of the address is present, if present call the update method if '' call the add product
    final country = Provider.of<CountryProvider>(context, listen: false)
        .getSelectedCountry();
    if (country != null) {
      editedAddress!.countryId = country.id;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a country",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }
    final state =
        Provider.of<StatesProvider>(context, listen: false).getSelectedState();
    if (state != null) {
      editedAddress!.stateProvinceId = state.id;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a state",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    if (editedAddress!.id == '') {
      editedAddress!.firstName = _initValues['firstName'];
      editedAddress!.lastName = _initValues['lastName'];
      editedAddress!.phoneNumber = _initValues['phoneNumber'];
      editedAddress!.email = _initValues['email'];
      editedAddress!.city = _initValues['city'];
      editedAddress!.address1 = _initValues['address1'];
      editedAddress!.zipPostalCode = _initValues['zipPostalCode'];
      await Provider.of<Addresses>(context, listen: false)
          .addAddress(editedAddress!);
    } else {
      if (_initValues['firstName'] == editedAddress!.firstName &&
          _initValues['lastName'] == editedAddress!.lastName &&
          _initValues['phoneNumber'] == editedAddress!.phoneNumber &&
          _initValues['email'] == editedAddress!.email &&
          _initValues['countryId'] == editedAddress!.countryId &&
          _initValues['stateProvinceId'] == editedAddress!.stateProvinceId &&
          _initValues['city'] == editedAddress!.city &&
          _initValues['address1'] == editedAddress!.address1 &&
          _initValues['zipPostalCode'] == editedAddress!.zipPostalCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please change some values to update",
              textAlign: TextAlign.center,
            ),
          ),
        );
        return;
      }
      editedAddress!.firstName = _initValues['firstName'];
      editedAddress!.lastName = _initValues['lastName'];
      editedAddress!.phoneNumber = _initValues['phoneNumber'];
      editedAddress!.email = _initValues['email'];
      editedAddress!.city = _initValues['city'];
      editedAddress!.address1 = _initValues['address1'];
      editedAddress!.zipPostalCode = _initValues['zipPostalCode'];
      await Provider.of<Addresses>(context, listen: false)
          .updateAddress(editedAddress!);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        title: Text('Address'),
        actions: editedAddress!.id == ''
            ? <Widget>[]
            : <Widget>[
                _isDeleting
                    ? FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).errorColor,
                        ),
                        onPressed: () async {
                          setState(() => _isDeleting = !_isDeleting);
                          await Provider.of<Addresses>(context, listen: false)
                              .deleteAddress(editedAddress!.id);
                          setState(() => _isDeleting = !_isDeleting);
                          Navigator.of(context).pop();
                        },
                      ),
              ],
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
                  initialValue: _initValues['firstName'],
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
                    _initValues['firstName'] = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: _initValues['lastName'],
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
                    _initValues['lastName'] = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: _initValues['phoneNumber'],
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
                    _initValues['phoneNumber'] = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: _initValues['email'],
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
                    _initValues['email'] = value;
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
                  initialValue: _initValues['city'],
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
                    _initValues['city'] = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: _initValues['address1'],
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
                    _initValues['address1'] = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline4,
                  initialValue: _initValues['zipPostalCode'],
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
                    _initValues['zipPostalCode'] = value;
                  }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                _isUpdating
                    ? CircularUpdate()
                    : Center(
                        child: DefaultButton(
                          text: "Save",
                          press: () async {
                            if (_addressFormKey.currentState!.validate()) {
                              setState(() => _isUpdating = !_isUpdating);
                              await saveForm();
                              setState(() => _isUpdating = !_isUpdating);
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
