import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

BehaviorSubject<Map<String, dynamic>> infoLoginObserver =
    new BehaviorSubject<Map<String, dynamic>>();
BehaviorSubject<SnackbarMsg> snackMsgObserver =
    new BehaviorSubject<SnackbarMsg>();
BehaviorSubject<bool> reloadObserver = new BehaviorSubject<bool>();

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
  static DateFormat get formatterFechaSinHoras => new DateFormat('dd-MM-yyyy');
  static DateFormat get formatterFecha =>
      new DateFormat('dd-MM-yyyy hh:mm:ss a');
  static DateFormat get formatterDia => new DateFormat('EEE');

  static formatNumber(String str) {
    return str.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  static String getWeekDayFromNumber(int n) {
    switch (n) {
      case 2:
        return "Lunes";
        break;
      case 3:
        return "Martes";
        break;
      case 4:
        return "Miercoles";
        break;
      case 5:
        return "Jueves";
        break;
      case 6:
        return "Viernes";
        break;
      default:
        return "Lunes";
    }
  }

  static String getWLetterFromStr(String n) {
    switch (n) {
      case "Lunes":
        return "L";
        break;
      case "Martes":
        return "M";
        break;
      case "Miercoles":
        return "W";
        break;
      case "Jueves":
        return "J";
        break;
      case "Viernes":
        return "V";
        break;
      default:
        return "L";
    }
  }

  static getNumerOfWeek() {
    var semana = 0;
    if (DateTime.now().day > 0) semana = 1;
    if (DateTime.now().day > 7) semana = 2;
    if (DateTime.now().day > 14) semana = 1;
    if (DateTime.now().day > 23) semana = 2;
    return semana;
  }

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
