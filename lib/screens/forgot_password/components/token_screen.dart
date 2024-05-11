import 'package:e_commerce_app/components/circular_update.dart';
import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/components/form_error.dart';
import 'package:e_commerce_app/constants.dart';
import 'package:e_commerce_app/helper/keyboard.dart';
import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TokenScreen extends StatelessWidget {
  const TokenScreen(this.email);

  final email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recovery'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Enter the token received in your email.\nYour email may take few minutes to arrive.",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.01,
              ),
              TokenFormFields(email),
            ],
          ),
        ),
      ),
    );
  }
}

class TokenFormFields extends StatefulWidget {
  const TokenFormFields(this.email);

  final email;

  @override
  _TokenFormFieldsState createState() => _TokenFormFieldsState();
}

class _TokenFormFieldsState extends State<TokenFormFields> {
  final _formKey = GlobalKey<FormState>();
  bool _isUpdatingPassword = false;
  bool _toHideConfirmPassword = true;
  bool _toHidePassword = true;
  String? token;
  String? password;
  String? confirmPassword;
  String? errorMessage;

  final List<String?> errors = [];

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          buildTokenFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          _isUpdatingPassword ? CircularUpdate() : getButton(),
        ],
      ),
    );
  }

  Widget getButton() {
    return DefaultButton(
      text: "Recover",
      press: () async {
        if (_formKey.currentState!.validate()) {
          setState(() => _isUpdatingPassword = !_isUpdatingPassword);
          KeyboardUtil.hideKeyboard(context);
          _formKey.currentState!.save();
          var successResponse =
              await Provider.of<CustomerProvider>(context, listen: false)
                  .recoverPassword(token!, widget.email!, password!);
          print(successResponse);
          setState(() => _isUpdatingPassword = !_isUpdatingPassword);
          if (successResponse == true) {
            final message = 'Password was changed\n Please sign in!';
            showSnackbar(message);
            Future.delayed(Duration(seconds: 5)).then(
              (_) => Navigator.of(context).pushReplacementNamed(
                SignInScreen.routeName,
              ),
            );
          } else {
            errorMessage = (successResponse as List)[0].toString();
            addError(error: errorMessage);
          }
        }
      },
    );
  }

  showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          // style: Theme.of(context).textTheme.headline4,
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  TextFormField buildTokenFormField() {
    const tokenNullError = 'Please enter the token received in mail';
    const tokenShortError = 'Your token is too short';
    return TextFormField(
      style: Theme.of(context).textTheme.headline4,
      textInputAction: TextInputAction.next,
      onSaved: (newValue) => token = newValue,
      onChanged: (value) {
        if (errorMessage != null) {
          removeError(error: errorMessage);
        }
        if (value.isNotEmpty) {
          removeError(error: tokenNullError);
        }
        if (value.length >= 8) {
          removeError(error: tokenShortError);
        }
        token = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: tokenNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: tokenShortError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Token",
        hintText: "Enter the token",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Icon(
            Icons.vpn_key_outlined,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.6),
            size: MediaQuery.of(context).size.width > 460
                ? getProportionateScreenHeight(50)
                : getProportionateScreenHeight(25),
          ),
        ),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      style: Theme.of(context).textTheme.headline4,
      obscureText: _toHideConfirmPassword,
      textInputAction: TextInputAction.done,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.isNotEmpty && password == confirmPassword) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
        // newUser['']
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child: IconButton(
            icon: Icon(
              _toHideConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.6),
              size: MediaQuery.of(context).size.width > 460
                  ? getProportionateScreenHeight(50)
                  : getProportionateScreenHeight(25),
            ),
            onPressed: () => setState(
              () => _toHideConfirmPassword = !_toHideConfirmPassword,
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: Theme.of(context).textTheme.headline4,
      obscureText: _toHidePassword,
      textInputAction: TextInputAction.next,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: (TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.5,
        )),
        labelText: "New Password",
        hintText: "Enter your new password",
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
}
