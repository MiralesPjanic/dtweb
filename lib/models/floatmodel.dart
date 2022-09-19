class FloatModel {
  FloatModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory FloatModel.fromJson(Map<String, dynamic> json) => FloatModel(
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
    this.name,
    this.link,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? appId;
  String? name;
  String? link;
  String? status;
  String? image;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        appId: json["app_id"],
        name: json["name"],
        link: json["link"],
        status: json["status"],
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "name": name,
        "link": link,
        "status": status,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
