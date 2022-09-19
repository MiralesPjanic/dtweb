import 'package:flutter/material.dart';
import 'package:webview/models/floatmodel.dart';
import 'package:webview/models/generalsettingmodel.dart';
import 'package:webview/models/getsettingmodel.dart';
import 'package:webview/models/intromodel.dart';
import 'package:webview/models/loginmodel.dart';
import 'package:webview/models/menumodel.dart';
import 'package:webview/models/notificationmodel.dart';
import 'package:webview/models/splashscreenmodel.dart';

import '../api_services/apiservice.dart';
import '../utils/constants.dart';

class ApiProvider extends ChangeNotifier {
  LoginModel loginmodel = LoginModel();
  GeneralSettingModel generalSettingModel = GeneralSettingModel();
  GetSettingModel getSettingModel = GetSettingModel();
  SplashScreenModel splashScreenModel = SplashScreenModel();
  MenuModel menuModel = MenuModel();
  IntroModel introModel = IntroModel();
  NotificationModel notificationModel = NotificationModel();
  FloatModel floatModel = FloatModel();

  bool loading = false;
  String webUrl = Constants.webViewUrl;

  getGeneralsetting() async {
    loading = false;
    generalSettingModel = await ApiService().genaralSetting();
    debugPrint("===>${generalSettingModel.status}");
    loading = true;
    notifyListeners();
  }

  login(email, username, type) async {
    debugPrint("login fullname:$email");
    debugPrint("login password:$username");
    loading = false;
    loginmodel = await ApiService().login(email, username, type);
    debugPrint("login status :== ${loginmodel.status}");
    loading = true;
    notifyListeners();
  }

  getSetting() async {
    loading = false;
    getSettingModel = await ApiService().getSetting();
    debugPrint("login status :== ${getSettingModel.status}");
    loading = true;
    notifyListeners();
  }

  getSplashScreenList() async {
    loading = false;
    splashScreenModel = await ApiService().splashScreenList();
    debugPrint("SplashList status :== ${splashScreenModel.status}");
    loading = true;
    notifyListeners();
  }

  getMenuList() async {
    loading = false;
    menuModel = await ApiService().menuList();
    debugPrint("MenuList status :== ${menuModel.status}");
    loading = true;
    notifyListeners();
  }

  getIntroList() async {
    loading = false;
    introModel = await ApiService().introList();
    debugPrint("introModel status :== ${introModel.status}");
    loading = true;
    notifyListeners();
  }

  getNotificationList() async {
    loading = false;
    notificationModel = await ApiService().notificationList();
    debugPrint("notificationModel status :== ${notificationModel.status}");
    loading = true;
    notifyListeners();
  }

  getFloatList() async {
    loading = false;
    floatModel = await ApiService().floatList();
    debugPrint("floatModel status :== ${floatModel.status}");
    loading = true;
    notifyListeners();
  }

  int currentIndex = 0;
  changeBottomMenu({int? oldIndex}) {
    currentIndex = oldIndex!;
    notifyListeners();
  }

  bool floatingValueCurrent = false;
  floatingOnOff({bool? oldFloatingValue}) {
    floatingValueCurrent = oldFloatingValue!;
    notifyListeners();
  }

  changeWebUrl(String newWebUrl) {
    debugPrint(newWebUrl);
    webUrl = newWebUrl;
    Constants.changeUrl = newWebUrl;
    notifyListeners();
  }

  String? currentUrl;

  changeUrl({String? oldUrl}) {
    currentUrl = oldUrl!;
    notifyListeners();
  }
}
