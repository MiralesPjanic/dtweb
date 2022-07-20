class GetSettingsModel {
  int? status;
  String? message;
  Result? result;

  GetSettingsModel({this.status, this.message, this.result});

  GetSettingsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? appName;
  String? appLogo;
  String? navigationStyle;
  String? baseUrl;
  String? isLogin;
  String? loginWithMobile;
  String? loginWithGmail;
  String? loginWithFacebook;

  Result(
      {this.appName,
      this.appLogo,
      this.navigationStyle,
      this.baseUrl,
      this.isLogin,
      this.loginWithMobile,
      this.loginWithGmail,
      this.loginWithFacebook});

  Result.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    appLogo = json['app_logo'];
    navigationStyle = json['navigation_style'];
    baseUrl = json['base_url'];
    isLogin = json['is_login'];
    loginWithMobile = json['login_with_mobile'];
    loginWithGmail = json['login_with_gmail'];
    loginWithFacebook = json['login_with_facebook'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['app_logo'] = appLogo;
    data['navigation_style'] = navigationStyle;
    data['base_url'] = baseUrl;
    data['is_login'] = isLogin;
    data['login_with_mobile'] = loginWithMobile;
    data['login_with_gmail'] = loginWithGmail;
    data['login_with_facebook'] = loginWithFacebook;
    return data;
  }
}
