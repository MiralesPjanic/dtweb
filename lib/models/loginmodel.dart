class LoginModel {
  LoginModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
    this.mobile,
    this.username,
    this.email,
    this.type,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? appId;
  String? mobile;
  String? username;
  String? email;
  String? type;
  int? role;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        appId: json["app_id"],
        mobile: json["mobile"],
        username: json["username"],
        email: json["email"],
        type: json["type"],
        role: json["role"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "mobile": mobile,
        "username": username,
        "email": email,
        "type": type,
        "role": role,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
