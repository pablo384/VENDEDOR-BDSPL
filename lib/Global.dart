import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

BehaviorSubject<Map<String, dynamic>> infoLoginObserver =
    new BehaviorSubject<Map<String, dynamic>>();
BehaviorSubject<SnackbarMsg> snackMsgObserver =
    new BehaviorSubject<SnackbarMsg>();

class SnackbarMsg {
  String msg;
  Color color;

  SnackbarMsg({
    @required this.msg,
    @required this.color,
  });

  static errorMsg(String msg) {
    snackMsgObserver.add(
      SnackbarMsg(
        msg: msg,
        color: Colors.red,
      ),
    );
  }

  static successMsg(String msg) {
    snackMsgObserver.add(
      SnackbarMsg(
        msg: msg,
        color: Colors.green,
      ),
    );
  }
}

class View {
  static goBack(
    BuildContext context,
  ) {
    Navigator.pop(context);
  }

  static goTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static goToReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

enum Answers { YES, NO, MAYBE }

class Util {
  static DateFormat get formatterFecha =>
      new DateFormat('dd-MM-yyyy hh:mm:ss a');
  static Future<bool> askUser(context,
      {String msg = "¿Quiere proceder?"}) async {
    var theme = Theme.of(context);
    switch (await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Theme(
            data: theme.copyWith(),
            child: new SimpleDialog(
              title: new Text(msg),
              children: <Widget>[
                new RaisedButton(
                  child: new Text("Si"),
                  onPressed: () {
                    Navigator.pop(context, Answers.YES);
                  },
                ),
                new RaisedButton(
                  child: new Text("No"),
                  onPressed: () {
                    Navigator.pop(context, Answers.NO);
                  },
                ),
              ],
            ),
          );
        })) {
      case Answers.YES:
        // _setValue('Yes');
        return true;
        break;
      default:
        return false;
        break;
    }
  }
}
