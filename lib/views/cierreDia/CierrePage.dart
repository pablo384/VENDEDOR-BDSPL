import 'package:flutter/material.dart';
import 'package:vendedor/index.dart';

class CierrePage extends StatefulWidget {
  CierrePage({Key key}) : super(key: key);

  @override
  _CierrePageState createState() => _CierrePageState();
}

class _CierrePageState extends State<CierrePage> {
  var _totalUnidadesEnVentas = 0.0;
  var _totalClientesVenta = 0;
  var _totalEfectividadClientesVenta = 0;
  var _totalEnVentas = 0.0;
  var _totalEnVisitas = 0;
  var _totalClientes = 0;
  var _abstencionVentas = 0;
  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  _generateReport() async {
    var fecha = DateTime.now();
    var clients = await DatabaseService.getClientsOnce();
    var ordenes = await DatabaseService.getOrdersOnce();
    var totalClientes = clients.length;
    var totlaVenta = clients.where((test) => test.visited).toList().length;
    var totalEfectVenta =
        clients.where((test) => !test.noVenta && !test.visited).toList().length;
    var totlaVisitado =
        clients.where((test) => test.noVenta || test.visited).toList().length;
    var abstencionVentas = (totlaVenta - totalClientes).abs();
    var totalEnVentas = 0.0;
    var totalUnidadesEnVentas = 0.0;
    var fStr = Util.formatterFechaSinHoras.format(fecha);
    ordenes.forEach((f) {
      if (fStr == Util.formatterFechaSinHoras.format(f.fecha)) {
        totalEnVentas += f.total;
      }
    });
    ordenes.forEach((f) => f.lineas.forEach((l) {
          if (fStr == Util.formatterFechaSinHoras.format(f.fecha)) {
            totalUnidadesEnVentas += l.cantidad;
          }
        }));
    // ordenes.we
    setState(() {
      _totalEfectividadClientesVenta = totalEfectVenta;
      _abstencionVentas = abstencionVentas;
      _totalClientesVenta = totlaVenta;
      _totalEnVisitas = totlaVisitado;
      _totalClientes = totalClientes;
      _totalUnidadesEnVentas = totalUnidadesEnVentas;
      _totalEnVentas = totalEnVentas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reporte"),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Total Clientes: $_totalClientes"),
                Text(
                    "Efectividad de visitas: (${((_totalEnVisitas * 100) / _totalClientes).toStringAsFixed(2)}%) $_totalEnVisitas/$_totalClientes"),
                Text(
                    "Efectividad en ventas: (${((_totalClientesVenta * 100) / _totalEnVisitas).toStringAsFixed(2)}%) $_totalClientesVenta/$_totalEnVisitas"),
                Text(
                    "Abstencion de ventas: (${((_abstencionVentas * 100) / _totalClientes).toStringAsFixed(2)}%) $_abstencionVentas/$_totalClientes"),
                Text(
                    "Efectividad general de ventas: (${((_totalClientesVenta * 100) / _totalClientes).toStringAsFixed(2)}%) $_totalClientesVenta/$_totalClientes"),
                Text(
                    "Total en ventas: ${Util.formatNumber(_totalEnVentas.toStringAsFixed(2))}"),
                Text(
                    "Total en cajas: ${Util.formatNumber(_totalUnidadesEnVentas.toStringAsFixed(2))}"),
                RaisedButton(
                  onPressed: () {},
                  child: Text("Cerrar Dia"),
                ),
                RaisedButton(
                  onPressed: () {
                    View.goBack(context);
                  },
                  child: Text("Cancelar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
