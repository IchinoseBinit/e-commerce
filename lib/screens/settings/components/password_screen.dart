import 'package:e_commerce_app/components/circular_update.dart';
import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/components/form_error.dart';
import 'package:e_commerce_app/constants.dart';
import 'package:e_commerce_app/helper/keyboard.dart';
import 'package:e_commerce_app/providers/Customer.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:e_commerce_app/utilities/log_out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  static const routeName = '/passwordChangeScreen';

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? oldPassword;
  String? password;
  String? confirmPassword;
  bool _toHideOldPassword = true;
  bool _toHidePassword = true;
  bool _toHideConfirmPassword = true;
  String? errorMessage;

  bool _isUpdatingPassword = false;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                buildOldPasswordFormField(),
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
          ),
        ),
      ),
    );
  }

  Widget getButton() {
    return DefaultButton(
      text: "Change",
      press: () async {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       "Please something this that",
        //       textAlign: TextAlign.center,
        //     ),
        //     duration: Duration(seconds: 4),
        //   ),
        // );
        if (_formKey.currentState!.validate()) {
          setState(() => _isUpdatingPassword = !_isUpdatingPassword);
          KeyboardUtil.hideKeyboard(context);
          _formKey.currentState!.save();
          var successResponse =
              await Provider.of<CustomerProvider>(context, listen: false)
                  .updateCustomerPassword(oldPassword!, password!);
          setState(() => _isUpdatingPassword = !_isUpdatingPassword);
          if (successResponse == true) {
            final message = 'Password was changed\n Please sign in again!';
            showSnackbar(message);
            Future.delayed(Duration(seconds: 5)).then(
              (_) => LogOut().logout(context),
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

  TextFormField buildOldPasswordFormField() {
    const oldPasswordError = 'Your old password is empty';
    const oldPasswordLessError =
        'Your old password cannot be less than 8 characters';
    return TextFormField(
      style: Theme.of(context).textTheme.headline4,
      obscureText: _toHideOldPassword,
      textInputAction: TextInputAction.next,
      onSaved: (newValue) => oldPassword = newValue,
      onChanged: (value) {
        if (errorMessage != null) {
          removeError(error: errorMessage);
        }
        if (value.isNotEmpty) {
          removeError(error: oldPasswordError);
        }
        if (value.length >= 8) {
          removeError(error: oldPasswordLessError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          removeError(error: oldPasswordError);
          return "";
        } else if (value.length < 8) {
          addError(error: oldPasswordLessError);
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
        labelText: "Old Password",
        hintText: "Enter your old password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 13.0),
          child: IconButton(
            icon: Icon(
              _toHideOldPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.6),
              size: MediaQuery.of(context).size.width > 460
                  ? getProportionateScreenHeight(50)
                  : getProportionateScreenHeight(25),
            ),
            onPressed: () => setState(
              () => _toHideOldPassword = !_toHideOldPassword,
            ),
          ),
        ),
      ),
    );
  }
}
