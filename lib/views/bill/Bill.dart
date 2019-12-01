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
                      msg: "¿Seguro que quiere eliminar linea de la orden?"))
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
                Flexible(
                  child: Text(
                    "${factura.cliente.clienteNombre} | ${factura.cliente.id}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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
            Text("Oferta 5+Media: ${factura.cliente.of5M}"),
            Text("Oferta 10+1: ${factura.cliente.of101}"),
            Text("Oferta 25+3: ${factura.cliente.of253}"),
            Text("Codigo Factura: ${factura.codigo}"),
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
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (snackMsgObserver.value != null) {
      _onWidgetDidBuild(() {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              snackMsgObserver.value.msg,
            ),
            backgroundColor: snackMsgObserver.value.color,
          ),
        );
        snackMsgObserver.add(null);
      });
    }
    return Scaffold(
      key: _scaffoldKey,
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
                                Text("ITBIS:"),
                                Text(
                                  "${factura.itbis.toStringAsFixed(2)}",
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
                      color: Colors.green,
                      onPressed: _pressSave,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.save),
                          Text(
                            " Finalizar Pedido",
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      color: Colors.red,
                      onPressed: _pressNotSells,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.view_list),
                          Text(
                            " No venta",
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
        message: "Agregar producto a Orden",
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
        codigo: "000$len",
        fecha: DateTime.now(),
      );
    });
  }

  _pressAddProduct() {
    View.goTo(context, SelectProductPage(
      onSave: (ln) {
        factura.addLinea(ln);
        if (client.of253 == "1" &&
            ln.cantidad >= 25 &&
            ln.producto.of253 == "1") {
          var division = ln.cantidad / 25 * 3;
          var nln = LineaFactura.fromJson(ln.toJson());
          nln.total = 0.0;
          nln.cantidad = division.toDouble().roundToDouble();
          factura.addLinea(nln);
        } else if (client.of101 == "1" &&
            ln.cantidad >= 10 &&
            ln.producto.of101 == "1") {
          var division = ln.cantidad ~/ 10;
          var nln = LineaFactura.fromJson(ln.toJson());
          nln.total = 0.0;
          nln.cantidad = division.toDouble();
          factura.addLinea(nln);
        } else if (client.of5M == "1" &&
            ln.cantidad >= 5 &&
            ln.producto.of5M == "1") {
          var division = ln.cantidad ~/ 5;
          var nln = LineaFactura.fromJson(ln.toJson());
          nln.total = 0.0;
          nln.cantidad = division.toDouble() * .5;
          factura.addLinea(nln);
        }
        setState(() {});
      },
    ));
  }

  _pressNotSells() async {
    // if (factura.lineas.length > 0) {
    //   var res = await DatabaseService.saveBill(factura);
    //   print("Factura resultado: $res");
    //   if (res) {
    factura.cliente.noVenta = true;
    await StorageService.setVisitedClient(
      factura.cliente.id,
    );
    View.goBack(context);
    // }
    // } else {
    //   SnackbarMsg.errorMsg("Debes agregar almenos un producto a la orden.");
    //   setState(() {});
    // }
  }

  _pressSave() async {
    if (factura.lineas.length > 0) {
      var res = await DatabaseService.saveBill(factura);
      print("Factura resultado: $res");
      if (res) {
        factura.cliente.visited = true;
        await StorageService.setVisitedClient(
          factura.cliente.id,
        );
        View.goBack(context);
      }
    } else {
      SnackbarMsg.errorMsg("Debes agregar almenos un producto a la orden.");
      setState(() {});
    }
  }

  _removeLinea(LineaFactura ln) {
    factura.removeLinea(ln);
    setState(() {});
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
