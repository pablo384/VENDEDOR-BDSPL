import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendedor/services/DatabaseService.dart';
import 'package:vendedor/services/StorageService.dart';

import '../index.dart';

class ConfigPage extends StatefulWidget {
  ConfigPage({Key key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final _rutaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final database = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuracion principal"),
      ),
      body: Builder(
        builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Form(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 6.0),
                            child: TextFormField(
                              key: Key('login_terminal'),
                              keyboardType: TextInputType.emailAddress,
                              // controller: consor,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(FontAwesomeIcons.userCircle),
                              ),
                              controller: _emailController,
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Ruta',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(FontAwesomeIcons.route),
                            ),
                            controller: _rutaController,
                            obscureText: false,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Clave',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(FontAwesomeIcons.key),
                            ),
                            controller: _passwordController,
                            obscureText: true,
                          ),
                          RaisedButton(
                            key: Key('login_login_btn'),
                            onPressed: () async {
                              var config = ConfigDataModel(
                                email: _emailController.text,
                                password: _passwordController.text,
                                ruta: _rutaController.text,
                              );
                              if (await DatabaseService.saveConfig(config)) {
                                await StorageService.saveConfig(config);
                                print("todo OK");
                              } else {
                                print("todo Mal");
                              }
                            },
                            child: Text(
                              'Guardar',
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          // Container(
                          //   child: null,
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // database.setPersistenceEnabled(true);
  }
}
