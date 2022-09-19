class NotificationModel {
  NotificationModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
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
    this.title,
    this.message,
    this.image,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? appId;
  String? title;
  String? message;
  String? image;
  String? url;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        appId: json["app_id"],
        title: json["title"],
        message: json["message"],
        image: json["image"],
        url: json["url"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "title": title,
        "message": message,
        "image": image,
        "url": url,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
