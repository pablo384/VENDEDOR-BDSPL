import 'package:flutter/material.dart';
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
