import 'package:flutter/material.dart';
import 'package:vendedor/index.dart';
import 'package:vendedor/views/pedidos/OrdersPage.dart';

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
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Ordenes'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              // Navigator.pop(context);
              // OrdersPage(context)
              View.goTo(context, OrdersPage());
            },
          ),
          // ListTile(
          //   title: Text('Item 2'),
          //   onTap: () {
          //     // Update the state of the app
          //     // ...
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
