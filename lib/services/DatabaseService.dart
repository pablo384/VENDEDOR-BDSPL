import 'package:firebase_database/firebase_database.dart';

import '../index.dart';

class DatabaseService {
  static FirebaseDatabase database = FirebaseDatabase.instance;
  static Stream<Event> getTodayRouteVisit() {
    return database
        .reference()
        .child("clientes")
        .endAt("4", key: 'SEMANA')
        .onValue;
  }

  static login(ConfigDataModel config, String passowrd) async {
    DataSnapshot result =
        await database.reference().child("rutas/${config.ruta}").once();
    print("resultado ${result.value}");

    var indb = ConfigDataModel.fromJson(Map.castFrom(result.value));
    return indb.password == passowrd;
  }

  static openDatabase() {
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
  }

  static saveConfig(ConfigDataModel config) async {
    var result = await database
        .reference()
        .child("rutas/${config.ruta}")
        .reference()
        .runTransaction((MutableData mutableData) async {
      mutableData.value = config.toJson();
      return mutableData;
    });
    return result.committed;
  }
}
