import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefe {
  static saveUserProfileData(
      {String? email,
      String? userName,
      String? pic,
      String? type,
      String? login}) async {
    final userProfileData = await SharedPreferences.getInstance();
    userProfileData.setString('email', email.toString());
    userProfileData.setString('userName', userName.toString());
    userProfileData.setString('pic', pic.toString());
    userProfileData.setString('type', type.toString());
    userProfileData.setString('login', login.toString());
    print("===>Save success");
  }

  static String? email;
  static String? userName;
  static String? pic;
  static String? type;
  static String? login;

  static readUserProfileData() async {
    final userProfileData = await SharedPreferences.getInstance();

    email = userProfileData.getString("email");
    userName = userProfileData.getString("userName");
    pic = userProfileData.getString("pic");
    type = userProfileData.getString("type");
    login = userProfileData.getString("login");
    debugPrint("====>Read" + email.toString());
  }

  static addStringPre(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static getStringPre(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(key).toString();

    return stringValue;
  }
}
