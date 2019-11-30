import 'package:flutter/material.dart';

import '../../index.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
// controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  // final dio = new Dio(); // for http requests
  String _searchText = "";
  List<Factura> products = new List<Factura>(); // names we get from API
  List<Factura> filteredProducts =
      new List<Factura>(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Ordenes');

  _OrdersPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredProducts = products;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: SafeArea(
        child: Container(
          child: _buildList(),
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  void _getProducts() async {
    // final response = await dio.get('https://swapi.co/api/people');
    // List tempList = new List();
    // for (int i = 0; i < response.data['results'].length; i++) {
    //   tempList.add(response.data['results'][i]);
    // }
    var _prod = await DatabaseService.getOrdersOnce();

    setState(() {
      products = _prod;
      filteredProducts = products;
    });
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List<Factura> tempList = new List<Factura>();
      for (int i = 0; i < filteredProducts.length; i++) {
        if (filteredProducts[i].codigo.toLowerCase().contains(
                  _searchText.toLowerCase(),
                ) ||
            filteredProducts[i].cliente.clienteNombre.toLowerCase().contains(
                  _searchText.toLowerCase(),
                )) {
          tempList.add(filteredProducts[i]);
        }
      }
      filteredProducts = tempList;
    }
    return ListView.builder(
      itemCount: products == null ? 0 : filteredProducts.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: new ListTile(
            title: Container(
              padding: EdgeInsets.all(3.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    filteredProducts[index].codigo,
                  ),
                  Text(
                    "Cliente: " + filteredProducts[index].cliente.clienteNombre,
                  ),
                  Text(
                    "Fecha: " + filteredProducts[index].fechaString,
                  ),
                ],
              ),
            ),
            onLongPress: () async {
              if (await Util.askUser(context,
                  msg: "¿Seguro que quiere eliminar la orden?")) {
                await DatabaseService.deleteOrder(
                    filteredProducts[index].codigo);
                products.remove(filteredProducts[index]);
                // if (filteredProducts.length - 1 <= index)
                //   filteredProducts.remove(filteredProducts[index]);
                setState(() {});
              }
            },
            onTap: () async {
              print(filteredProducts[index].toJson());
              // filteredProducts.remove(filteredProducts[index]);

              // var _cantidad = TextEditingController();
              //   await showDialog(
              //       context: context,
              //       barrierDismissible: true,
              //       builder: (ctx) {
              //         return SimpleDialog(
              //           contentPadding: const EdgeInsets.all(8.0),
              //           children: <Widget>[
              //             Column(
              //               children: <Widget>[
              //                 Text("Cantidad"),
              //                 new TextField(
              //                   autofocus: true,
              //                   controller: _cantidad,
              //                   keyboardType: TextInputType.number,
              //                   decoration: new InputDecoration(
              //                     prefixIcon: new Icon(Icons.plus_one),
              //                     labelText: "Cantidad",
              //                   ),
              //                   onSubmitted: (arg) {
              //                     print(arg);
              //                   },
              //                 ),
              //                 RaisedButton(
              //                   onPressed: () {
              //                     // print(_cantidad.text);
              //                     // var linea = LineaFactura(
              //                     //   cantidad: int.tryParse(_cantidad.text) ?? 1,
              //                     //   producto: filteredProducts[index],
              //                     // );
              //                     // widget.onSave(linea);
              //                     // Navigator.of(context).pop();
              //                     // Navigator.of(ctx).pop();
              //                   },
              //                   child: Text("Aceptar"),
              //                 )
              //               ],
              //             )
              //           ],
              //         );
              //       });
            },
          ),
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = Card(
          // color: Colors.white,
          child: new TextField(
            autofocus: true,
            controller: _filter,
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Buscar...',
            ),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(
          'Ordenes',
        );
        filteredProducts = products;
        _filter.clear();
      }
    });
  }
}
