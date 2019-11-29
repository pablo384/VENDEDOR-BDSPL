import 'package:flutter/material.dart';
import 'package:vendedor/models/UtilModels.dart';
import 'package:vendedor/views/products/SelectProductpage.dart';

import '../../index.dart';

class Bill extends StatefulWidget {
  final ClientDataModel client;
  Bill({
    Key key,
    this.client,
  }) : super(key: key);

  @override
  _BillState createState() => _BillState();
}

class BodyBill extends StatelessWidget {
  final Function(LineaFactura) removeLn;
  final Factura factura;

  const BodyBill({
    Key key,
    @required this.factura,
    @required this.removeLn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Text(
                    "Descripcion",
                  ),
                ),
                Flexible(
                  child: Text(
                    "Cantidad",
                  ),
                ),
                Flexible(
                  child: Text(
                    "Precio",
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    "Total",
                  ),
                ),
              ],
            ),
            Divider(),
            ...factura.lineas.map(
              (f) => ListTile(
                onLongPress: () async {
                  if (await Util.askUser(context,
                      msg: "¿Seguro que quiere eliminar linea de la factura?"))
                    removeLn(f);
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${f.producto.descCorta}",
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "${f.cantidad}",
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "${f.producto.precio}",
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${f.total.toStringAsFixed(2)}",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderBill extends StatelessWidget {
  final Factura factura;

  const HeaderBill({
    Key key,
    @required this.factura,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Cliente:"),
                Text(
                  "${factura.cliente.clienteNombre}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Fecha:"),
                Text("${factura.fechaString}"),
              ],
            ),
            Text("Codigo: ${factura.codigo}"),
          ],
        ),
      ),
    );
  }
}

class _BillState extends State<Bill> {
  String codigo = "";
  Factura factura;
  ClientDataModel get client => widget.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visita a Cliente"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: factura != null
              ? Column(
                  children: <Widget>[
                    // FlatButton(
                    //   onPressed: () {
                    //     View.goTo(context, SelectProductPage(
                    //       onSave: (ln) {
                    //         factura.addLinea(ln);
                    //         setState(() {});
                    //       },
                    //     ));
                    //   },
                    //   child: Text("agregar Producto"),
                    // ),
                    Center(
                      child: Icon(
                        Icons.receipt,
                        size: 50.0,
                      ),
                    ),
                    new HeaderBill(factura: factura),
                    new BodyBill(
                      factura: factura,
                      removeLn: _removeLinea,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Subtotal:"),
                                Text(
                                  "${factura.subTotal.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Descuento:"),
                                Text(
                                  "${factura.descuento.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Total:"),
                                Text(
                                  "${factura.total.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: _pressSave,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.save),
                          Text(
                            " Facturar",
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Text("cargando"),
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Agregar producto a factura",
        child: FloatingActionButton(
          onPressed: _pressAddProduct,
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCodeFactura();
  }

  Future<void> _getCodeFactura() async {
    var len = await DatabaseService.getBillLenght();
    setState(() {
      // codigo = "FV000$len";
      factura = Factura(
        cliente: client,
        codigo: "FV000$len",
        fecha: DateTime.now(),
      );
    });
  }

  _pressAddProduct() {
    View.goTo(context, SelectProductPage(
      onSave: (ln) {
        factura.addLinea(ln);
        setState(() {});
      },
    ));
  }

  _pressSave() async {
    var res = await DatabaseService.saveBill(factura);
    print("Factura resultado: $res");
    if (res) {
      View.goBack(context);
    }
  }

  _removeLinea(LineaFactura ln) {
    factura.removeLinea(ln);
    setState(() {});
  }
}
