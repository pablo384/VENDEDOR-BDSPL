import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendedor/services/DatabaseService.dart';
import 'package:vendedor/views/products/SelectProductPage.dart';

import '../index.dart';
import 'bill/Bill.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription _subs;
  List<ClientDataModel> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ...items.map(
                (val) => FlatButton(
                  onPressed: () {
                    // DatabaseService.getProductsOnce();
                    View.goTo(
                        context,
                        Bill(
                          client: val,
                        ));
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person),
                      Flexible(
                        child: Text(
                          " ${val.clienteNombre}",
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: MenuDrawer(),
    );
  }

  disableListen() {
    _subs.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    disableListen();
  }

  @override
  void initState() {
    super.initState();
    startListen();
  }

  startListen() async {
    var client = await DatabaseService.getClientsOnce();

    // _subs = DatabaseService.getClients().listen((data) async {
    //   var config = await StorageService.getConfig();
    //   var semana = 0;
    //   // var semana = 0;
    //   // DateTime.now().
    //   if (DateTime.now().day > 0) semana = 1;
    //   if (DateTime.now().day > 7) semana = 2;
    //   if (DateTime.now().day > 14) semana = 1;
    //   if (DateTime.now().day > 23) semana = 2;
    //   List<ClientDataModel> response = [];
    //   // semana = 1;
    //   var res = Map.castFrom(data.snapshot.value);
    //   print("lisener 02 ${res.toString()} mi ruta: ${config.ruta}");
    //   for (var key in res.keys) {
    //     // print("semana ${res[key]['SEMANA']}");
    //     if (res[key]['SEMANA'] == semana.toString() &&
    //         config.ruta == res[key]['RUTA']) {
    //       response.add(ClientDataModel.fromJson({...res[key], "id": key}));
    //     }
    //   }

    //   // print("lisener 03 ${jsonEncode(response)}");
    setState(() {
      items = client;
    });
    // });
  }
}
