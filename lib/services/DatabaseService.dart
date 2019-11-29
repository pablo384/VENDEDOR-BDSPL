import 'package:firebase_database/firebase_database.dart';

import '../index.dart';

class DatabaseService {
  static FirebaseDatabase database = FirebaseDatabase.instance;
  static Stream<Event> getProducts() {
    return database.reference().child("productos").onValue;
  }

  static Future<List<ProductDataModel>> getProductsOnce() async {
    var result = await database.reference().child("productos").once();
    // print("resultado:getProductsOnce: ${result.value}");
    // var pro = Map.castFrom(result.value);
    var lsPro =
        ProductDataModel.productDataModelsFromMap(Map.castFrom(result.value));
    // print("resultado:getProductsOnce: ${lsPro.toString()}");
    return lsPro;
  }

  static Stream<Event> getClients() {
    return database.reference().child("clientes").onValue;
  }

  static login(ConfigDataModel config, String passowrd) async {
    DataSnapshot result =
        await database.reference().child("rutas/${config.ruta}").once();
    print("resultado ${result.value}");

    var indb = ConfigDataModel.fromJson(Map.castFrom(result.value));
    return indb.password == passowrd;
  }

  static Future<int> getBillLenght() async {
    var config = await StorageService.getConfig();
    DataSnapshot result =
        await database.reference().child("facturas/${config.ruta}").once();
    // print("resultado::getBillLenght:: ${result.value}");
    // print("resultado::getBillLenght:: ${Map.castFrom(result.value).length}");
    return result.value != null ? Map.castFrom(result.value).length : 0;
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

  static saveBill(Factura factura) async {
    var config = await StorageService.getConfig();
    var result = await database
        .reference()
        .child("facturas/${config.ruta}/${factura.codigo}")
        .reference()
        .runTransaction((MutableData mutableData) async {
      mutableData.value = factura.toJson();
      return mutableData;
    });
    return result.committed;
  }
}
