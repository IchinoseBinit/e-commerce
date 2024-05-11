import 'package:collection/collection.dart' show IterableExtension;
import 'package:e_commerce_app/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider() {
    var bright = SchedulerBinding.instance!.window.platformBrightness;
    _themeMode = MySharedPreferences.sharedPreferences.getString('darkTheme') ??
        'system';
    if (_themeMode == 'light') {
      _darkTheme = false;
    } else if (_themeMode == 'dark') {
      _darkTheme = true;
    } else {
      _darkTheme = bright == Brightness.dark
          ? true
          : bright == Brightness.light
              ? false
              : false;
    }

    _colorTheme =
        MySharedPreferences.sharedPreferences.getInt('colorThemeValue') ??
            0xFFFF7643;
    _colorName =
        MySharedPreferences.sharedPreferences.getString('colorNameValue') ??
            "Orange";
  }

  List<ThemeColor> _colorThemeList = [];

  List<ThemeColor> get colorThemeList => [..._colorThemeList];

  List<ThemeColor> _fakeList = [
    ThemeColor(colorName: "Red", colorValue: 0xFFFF0000),
    ThemeColor(colorName: "Green", colorValue: 0xFF00FF00),
    ThemeColor(colorName: "Purple", colorValue: 0xFF800080),
    ThemeColor(colorName: "Blue", colorValue: 0xFF0000FF),
  ];

  // Map<String, int> map = {
  //   ''
  // };
  bool _isInit = true;

  fetchColorThemes() {
    if (_isInit) {
      if (_colorTheme == 0xFFFF7643) {
        _colorThemeList.add(ThemeColor(
            colorName: "Orange", colorValue: 0xFFFF7643, isSelected: true));
      } else {
        _colorThemeList.add(ThemeColor(
            colorName: _colorName, colorValue: _colorTheme, isSelected: true));
        _colorThemeList
            .add(ThemeColor(colorName: "Orange", colorValue: 0xFFFF7643));
      }
      _isInit = false;
    }

    _fakeList.forEach((x) {
      bool toAdd = true;
      _colorThemeList.forEach((color) {
        if (x.colorName == color.colorName) {
          toAdd = false;
        }
      });
      if (toAdd) {
        _colorThemeList
            .add(ThemeColor(colorName: x.colorName, colorValue: x.colorValue));
      }
    });
  }

  bool? _darkTheme;

  int? _colorTheme;
  String? _colorName;
  String? _themeMode;
  String? get themeMode => _themeMode;
  bool? get darkTheme => _darkTheme;
  int? get colorTheme => _colorTheme;
  String? get colorName => _colorName;

  void setDarkTheme(String? value, {Brightness? bright}) {
    if (value == 'light') {
      _darkTheme = false;
    } else if (value == 'dark') {
      _darkTheme = true;
    } else {
      _darkTheme = bright == Brightness.dark
          ? true
          : bright == Brightness.light
              ? false
              : false;
    }
    _themeMode = value;
    MySharedPreferences.sharedPreferences.setString('darkTheme', value!).then(
          (_) => notifyListeners(),
        );
  }

  updateColorTheme(String? name, int? value) {
    _colorName = name;
    _colorTheme = value;
    if (selectThemeColor(name)) {
      MySharedPreferences.sharedPreferences
          .setInt('colorThemeValue', _colorTheme!)
          .then(
            (_) => MySharedPreferences.sharedPreferences
                .setString('colorNameValue', _colorName!)
                .then(
                  (_) => notifyListeners(),
                ),
          );
    }
  }

  ThemeColor? getSelectedThemeColor() {
    ThemeColor? selectedTheme = _colorThemeList
        .firstWhereOrNull((colorTheme) => colorTheme.isSelected == true);
    return selectedTheme;
  }

  bool selectThemeColor(String? name) {
    ThemeColor? oldSelectedThemeColor = getSelectedThemeColor();
    if (oldSelectedThemeColor != null) {
      oldSelectedThemeColor.isSelected = false;
    }
    _colorThemeList.sort((a, b) => a.colorName!.compareTo(b.colorName!));
    int selectedThemeColorIndex = _colorThemeList.indexWhere(
      (oldThemeColor) => oldThemeColor.colorName == name,
    );
    if (selectedThemeColorIndex >= 0) {
      final selectedThemeColor = _colorThemeList[selectedThemeColorIndex];
      selectedThemeColor.isSelected = true;
      _colorThemeList.removeAt(selectedThemeColorIndex);
      _colorThemeList.insert(0, selectedThemeColor);
      print(colorThemeList.length);

      notifyListeners();
      return true;
    }
    return false;
  }
}

class ThemeColor {
  String? colorName;
  int? colorValue;
  bool isSelected;

  ThemeColor({
    this.colorName,
    this.colorValue,
    this.isSelected = false,
  });
}
