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
        .child("rutas/${config.ruta}")
        .reference()
        .runTransaction((MutableData mutableData) async {
      mutableData.value = config.toJson();
      return mutableData;
    });
    return result.committed;
  }

  static login(ConfigDataModel config, String passowrd) async {
    DataSnapshot result =
        await database.reference().child("rutas/${config.ruta}").once();
    print("resultado ${result.value}");

    var indb = ConfigDataModel.fromJson(Map.castFrom(result.value));
    return indb.password == passowrd;
  }

  static Stream<Event> getTodayRouteVisit() {
    return database
        .reference()
        .child("clientes")
        .endAt("4", key: 'SEMANA')
        .onValue;
    // .map((convert) {
    //   print("lisener ${convert.snapshot.value}");
    //   var semana = 0;
    //   if (DateTime.now().day > 0) semana = 1;
    //   if (DateTime.now().day > 7) semana = 2;
    //   if (DateTime.now().day > 14) semana = 3;
    //   if (DateTime.now().day > 23) semana = 4;
    //   var response = [];
    //   var res = Map.castFrom(convert.snapshot.value);
    //   print("lisener 02 ${res.toString()}");
    //   for (var key in res.keys) {
    //     print("semana ${res[key]['SEMANA']}");
    //     if (res[key]['SEMANA'] == semana.toString()) {
    //       response.add({...res[key], "id": key});
    //     }
    //   }
    //   print("lisener 03 ${response.toString()}");
    //   return response.toList();
    // });
  }
}
