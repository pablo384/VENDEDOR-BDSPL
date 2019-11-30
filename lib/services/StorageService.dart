import 'package:shared_preferences/shared_preferences.dart';

import '../index.dart';

class StorageService {
  static final keyConfig = "config-key";
  static final keySession = "session-key";
  static Future<bool> saveConfig(ConfigDataModel arg) async {
    var pref = await SharedPreferences.getInstance();
    return await pref.setString(
        keyConfig, ConfigDataModel.configDataModelToJson(arg));
  }

  static Future<ConfigDataModel> getConfig() async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getString(keyConfig);
    if (data == null) return null;
    return ConfigDataModel.configDataModelFromJson(data);
  }

  static Future<bool> setLogged(bool val) async {
    var pref = await SharedPreferences.getInstance();
    var data = await pref.setBool(keySession, val);
    return data;
  }

  static Future<bool> setVisitedClient(
    String code, {
    bool val = true,
  }) async {
    var pref = await SharedPreferences.getInstance();
    var data = await pref.setBool(code, val);
    return data;
  }

  static Future<bool> getVisitedClient(
    String code,
  ) async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getBool(code);
    if (data == null) return false;
    return data;
  }

  static Future<bool> setNotSellslient(
    String code, {
    bool val = true,
  }) async {
    var pref = await SharedPreferences.getInstance();
    var data = await pref.setBool("s-$code", val);
    return data;
  }

  static Future<bool> getNotSellslient(
    String code,
  ) async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getBool("s-$code");
    if (data == null) return false;
    return data;
  }

  static Future<bool> isLogged() async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getBool(keySession);
    if (data == null) return false;
    return data;
  }
}
