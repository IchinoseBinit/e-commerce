import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:e_commerce_app/utilities/back_pressed.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_commerce_app/components/custom_surfix_icon.dart';
import 'package:e_commerce_app/components/form_error.dart';
import 'package:e_commerce_app/helper/keyboard.dart';
import 'package:e_commerce_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:e_commerce_app/screens/login_success/login_success_screen.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../urls.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  @override
  void initState() {
    super.initState();
    final remValue =
        MySharedPreferences.sharedPreferences.getBool('remember') ?? false;
    if (remValue) {
      email = MySharedPreferences.sharedPreferences.getString('email') ?? '';
    }
  }

  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];
  bool _toHidePassword = true;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> signIn() async {
    Map<String, String> requestHeaders = {
      'Content-type':
          'application/json;odata.metadata=minimal;odata.streaming=true',
    };

    Map<String, String?> data = {'email': email, 'password': password};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(data);
    http.Response response = await http.post(
      Uri.parse(signInUrl),
      headers: requestHeaders,
      body: convert.jsonEncode(data),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      print(jsonData);
      await sharedPreferences.setString("token", jsonData);
      await sharedPreferences.setString('email', email!);
      await sharedPreferences.setBool('remember', remember!);
      await sharedPreferences.setBool('firstLogin', true);

      await Provider.of<CustomerProvider>(context, listen: false)
          .fetchDetails(context);
      // Provider.of<HomePageProvider>(context, listen: false)
      //     .fetchHomeProducts(context);
      Navigator.of(context).pushNamedAndRemoveUntil(
          LoginSuccessScreen.routeName, (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pop();
      print(response.body);
      addError(error: kInvalidCredentialsError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // BackPressed().onBackPressedInSignInScreen(context)
      onWillPop: (() =>
          BackPressed().onBackPressed(context).then((value) => value!)),
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: Theme.of(context).buttonColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Container(
                      color: Colors.white.withOpacity(0.1),
                      height: 120,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 10,
                          ),
                          Center(
                              child: Text(
                            "Logging In",
                            style: Theme.of(context).textTheme.headline4,
                          )),
                        ],
                      ),
                    );
                  },
                );
                await signIn();
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: Theme.of(context).textTheme.headline4,
      obscureText: _toHidePassword,
      textInputAction: TextInputAction.done,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kInvalidCredentialsError);

          // return "";
        } else if (value.length >= 8) {
          removeError(error: kInvalidCredentialsError);

          // return "";
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if (value.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: (TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.5,
        )),
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child: IconButton(
            icon: Icon(
              _toHidePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.6),
              size: MediaQuery.of(context).size.width > 460
                  ? getProportionateScreenHeight(50)
                  : getProportionateScreenHeight(25),
            ),
            onPressed: () => setState(
              () => _toHidePassword = !_toHidePassword,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmailFormField() {
    return Container(
      height: MediaQuery.of(context).size.width > 460
          ? getProportionateScreenHeight(140)
          : getProportionateScreenHeight(70),
      child: TextFormField(
        initialValue: email,
        style: Theme.of(context).textTheme.headline4,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSaved: (newValue) => email = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kInvalidCredentialsError);
            // return "";
          } else if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidCredentialsError);
            // return "";
          }
          return null;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return kEmailNullError;
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            return kInvalidEmailError;
          }
          return null;
        },
        decoration: InputDecoration(
          errorStyle: (TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.5,
          )),
          labelText: "Email",
          hintText: "Enter your email",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
        ),
      ),
    );
  }
}
