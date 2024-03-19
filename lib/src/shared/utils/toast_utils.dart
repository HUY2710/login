import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  ToastUtils._();
  static void success(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
    );
  }

  static void error(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.red,
      gravity: ToastGravity.CENTER,
    );
  }
}
