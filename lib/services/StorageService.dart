import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendedor/models/index.dart';

class StorageService {
  static final keyConfig = "config-key";
  static Future<bool> saveConfig(ConfigDataModel arg) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString(
        keyConfig, ConfigDataModel.configDataModelToJson(arg));
  }

  static Future<ConfigDataModel> getConfig() async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getString(keyConfig);
    return ConfigDataModel.configDataModelFromJson(data);
  }
}
