class GetSettingModel {
  GetSettingModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory GetSettingModel.fromJson(Map<String, dynamic> json) =>
      GetSettingModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.appId,
    this.appName,
    this.appLogo,
    this.fullScreen,
    this.sideDrawer,
    this.bottomNavigation,
    this.baseUrl,
    this.primary,
    this.primaryDark,
    this.accent,
    this.pullToRefresh,
    this.introductionScreen,
    this.floatingMenuScreen,
    this.createdAt,
    this.updatedAt,
    this.isLogin,
    this.loginWithMobile,
    this.loginWithGmail,
    this.loginWithFacebook,
  });

  int? id;
  String? appId;
  String? appName;
  String? appLogo;
  String? fullScreen;
  String? sideDrawer;
  String? bottomNavigation;
  String? baseUrl;
  String? primary;
  String? primaryDark;
  String? accent;
  String? pullToRefresh;
  String? introductionScreen;
  String? floatingMenuScreen;
  String? createdAt;
  String? updatedAt;
  String? isLogin;
  String? loginWithMobile;
  String? loginWithGmail;
  String? loginWithFacebook;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        appId: json["app_id"],
        appName: json["app_name"],
        appLogo: json["app_logo"],
        fullScreen: json["full_screen"],
        sideDrawer: json["side_drawer"],
        bottomNavigation: json["bottom_navigation"],
        baseUrl: json["base_url"],
        primary: json["primary"],
        primaryDark: json["primary_dark"],
        accent: json["accent"],
        pullToRefresh: json["pull_to_refresh"],
        introductionScreen: json["introduction_screen"],
        floatingMenuScreen: json["floating_menu_screen"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isLogin: json["is_login"],
        loginWithMobile: json["login_with_mobile"],
        loginWithGmail: json["login_with_gmail"],
        loginWithFacebook: json["login_with_facebook"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "app_name": appName,
        "app_logo": appLogo,
        "full_screen": fullScreen,
        "side_drawer": sideDrawer,
        "bottom_navigation": bottomNavigation,
        "base_url": baseUrl,
        "primary": primary,
        "primary_dark": primaryDark,
        "accent": accent,
        "pull_to_refresh": pullToRefresh,
        "introduction_screen": introductionScreen,
        "floating_menu_screen": floatingMenuScreen,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_login": isLogin,
        "login_with_mobile": loginWithMobile,
        "login_with_gmail": loginWithGmail,
        "login_with_facebook": loginWithFacebook,
      };
}
