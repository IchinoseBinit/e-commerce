import 'package:e_commerce_app/size_config.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme(bool dark, int color) {
  return ThemeData(
    scaffoldBackgroundColor: dark ? Colors.black : Colors.white,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(dark, color),
    textTheme: textTheme(dark),
    iconTheme: iconTheme(dark),
    unselectedWidgetColor: dark ? Colors.white : Colors.black,
    canvasColor: dark ? Colors.black : Colors.white,
    inputDecorationTheme: inputDecorationTheme(dark),
    buttonColor: Color(color),
    cardTheme: cardTheme(dark, color),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: dark ? Colors.white : Colors.black,
    hintColor: dark ? Color(0xffEECED3) : Color(0xff280C0B),
    cardColor: dark ? Colors.white : Color(0xFF151515),
  );
}

InputDecorationTheme inputDecorationTheme(bool dark) {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: dark ? bTextColor : kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme(bool dark) {
  return TextTheme(
    bodyText1: TextStyle(
      color: dark ? bTextColor : kTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      color: dark ? bTextColor : kTextColor,
      // fontSize: 16,
      // fontWeight: FontWeight.w400,
    ),
    headline3: TextStyle(
      color: dark ? bTextColor : kTextColor,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    headline4: TextStyle(
        color: dark ? Colors.white : Colors.black,
        fontSize: SizeConfig.orientation == Orientation.landscape ? 22 : 18),
    caption: TextStyle(color: dark ? bTextColor : kTextColor),
  );
}

IconThemeData iconTheme(bool dark) {
  return IconThemeData(color: dark ? Colors.white : Colors.black);
}

CardTheme cardTheme(bool dark, int color) {
  return CardTheme(
    color: dark ? Colors.black : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        15,
      ),
    ),
  );
}

AppBarTheme appBarTheme(bool dark, int color) {
  return AppBarTheme(
    color: dark ? Colors.black : Color(color),
    elevation: 3,
    centerTitle: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0XFFF3F3F3), fontSize: 18),
    ),
  );
}
