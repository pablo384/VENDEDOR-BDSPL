import 'package:flutter/material.dart';
import 'package:vendedor/models/UtilModels.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visita a "),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Cliente: ${client.clienteNombre}"),
              Text("Fecha: ${client.clienteNombre}"),
            ],
          ),
        ),
      ),
    );
  }
}
