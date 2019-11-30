import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vendedor/services/DatabaseService.dart';
import 'package:vendedor/services/StorageService.dart';
import 'package:vendedor/views/Home.dart';

import '../Global.dart';
import 'ConfigPage.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  dynamic _fechaManual = false;
  dynamic _semana;
  dynamic _dia;
  String ruta = "";

  @override
  void initState() {
    super.initState();
    _authVerification();
    setValsInit();
  }

  Future _authVerification() async {
    var conf = await StorageService.getConfig();
    setState(() {
      ruta = conf.ruta;
    });
    // if (await StorageService.isLogged()) View.goToReplacement(context, Home());
  }

  setValsInit() {
    var fech = DateTime.now();
    var weeg = Util.getNumerOfWeek();
    // print(
    //     "DIAA ACTUAL:${Util.getWeekDayFromNumber(fech.weekday)}:${Util.formatterDia.format(fech)}");
    setState(() {
      _dia = Util.getWeekDayFromNumber(fech.weekday);
      _semana = "Semana $weeg";
    });
  }

  @override
  Widget build(BuildContext context) {
    // _authModel = Provider.of<AuthModel>(context);
    // _usernameController.text = 'admin';
    // _passwordController.text = '12345678';
    if (snackMsgObserver.value != null) {
      _onWidgetDidBuild(() {
        Scaffold.of(context).showSnackBar(
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
    return Form(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("RUTA: $ruta"),
          // Container(
          //   margin: EdgeInsets.only(bottom: 6.0),
          //   child: TextFormField(
          //     key: Key('login_terminal'),
          //     keyboardType: TextInputType.emailAddress,
          //     // controller: consor,
          //     decoration: InputDecoration(
          //       labelText: 'Usuario',
          //       border: OutlineInputBorder(),
          //       prefixIcon: Icon(FontAwesomeIcons.userCircle),
          //     ),
          //     controller: _usernameController,
          //     enabled: !_loading,
          //   ),
          // ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
              prefixIcon: Icon(FontAwesomeIcons.key),
            ),
            controller: _passwordController,
            obscureText: true,
            enabled: !_loading,
          ),
          Divider(),
          Text(Util.formatterFecha.format(DateTime.now())),

          Row(
            children: <Widget>[
              Checkbox(
                value: !_fechaManual,
                onChanged: (ar) {
                  setState(() {
                    _fechaManual = !ar;
                  });
                },
              ),
              Text("Seleccion automatica")
            ],
          ),

          if (_fechaManual)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Semana: "),
                DropdownButton(
                  value: _semana,
                  items: ["Semana 1", "Semana 2", "Semana 3", "Semana 4"]
                      .map<DropdownMenuItem>((f) {
                    // print("valor drop: ${f['val']}");
                    return DropdownMenuItem(
                      value: f,
                      child: Text(f.toString()),
                    );
                  }).toList(),
                  onChanged: (s) {
                    // print("cambio valor drop: ${s}");
                    setState(() {
                      _semana = s;
                    });
                  },
                ),
              ],
            ),

          if (_fechaManual)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Dia: "),
                DropdownButton(
                  value: _dia,
                  items: ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes"]
                      .map<DropdownMenuItem>((f) {
                    // print("valor drop: ${f['val']}");
                    return DropdownMenuItem(
                      value: f,
                      child: Text(f.toString()),
                    );
                  }).toList(),
                  onChanged: (s) {
                    // print("cambio valor drop: ${s}");
                    setState(() {
                      _dia = s;
                    });
                  },
                ),
              ],
            ),

          _loading
              ? CircularProgressIndicator(
                  // backgroundColor: Theme.of(context).primaryColor,
                  )
              : RaisedButton(
                  key: Key('login_login_btn'),
                  onPressed: _loading ? null : _loginProcess,
                  child: Text(
                    'Iniciar Sesión',
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
        ],
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Future<void> _loginProcess() async {
    setState(() {
      _loading = true;
    });

    await StorageService.setWeekAndDay(_dia, _semana);

    if (_passwordController.text == "0222" &&
        await StorageService.getConfig() == null) {
      _passwordController.clear();
      // await StorageService.getConfig();
      View.goTo(context, ConfigPage());
    } else if (_passwordController.text == "0222") {
      SnackbarMsg.errorMsg("Ruta ya esta configurada en este dispositivo.");
    } else {
      var conf = await StorageService.getConfig();
      if (conf == null) {
        SnackbarMsg.errorMsg("Configure su ruta primero.");
      } else {
        var res = await DatabaseService.login(conf, _passwordController.text);
        print("respuesta login $res");

        if (res) {
          StorageService.setLogged(true);
          View.goToReplacement(context, Home());
        } else {
          SnackbarMsg.errorMsg("Clave incorrecta.");
        }
      }
    }
    setState(() {
      _loading = false;
    });
  }
}
