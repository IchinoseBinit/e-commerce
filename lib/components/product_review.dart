import 'package:e_commerce_app/components/default_button.dart';
import 'package:e_commerce_app/models/ProductReviewModel.dart';
import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductReview {
  static Future<Map<String, dynamic>> showReviewDialogBox(
    BuildContext context,
  ) {
    var map = Map<String, dynamic>();
    int rating = 0;
    String title = '';
    String review = '';
    final _formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          width: SizeConfig.screenWidth * 0.75,
          height: SizeConfig.orientation == Orientation.landscape
              ? SizeConfig.screenHeight! * 0.75
              : SizeConfig.screenHeight! * 0.45,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
          ),
          child: Form(
            key: _formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // dialog top
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // padding: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                      ),
                      child: new Text(
                        'Rate',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FittedBox(
                      child: RatingBar.builder(
                        initialRating: 0,
                        itemSize: getProportionateScreenWidth(20),
                        direction: Axis.horizontal,
                        // allowHalfRating: false,
                        itemCount: 5,
                        glowColor: Theme.of(context).buttonColor,
                        // ignoreGestures: true,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).buttonColor,
                        ),
                        onRatingUpdate: (val) {
                          rating = val.toInt();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(
                    20,
                  ),
                ),
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Please give a title' : null,
                    onSaved: (value) => title = value!,
                    decoration: InputDecoration(
                      filled: false,
                      contentPadding: new EdgeInsets.all(10),
                      hintText: ' Title',
                      hintStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(
                    20,
                  ),
                ),
                // dialog centre
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    validator: (value) => value!.trim().isEmpty
                        ? 'Please give a proper review'
                        : null,
                    onSaved: (value) => review = value!,
                    maxLines: 3,
                    decoration: InputDecoration(
                      // errorBorder: InputBorder(borderSide: BorderSide.),
                      filled: false,
                      contentPadding: new EdgeInsets.all(10),
                      hintText: ' Add Review',
                      hintStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),

                // dialog bottom
                SizedBox(
                  height: getProportionateScreenHeight(
                    20,
                  ),
                ),
                Expanded(
                  child: DefaultButton(
                    text: 'Rate Product',
                    press: () async {
                      print(rating);
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        map = ProductReviewModel(title, review, rating).toMap();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then(
      (_) => map,
    );
  }
}
