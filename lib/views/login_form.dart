import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _authVerification();
  }

  Future _authVerification() async {
    // var auth = await HttpClientAPI.isAuthenticated();
    // if (auth) {
    //   View.goTo(context, Home());
    // }
  }

  @override
  Widget build(BuildContext context) {
    // _authModel = Provider.of<AuthModel>(context);
    // _usernameController.text = 'admin';
    // _passwordController.text = '12345678';
    // if (snackMsgObserver.value != null) {
    //   _onWidgetDidBuild(() {
    //     Scaffold.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           snackMsgObserver.value.msg,
    //         ),
    //         backgroundColor: snackMsgObserver.value.color,
    //       ),
    //     );
    //     snackMsgObserver.add(null);
    //   });
    // }
    return Form(
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
                labelText: 'Usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(FontAwesomeIcons.userCircle),
              ),
              controller: _usernameController,
              enabled: !_loading,
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
              prefixIcon: Icon(FontAwesomeIcons.key),
            ),
            controller: _passwordController,
            obscureText: true,
            enabled: !_loading,
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
          // Container(
          //   child: null,
          // ),
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
    // try {
    //   await HttpClientAPI.login(ParamsLogin(
    //     email: _usernameController.text,
    //     password: _passwordController.text,
    //   ));
    //   SnackbarMsg.successMsg("Login correcto");
    //   await _authVerification();
    // } catch (e) {
    //   SnackbarMsg.errorMsg(e.toString());
    // }
    setState(() {
      _loading = false;
    });
  }
}
