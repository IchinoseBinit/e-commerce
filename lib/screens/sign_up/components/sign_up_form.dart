import 'package:e_commerce_app/helper/keyboard.dart';
import 'package:e_commerce_app/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app/urls.dart';
import 'package:e_commerce_app/utilities/api_calls.dart';
import 'package:flutter/material.dart';

import 'package:e_commerce_app/components/custom_surfix_icon.dart';
import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/components/form_error.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirmPassword;
  bool _toHidePassword = true;
  bool _toHideConfirmPassword = true;

  bool remember = false;
  var newUser = {
    'username': '',
    'email': '',
    'deleted': false,
    'gender': null,
    'firstName': '',
    'lastName': '',
    'dateOfBirth': null,
  };

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

  void saveUser() async {
    _formKey.currentState!.save();

    // use this later
    // newUser['dateOfBirth'] = DateFormat.yMd().format(newUser['dateOfBirth']);
    // // converting the dateofbirth dateformat to string
    // final registeredUser =
    //     await ApiCalls().postDataWithNoToken(registerUrl, newUser);
    // //registering the user with the data from form.
    // newUser['dateOfBirth'] = DateFormat.yMd().parse(newUser['dateOfBirth']);
    // // parsing the date string to dateformat
    // if (!registeredUser) {
    //   return;
    // }
    // final jsonPassword = {
    //   'password': password,
    // };
    // final setPasswordUrl = '$customerUrl/(${newUser['email']})/SetPassword';
    // // setting the password of the user
    // final setPasswordResponse =
    //     await ApiCalls().postDataWithNoToken(setPasswordUrl, jsonPassword);
    // // if the http response is success, the token is registered. Else the method ends here.
    // if (!setPasswordResponse) {
    //   return;
    // }

    final tokenBody = {
      'email': newUser['email'],
      'password': password,
      'confirmPassword': password
    };
    // registering the token for a user for the first time.
    final response =
        await ApiCalls().postDataWithNoToken(registerTokenUrl, tokenBody);
    if (response != null) {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    } else {
      Navigator.of(context).pop();
      addError(error: "Cannot register at the moment");
    }
    // after registering the token the user is redirected to the sign in screen
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // onWillPop: () => BackPressed().onBackPressed(context),
      key: _formKey,
      child: Column(
        children: [
          // buildUserNameFormField(),
          // SizedBox(height: getProportionateScreenHeight(30)),
          // buildFullNameFormField(),
          // SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Text(
          //         "Gender: ",
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //       ),
          //       SizedBox(
          //         width: getProportionateScreenWidth(10),
          //       ),
          //       buildGenderDropdownField(),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: getProportionateScreenHeight(10),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Row(
          //     children: [
          //       FlatButton(
          //         padding: const EdgeInsets.symmetric(horizontal: 0),
          //         child: Text(
          //           newUser['dateOfBirth'] == null
          //               ? 'Choose D.O.B.'
          //               : 'Change Date',
          //           style: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         textColor: Colors.orange,
          //         onPressed: () {
          //           presentDateTimePicker(newUser['dateOfBirth']);
          //         },
          //       ),
          //       Spacer(),
          //       Text(
          //         newUser['dateOfBirth'] == null
          //             ? 'No Date Chosen!'
          //             : 'Date of Birth: ${DateFormat.yMd().format(newUser['dateOfBirth'])}',
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //       ),
          //     ],
          //   ),
          // ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
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
                            "Signing Up",
                            style: Theme.of(context).textTheme.headline4,
                          )),
                        ],
                      ),
                    );
                  },
                );
                saveUser();
              }
            },
          ),
        ],
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
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
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
        style: Theme.of(context).textTheme.headline4,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSaved: (newValue) => newUser['email'] = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          } else if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidEmailError);
          }
          return null;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            addError(error: kInvalidEmailError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
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

  // TextFormField buildUserNameFormField() {
  //   return TextFormField(
  //     style: Theme.of(context).textTheme.headline4,
  //     keyboardType: TextInputType.name,
  //     onSaved: (newValue) => newUser['username'] = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kNamelNullError);
  //       } else if (value.length > 4) {
  //         removeError(error: kInvalidNameError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kNamelNullError);
  //         return "";
  //       } else if (value.length <= 4) {
  //         addError(error: kInvalidNameError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "UserName",
  //       hintText: "Enter your User Name",
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: Padding(
  //         padding: const EdgeInsets.only(right: 23.0),
  //         child: Icon(
  //           Icons.person,
  //           color: Theme.of(context).iconTheme.color,
  //           size: getProportionateScreenWidth(25),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // TextFormField buildFullNameFormField() {
  //   return TextFormField(
  //     style: Theme.of(context).textTheme.headline4,
  //     keyboardType: TextInputType.name,
  //     onSaved: (newValue) {
  //       var names = newValue.split(' ');
  //       newUser['firstName'] = names[0];
  //       newUser['lastName'] = names[1];
  //     },
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kFullNameNullError);
  //       } else if (value.length > 6) {
  //         removeError(error: kInvalidFullNameError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kFullNameNullError);
  //         return "";
  //       } else if (value.length <= 6) {
  //         addError(error: kInvalidFullNameError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Full Name",
  //       hintText: "Enter your Full Name",
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: Padding(
  //         padding: const EdgeInsets.only(right: 23.0),
  //         child: Icon(
  //           Icons.contact_mail,
  //           color: Theme.of(context).iconTheme.color,
  //           size: getProportionateScreenWidth(25),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget buildGenderDropdownField() {
  //   return DropdownButton<String>(
  //     items: <String>['Male', 'Female', 'Other'].map((String value) {
  //       return new DropdownMenuItem<String>(
  //         value: value,
  //         child: new Text(value),
  //       );
  //     }).toList(),
  //     hint: Text(
  //       'Male',
  //       style: Theme.of(context).textTheme.headline4,
  //     ),
  //     style: Theme.of(context).textTheme.headline4,
  //     value: newUser['gender'] ?? 'Male',
  //     onChanged: (value) {
  //       setState(() {
  //         newUser['gender'] = value;
  //       });
  //     },
  //   );
  // }

  // void presentDateTimePicker(initialDate) {
  //   showDatePicker(
  //     context: context,
  //     initialDate: initialDate == null ? DateTime(2001) : initialDate,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2011),
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       addError(error: "Please choose a valid date");
  //     }
  //     if (pickedDate != null) {
  //       removeError(error: "Please choose a valid date");
  //     }
  //     setState(() {
  //       newUser['dateOfBirth'] = pickedDate;
  //     });
  //   });
  // }
}
