class GetSplashScreenListModel {
  int? status;
  String? message;
  List<Result>? result;

  GetSplashScreenListModel({this.status, this.message, this.result});

  GetSplashScreenListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  String? requiredSplashScreen;
  String? title;
  String? titleColor;
  String? splashLogo;
  int? status;
  int? splashImageOrColor;
  String? splashBackground;
  String? createdAt;
  String? updatedAt;

  Result(
      {this.id,
      this.requiredSplashScreen,
      this.title,
      this.titleColor,
      this.splashLogo,
      this.status,
      this.splashImageOrColor,
      this.splashBackground,
      this.createdAt,
      this.updatedAt});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requiredSplashScreen = json['required_splash_screen'];
    title = json['title'];
    titleColor = json['title_color'];
    splashLogo = json['splash_logo'];
    status = json['status'];
    splashImageOrColor = json['splash_image_or_color'];
    splashBackground = json['splash_background'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['required_splash_screen'] = requiredSplashScreen;
    data['title'] = title;
    data['title_color'] = titleColor;
    data['splash_logo'] = splashLogo;
    data['status'] = status;
    data['splash_image_or_color'] = splashImageOrColor;
    data['splash_background'] = splashBackground;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
