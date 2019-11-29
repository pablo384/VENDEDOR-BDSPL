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

class _BillState extends State<Bill> {
  ClientDataModel get client => widget.client;
  String codigo = "";
  Factura factura;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visita a "),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: factura != null
              ? Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        View.goTo(context, SelectProductPage(
                          onSave: (ln) {
                            factura.addLinea(ln);
                            setState(() {});
                          },
                        ));
                      },
                      child: Text("agregar Producto"),
                    ),
                    Text("Cliente: ${factura.cliente.clienteNombre}"),
                    Text("Fecha: ${factura.fechaString}"),
                    Text("codigo: ${factura.codigo}"),
                    ...factura.lineas.map(
                      (f) => Text(
                        "producto ${f.producto.descCorta} cantidad:${f.cantidad} total:${f.total}",
                      ),
                    ),
                    Text("Subtotal: ${factura.subTotal}"),
                    Text("Total: ${factura.total}"),
                    RaisedButton(
                      onPressed: () async {
                        var res = await DatabaseService.saveBill(factura);
                        print("Factura resultado: $res");
                      },
                      child: Text(
                        "Facturar",
                      ),
                    ),
                  ],
                )
              : Text("cargando"),
        ),
      ),
    );
  }
}
