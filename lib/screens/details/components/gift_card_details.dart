import 'package:e_commerce_app/providers/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GiftCardDetails extends StatefulWidget {
  GiftCardDetails(this.formKey);

  final GlobalKey<FormState> formKey;
  @override
  _GiftCardDetailsState createState() => _GiftCardDetailsState();
}

class _GiftCardDetailsState extends State<GiftCardDetails> {
  Map<String, String?> values = {
    // 'name': '',
    // 'email': '',
    // 'senderName': '',
    // 'senderEmail': '',
  };

  @override
  void initState() {
    values = Provider.of<Products>(context, listen: false).values;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 0,
        child: Container(
          margin: EdgeInsets.all(12),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Form(
                  key: widget.formKey,
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
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
