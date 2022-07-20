import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webview/models/general_settings_model.dart';
import 'package:webview/models/getFloatMenu.dart';
import 'package:webview/models/get_setting_update_model.dart';
import 'package:webview/pages/error_pages/server_error.dart';
import 'package:webview/utils/sharedprefe.dart';
import 'package:webview/models/get_introduction_screen_list_model.dart';
import 'package:webview/models/get_menu_list_model.dart';
import 'package:webview/models/get_notification_list_model.dart';
import 'package:webview/models/get_splash_screen_list_model.dart';
import 'package:webview/utils/constants.dart';

class ApiMethods {
  static BuildContext? allcontext;
  static Future login(
      {required String email,
      required String username,
      required String type}) async {
    var response =
        await Dio().post(Constants().mBaseUrl + Constants().getLoginUrl, data: {
      'email': email.toString(),
      'username': username.toString(),
      "type": type.toString(),
      "app_id": Constants().appID
    });
    if (response.statusCode == 200) {
      print("===>" + response.statusCode.toString());
      await SharedPrefe.saveUserProfileData(
          email: email.toString(),
          userName: username.toString(),
          type: type.toString(),
          login: "off");
    } else {
      Navigator.pushReplacement(
        allcontext!,
        MaterialPageRoute(builder: (allcontext) => const ServerError()),
      );
    }
  }

  static GetSettings? getSettingsData;

  static Future<GetSettings?> getSettings() async {
    try {
      Response userData = await Dio().post(
          Constants().mBaseUrl + Constants().getSettingsUrl,
          data: {'app_id': Constants().appID});

      debugPrint("Get Setting Response:$userData");

      return GetSettings.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      } else {
        Navigator.pushReplacement(allcontext!,
            MaterialPageRoute(builder: (allcontext) => const ServerError()));
      }
    }
    return getSettingsData;
  }

  static GetSplashScreenListModel? getSplashScreenListData;

  static Future<GetSplashScreenListModel?> getSplashScreenList(
      BuildContext context) async {
    allcontext = context;
    try {
      Response userData = await Dio().post(
          Constants().mBaseUrl + Constants().getSplashScreenListUrl,
          data: {'app_id': Constants().appID});

      return GetSplashScreenListModel.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      } else {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      }
    }
    return getSplashScreenListData;
  }

  static GetMenuListModel? getMenuListData;
  static Future<GetMenuListModel?> getMenuList() async {
    try {
      Response userData = await Dio().post(
          Constants().mBaseUrl + Constants().getMenuUrl,
          data: {'app_id': Constants().appID});

      getMenuListData = GetMenuListModel.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      } else {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      }
    }
    return getMenuListData;
  }

  static GetIntroductionScreenListModel? getIntroductionScreenListData;

  static Future<GetIntroductionScreenListModel?>
      getIntroductionScreenList() async {
    try {
      Response? userData = await Dio().post(
          Constants().mBaseUrl + Constants().getIntroductionScreenListUrl,
          data: {'app_id': Constants().appID});

      return GetIntroductionScreenListModel.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      } else {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      }
    }
    return getIntroductionScreenListData;
  }

  static GetNotificationListModel? getNotificationListData;

  static Future<GetNotificationListModel?> getNotificationList() async {
    try {
      Response? userData = await Dio().post(
          Constants().mBaseUrl + Constants().getNotificationListUrl,
          data: {'app_id': Constants().appID});

      return GetNotificationListModel.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      } else {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      }
    }
    return getNotificationListData;
  }

  static GeneralSettingsModel? generalSettingsData;

  static Future<GeneralSettingsModel?> generalSettings() async {
    try {
      Response userData = await Dio().post(
          Constants().mBaseUrl + Constants().generalSettings,
          data: {'app_id': Constants().appID});
      debugPrint(userData.toString());
      return GeneralSettingsModel.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      } else {
        Navigator.pushReplacement(allcontext!,
            MaterialPageRoute(builder: (allcontext) => const ServerError()));
      }
    }
    return generalSettingsData;
  }

  static GetFloatMenu? getFloatData;
  static Future<GetFloatMenu?> getFloatList() async {
    try {
      Response userData = await Dio().post(
          Constants().mBaseUrl + Constants().getFloatUrl,
          data: {'app_id': Constants().appID});

      getFloatData = GetFloatMenu.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      } else {
        Navigator.pushReplacement(
          allcontext!,
          MaterialPageRoute(builder: (allcontext) => const ServerError()),
        );
      }
    }
    return getFloatData;
  }
}
