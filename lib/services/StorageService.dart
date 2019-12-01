import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../index.dart';

class StorageService {
  static final keyConfig = "config-key";
  static final keySession = "session-key";
  static final keyCache = "cache-key";
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

  static Future<bool> addToCache(Map val) async {
    var pref = await SharedPreferences.getInstance();
    List cache = pref.getString(keyCache) != null
        ? jsonDecode(pref.getString(keyCache))
        : [];
    cache.add(val);
    var data = await pref.setString(keyCache, jsonEncode(cache));
    return data;
  }

  static Future<dynamic> getCacheFactura() async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getString(keyCache);
    if (data == null) return null;
    return jsonDecode(data);
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

  static Future<void> setWeekAndDay(
    String day,
    String week,
  ) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString("s-week", day);
    await pref.setString("s-day", week);
  }

  static Future<List<String>> getWeekAndDay() async {
    var pref = await SharedPreferences.getInstance();
    var wek = pref.getString("s-week");
    var day = pref.getString("s-day");
    return [day, wek];
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
