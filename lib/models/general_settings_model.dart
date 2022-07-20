import 'dart:convert';

GeneralSettingsModel generalSettingsFromJson(String str) =>
    GeneralSettingsModel.fromJson(json.decode(str));

String generalSettingsToJson(GeneralSettingsModel data) =>
    json.encode(data.toJson());

class GeneralSettingsModel {
  GeneralSettingsModel({
    required this.status,
    required this.message,
    required this.result,
  });

  int status;
  String message;
  List<Result> result;

  factory GeneralSettingsModel.fromJson(Map<String, dynamic> json) =>
      GeneralSettingsModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.settingsKey,
    required this.settingsValue,
  });

  int id;
  String settingsKey;
  String settingsValue;

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
