import 'package:flutter/cupertino.dart';

class PasswordModel {
  String? oldPassword;
  String? password;
  String? email;
  String? token;

  PasswordModel.changePassword({
    required this.oldPassword,
    required this.password,
  });

  PasswordModel.passwordRecovery({
    required this.email,
  });

  PasswordModel.confirmPasswordRecovery({
    required this.password,
  });

  Map<String, dynamic> toPasswordRecoveryMap() {
    var map = Map<String, dynamic>();

    map['email'] = email;

    return map;
  }

  Map<String, dynamic> toChangePasswordMap() {
    var map = Map<String, dynamic>();

    map['oldPassword'] = oldPassword;
    map['newPassword'] = password;
    map['confirmNewPassword'] = password;

    return map;
  }

  Map<String, dynamic> toConfirmPasswordMap() {
    var map = Map<String, dynamic>();

    map['newPassword'] = password;
    map['confirmNewPassword'] = password;

    return map;
  }
}
