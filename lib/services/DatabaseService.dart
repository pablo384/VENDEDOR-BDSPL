import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../index.dart';

class DatabaseService {
  static FirebaseDatabase database = FirebaseDatabase.instance;
  static Future<void> deleteOrder(String codigo) async {
    var config = await StorageService.getConfig();
    await database.reference().child("ordenes/${config.ruta}/$codigo").remove();
  }

  static Future<int> getBillLenght() async {
    var keycoUNT = "bill-count";
    var config = await StorageService.getConfig();
    var pref = await SharedPreferences.getInstance();
    var data = pref.getInt(keycoUNT);
    if (data == null) {
      DataSnapshot result =
          await database.reference().child("ordenes/${config.ruta}").once();
      var count = result.value != null ? Map.castFrom(result.value).length : 0;
      await pref.setInt(keycoUNT, count);
      return count;
    } else {
      await pref.setInt(keycoUNT, data + 1);
      return data + 1;
    }
    // print("resultado::getBillLenght:: ${result.value}");
    // print("resultado::getBillLenght:: ${Map.castFrom(result.value).length}");
    // return result.value != null ? Map.castFrom(result.value).length : 0;
  }

  static Stream<Event> getClients() {
    return database.reference().child("clientes").onValue;
  }

  static Future<List<ClientDataModel>> getClientsOnce() async {
    var data = await database.reference().child("clientes").once();
    var config = await StorageService.getConfig();
    var dayWeek = await StorageService.getWeekAndDay();
    var nDay = Util.getWLetterFromStr(dayWeek[1]);
    var week = dayWeek[0].contains("1") || dayWeek[0].contains("3") ? 1 : 2;
    print("DIA Y SEMANA:: $nDay  $week");
    // var semana = 0;
    // // var semana = 0;
    // // DateTime.now().
    // // var response = [];
    // if (DateTime.now().day > 0) semana = 1;
    // if (DateTime.now().day > 7) semana = 2;
    // if (DateTime.now().day > 14) semana = 1;
    // if (DateTime.now().day > 23) semana = 2;
    List<ClientDataModel> response = [];
    // semana = 1;
    var res = Map.castFrom(data.value);
    print("lisener 02  mi ruta: ${config.ruta}");
    for (var key in res.keys) {
      // print("semana ${res[key]['SEMANA']}");
      if (res[key]['SEMANA'] == week.toString() &&
          res[key]['DIA'] == nDay &&
          config.ruta == res[key]['RUTA']) {
        var cl = ClientDataModel.fromJson({...res[key], "id": key});
        await cl.updateData();
        // cl.visited = await StorageService.getVisitedClient(cl.id);
        // cl.noVenta = await StorageService.getNotSellslient(cl.id);
        response.add(cl);
      }
    }
    // int.tryParse()
    response
        .sort((a, b) => int.tryParse(a.orden).compareTo(int.tryParse(b.orden)));
    return response;
  }

  static Future<List<Factura>> getOrdersOnce() async {
    var config = await StorageService.getConfig();
    var result =
        await database.reference().child("ordenes/${config.ruta}").once();
    // print("resultado:getProductsOnce: ${result.value}");
    // var pro = Map.castFrom(result.value);
    if (result.value == null) return [];
    var lsPro = Factura.fromMap(Map.castFrom(result.value));
    // print("resultado:getProductsOnce: ${lsPro.toString()}");
    return lsPro;
  }

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

  static saveBill(Factura factura) async {
    var config = await StorageService.getConfig();
    try {
      await http.get("https://google.com");
      var cache = await StorageService.getCacheFactura();
      if (cache != null) {
        for (var item in cache) {
          await database
              .reference()
              .child("ordenes/${config.ruta}/${item['codigo']}")
              .reference()
              .runTransaction((MutableData mutableData) async {
            mutableData.value = item;
            return mutableData;
          });
        }
        await StorageService.clearCacheFactura();
      }
      if (factura != null) {
        var result = await database
            .reference()
            .child("ordenes/${config.ruta}/${factura.codigo}")
            .reference()
            .runTransaction((MutableData mutableData) async {
          mutableData.value = factura.toJson();
          return mutableData;
        });
        return result.committed;
      }
      return true;
    } catch (e) {
      await StorageService.addToCache(factura.toJson());
      print("NO INTERNET");
      return true;
    }
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
