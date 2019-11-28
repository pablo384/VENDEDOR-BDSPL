import 'package:firebase_database/firebase_database.dart';
import 'package:vendedor/models/index.dart';

class DatabaseService {
  static FirebaseDatabase database = FirebaseDatabase.instance;
  static openDatabase() {
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
  }

  static saveConfig(ConfigDataModel config) async {
    var result = await database
        .reference()
        .child("ruta_${config.ruta}")
        .reference()
        .runTransaction((MutableData mutableData) async {
      mutableData.value = config.toJson();
      return mutableData;
    });
    return result;
  }
}
