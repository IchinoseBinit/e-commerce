import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowAttributesBottomSheet {
  final _formKey = GlobalKey<FormState>();
  Map<String, String?> values = {
    'name': '',
    'email': '',
    'senderName': '',
    'senderEmail': '',
  };

  Future<Map<String, String?>> displayBottomSheet(
      GlobalKey<ScaffoldState> scaff) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: scaff.currentContext!,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(scaff.currentContext!).viewInsets.bottom,
            ),
            child: GestureDetector(
              onTap: () {},
              child: _showInputFields(ctx),
              // behavior: HitTestBehavior.opaque,
            ),
          );
        });
    return values;
  }

  Widget _showInputFields(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          margin: EdgeInsets.all(12),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        style: Theme.of(context).textTheme.headline4,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          values['name'] = newValue;
                        },
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return 'Please input the recipient name';
                          } else if (value.trim().length < 4) {
                            return 'Recipient name must contains more than 4 letters.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Receipent Name *',
                          hintText: "Enter the Receipent Name",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 23.0),
                            child: Icon(
                              Icons.http_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: getProportionateScreenWidth(25),
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        autofocus: true,
                        style: Theme.of(context).textTheme.headline4,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          values['email'] = newValue;
                        },
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return 'Please input the recipient email';
                          } else if (value.trim().length < 4) {
                            return 'Recipient email must contains more than 4 letters.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Receipent Email *',
                          hintText: "Enter the Receipent Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 23.0),
                            child: Icon(
                              Icons.http_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: getProportionateScreenWidth(25),
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        autofocus: true,
                        style: Theme.of(context).textTheme.headline4,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          values['senderName'] = newValue;
                        },
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return 'Please input the sender name';
                          } else if (value.trim().length < 4) {
                            return 'Sender name must contains more than 4 letters.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Sender Name *',
                          hintText: "Enter the Sender Name",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 23.0),
                            child: Icon(
                              Icons.http_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: getProportionateScreenWidth(25),
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        autofocus: true,
                        style: Theme.of(context).textTheme.headline4,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (newValue) {
                          values['senderEmail'] = newValue;
                        },
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return 'Please input the recipient email';
                          } else if (value.trim().length < 4) {
                            return 'Recipient email must contains more than 4 letters.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Receipent Email *',
                          hintText: "Enter the Receipent Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 23.0),
                            child: Icon(
                              Icons.http_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: getProportionateScreenWidth(25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 160,
                height: 60,
                child: DefaultButton(
                  text: "Add to Wishlist",
                  press: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
