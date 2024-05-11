import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/screens/splash/splash_loading.dart';
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';

class ShowBottomSheet {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> _saveForm() async {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
    final url = _urlController.text;
    try {
      Uri.parse(url);
      await MySharedPreferences.sharedPreferences.setString('url', url);
      return true;
    } catch (e) {
      print("Exception aayohai");
      return false;
    }
    // if (url.contains(new RegExp(
    //     "((http|https)://)(www.)?”+ “[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]”+ “{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)"))) {
    // } else {
    // }
  }

  showBottomModal(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: GestureDetector(
              onTap: () {},
              child: _showUrlInputTextField(ctx),
              // behavior: HitTestBehavior.opaque,
            ),
          );
        });
  }

  Widget _showUrlInputTextField(BuildContext context) {
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
                  child: TextFormField(
                    autofocus: true,
                    style: Theme.of(context).textTheme.headline4,
                    keyboardType: TextInputType.url,
                    onSaved: (newValue) {
                      _urlController.text = newValue!;
                    },
                    validator: (String? value) {
                      if (value!.trim().isEmpty) {
                        return 'Please input the url';
                      } else if (value.trim().length < 4) {
                        return 'url must contains more than 4 letters.';
                      }
                      // else if (!value.trim().contains(new RegExp(
                      //     "((http|https)://)(www.)?”+ “[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]”+ “{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)+"))) {
                      //   return 'please enter a valid url';
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Url *',
                      hintText: "Enter the Url",
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
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 180,
                height: 60,
                child: DefaultButton(
                  text: "Save Url",
                  press: () async {
                    if (await _saveForm()) {
                      print("hello");
                      Navigator.of(context)
                          .pushReplacementNamed(SplashLoadingScreen.routeName);
                    }
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
