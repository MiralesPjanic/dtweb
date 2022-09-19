class GeneralSettingModel {
  GeneralSettingModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory GeneralSettingModel.fromJson(Map<String, dynamic> json) =>
      GeneralSettingModel(
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
    this.settingsKey,
    this.settingsValue,
  });

  int? id;
  String? settingsKey;
  String? settingsValue;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        settingsKey: json["settings_key"],
        settingsValue: json["settings_value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "settings_key": settingsKey,
        "settings_value": settingsValue,
      };
}
