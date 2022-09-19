class SplashScreenModel {
  SplashScreenModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory SplashScreenModel.fromJson(Map<String, dynamic> json) =>
      SplashScreenModel(
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
    this.requiredSplashScreen,
    this.title,
    this.titleColor,
    this.splashLogo,
    this.splashImageOrColor,
    this.splashBackground,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? appId;
  String? requiredSplashScreen;
  String? title;
  String? titleColor;
  String? splashLogo;
  int? splashImageOrColor;
  String? splashBackground;
  int? status;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        appId: json["app_id"],
        requiredSplashScreen: json["required_splash_screen"],
        title: json["title"],
        titleColor: json["title_color"],
        splashLogo: json["splash_logo"],
        splashImageOrColor: json["splash_image_or_color"],
        splashBackground: json["splash_background"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "required_splash_screen": requiredSplashScreen,
        "title": title,
        "title_color": titleColor,
        "splash_logo": splashLogo,
        "splash_image_or_color": splashImageOrColor,
        "splash_background": splashBackground,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
