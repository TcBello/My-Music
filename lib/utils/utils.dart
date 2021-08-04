import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

double valueFromPercentageInRange(
    {@required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({@required final double min, max, value}) {
  return (value - min) / (max - min);
}

String toMinSecFormat(Duration duration) {
  return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
    .firstMatch("$duration")
    ?.group(1) ?? '$duration';
}

void showShortToast(String msg){
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey[800],
    textColor: Colors.white,
    fontSize: 16.0
  );
}

void showLongToast(String msg){
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey[800],
    textColor: Colors.white,
    fontSize: 16.0
  );
}