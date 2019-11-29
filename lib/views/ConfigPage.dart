import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendedor/services/DatabaseService.dart';
import 'package:vendedor/services/StorageService.dart';

import '../index.dart';

class ConfigPage extends StatefulWidget {
  final ClientDataModel client;
  ConfigPage({
    Key key,
    this.client,
  }) : super(
          key: key,
        );

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final _rutaController = TextEditingController(text: "RUTA A");
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _valRuta = 'RUTA A';
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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

                            DropdownButton(
                              value: _valRuta,
                              onChanged: (val) {
                                setState(() {
                                  _valRuta = val;
                                });
                              },
                              items: ['RUTA A', 'RUTA B', 'RUTA C', 'RUTA D']
                                  .map<DropdownMenuItem>(
                                    (str) => DropdownMenuItem(
                                      value: str,
                                      child: Text(str),
                                    ),
                                  )
                                  .toList(),
                            ),
                            // TextFormField(
                            //   keyboardType: TextInputType.text,
                            //   decoration: InputDecoration(
                            //     labelText: 'Ruta',
                            //     border: OutlineInputBorder(),
                            //     prefixIcon: Icon(FontAwesomeIcons.route),
                            //   ),
                            //   controller: _rutaController,
                            //   obscureText: false,
                            // ),
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
                                  ruta: _valRuta,
                                );
                                if (await DatabaseService.saveConfig(config)) {
                                  await StorageService.saveConfig(config);
                                  print("todo OK");
                                  View.goBack(context);
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
