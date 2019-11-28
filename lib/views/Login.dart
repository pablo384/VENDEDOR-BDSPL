import 'package:flutter/material.dart';
import 'package:vendedor/views/ConfigPage.dart';

import '../Global.dart';
import 'login_form.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // LotenetUtil.permisos();
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // color: Colors.red,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onLongPress: () {
                        // _configBluetooth(context);
                        View.goTo(context, ConfigPage());
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Icon(
                          Icons.security,
                          size: 100.0,
                          color: Colors.green,
                        ), //Image.asset('assets/img/lotenetbl.png'),
                      ),
                    ),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
