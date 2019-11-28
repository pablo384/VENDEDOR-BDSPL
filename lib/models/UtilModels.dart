import 'dart:convert';

class ConfigDataModel {
  String email;
  String password;
  String ruta;

  ConfigDataModel({
    this.email,
    this.password,
    this.ruta,
  });

  factory ConfigDataModel.fromJson(Map<String, dynamic> json) =>
      new ConfigDataModel(
        email: json["email"],
        password: json["password"],
        ruta: json["ruta"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "ruta": ruta,
      };

  static ConfigDataModel configDataModelFromJson(String str) {
    final jsonData = json.decode(str);
    return ConfigDataModel.fromJson(jsonData);
  }

  static String configDataModelToJson(ConfigDataModel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }
}
