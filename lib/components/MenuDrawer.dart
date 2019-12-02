import 'package:flutter/material.dart';
import 'package:vendedor/index.dart';
import 'package:vendedor/views/Login.dart';
import 'package:vendedor/views/cierreDia/CierrePage.dart';
import 'package:vendedor/views/clientes/ClientsPage.dart';
import 'package:vendedor/views/pedidos/OrdersPage.dart';
import 'package:vendedor/views/products/ProductsPage.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({Key key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    size: 50.0,
                  ),
                  Text('Vendedor'),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Ordenes'),
            onTap: () {
              View.goTo(context, OrdersPage());
            },
          ),
          ListTile(
            title: Text('Productos'),
            onTap: () {
              View.goTo(context, ProductsPage());
            },
          ),
          ListTile(
            title: Text('Clientes'),
            onTap: () {
              View.goTo(context, ClientsPage());
            },
          ),
          ListTile(
            title: Text('Cierre del dia'),
            onTap: () {
              View.goTo(context, CierrePage());
            },
          ),
          ListTile(
            title: Text('Salir'),
            onTap: () async {
              StorageService.setLogged(false);
              View.goToReplacement(context, LoginPage());
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.data_usage),
                Text(" Enviar datos"),
              ],
            ),
            onTap: () async {
              await DatabaseService.saveBill(null);
              View.goBack(context);
              // View.goTo(context, CierrePage());
            },
          ),
        ],
      ),
    );
  }
}
