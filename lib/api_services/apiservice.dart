import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webview/models/floatmodel.dart';
import 'package:webview/models/generalsettingmodel.dart';
import 'package:webview/models/getsettingmodel.dart';
import 'package:webview/models/intromodel.dart';
import 'package:webview/models/menumodel.dart';
import 'package:webview/models/notificationmodel.dart';
import 'package:webview/models/splashscreenmodel.dart';
import 'package:webview/utils/constants.dart';

import '../models/loginmodel.dart';

class ApiService {
  static BuildContext? allcontext;

  String baseurl = Constants().baseurl;
  late Dio dio;

  ApiService() {
    dio = Dio();
  }

  Future<LoginModel> login(email, username, type) async {
    debugPrint("login fullname:$email");
    debugPrint("login password:$username");
    LoginModel loginmodel;
    String login = "login";

    Response response = await dio.post('$baseurl$login',
        data: FormData.fromMap({
          'email': email,
          'username': username,
          'type': type,
          'app_id': Constants().appID,
        }));

    if (response.statusCode == 200) {
      debugPrint(" login statuscode:===>${response.statusCode}");
      debugPrint(" login Message:===>${response.statusMessage}");
      debugPrint(" login data :===>${response.data}");
      loginmodel = LoginModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }

    return loginmodel;
  }

  Future<GeneralSettingModel> genaralSetting() async {
    GeneralSettingModel generalSettingModel;
    String generalsetting = "general_settings";
    Response response = await dio.post('$baseurl$generalsetting',
        data: FormData.fromMap({
          'app_id': Constants().appID,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("generalsetting apiservice:===>${response.data}");
      generalSettingModel = GeneralSettingModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
    return generalSettingModel;
  }

  Future<GetSettingModel> getSetting() async {
    GetSettingModel getSettingModel;
    String generalsetting = "getSettings";
    Response response = await dio.post('$baseurl$generalsetting',
        data: FormData.fromMap({
          'app_id': Constants().appID,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("GetSetting apiservice:===>${response.data}");
      getSettingModel = GetSettingModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
    return getSettingModel;
  }

  Future<SplashScreenModel> splashScreenList() async {
    SplashScreenModel splashScreenModel;
    String generalsetting = "getSplashScreenList";
    Response response = await dio.post('$baseurl$generalsetting',
        data: FormData.fromMap({
          'app_id': Constants().appID,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("getSplashScreenList apiservice:===>${response.data}");
      splashScreenModel = SplashScreenModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
    return splashScreenModel;
  }

  Future<MenuModel> menuList() async {
    MenuModel menuModel;
    String generalsetting = "getMenuList";
    Response response = await dio.post('$baseurl$generalsetting',
        data: FormData.fromMap({
          'app_id': Constants().appID,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("menuModel apiservice:===>${response.data}");
      menuModel = MenuModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
    return menuModel;
  }

  Future<IntroModel> introList() async {
    IntroModel introModel;
    String generalsetting = "getIntroductionScreenList";
    Response response = await dio.post('$baseurl$generalsetting',
        data: FormData.fromMap({
          'app_id': Constants().appID,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("menuModel apiservice:===>${response.data}");
      introModel = IntroModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
    return introModel;
  }

  Future<NotificationModel> notificationList() async {
    NotificationModel notificationModel;
    String generalsetting = "getNotificationList";
    Response response = await dio.post('$baseurl$generalsetting',
        data: FormData.fromMap({
          'app_id': Constants().appID,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Notification apiservice:===>${response.data}");
      notificationModel = NotificationModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
    return notificationModel;
  }

  Future<FloatModel> floatList() async {
    FloatModel floatModel;
    String generalsetting = "floating_menu";
    Response response = await dio.post('$baseurl$generalsetting',
        data: FormData.fromMap({
          'app_id': Constants().appID,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Notification apiservice:===>${response.data}");
      floatModel = FloatModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
    return floatModel;
  }
}
