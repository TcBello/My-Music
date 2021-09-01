import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/style.dart';
import 'package:url_launcher/url_launcher.dart';

double valueFromPercentageInRange(
    {required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

String toMinSecFormat(Duration duration) {
  return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
    .firstMatch("$duration")
    ?.group(1) ?? '$duration';
}

void showShortToast(String msg){
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: color4,
    textColor: Colors.white,
    fontSize: 16.0
  );
}

void showLongToast(String msg){
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: color4,
    textColor: Colors.white,
    fontSize: 16.0
  );
}

Color _darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color _lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

Color miniplayerBackgroundColor(Color color){
  double luminance = color.computeLuminance();

  if(luminance <= 0.07){
    return color;
  }
  else{
    return _darken(color, 0.2);
  }
}

Color miniplayerBodyColor(Color bodyColor, Color backgroundColor){
  double backgroundLuminance = backgroundColor.computeLuminance();
  double bodyLuminance = bodyColor.computeLuminance();

  if(backgroundLuminance >= 0.1619 && backgroundLuminance <= 0.1621){
    print("light: default");
    return _lighten(bodyColor, 0.4);
  }
  else if(bodyLuminance <= 0.5 && backgroundLuminance <= 0.5 && backgroundLuminance < bodyLuminance){
    print("light: 0.0 (1)");
    return bodyColor;
  }
  else if(bodyLuminance <= 0.5 && backgroundLuminance <= 0.5 && bodyLuminance < backgroundLuminance){
    print("light: 0.2");
    return _lighten(bodyColor, 0.2);
  }
  else if(bodyLuminance > 0.5 && backgroundLuminance > 0.5 && backgroundLuminance < bodyLuminance){
    print("light: 0.0 (2)");
    return bodyColor;
  }
  else if(bodyLuminance > 0.5 && backgroundLuminance > 0.5 && bodyLuminance < backgroundLuminance){
    print("light: 0.1 (1)");
    return _lighten(bodyColor);
  }
  else if(bodyLuminance <= 0.5 && backgroundLuminance > 0.5){
    print("light: 0.0 (3)");
    return bodyColor;
  }
  else if(bodyLuminance > 0.5 && backgroundLuminance <= 0.5){
    print("light: 0.0 (4)");
    return bodyColor;
  }
  else{
    return Colors.white;
  }
}

void sendEmail() async{
  String scheme = "mailto:$kEmail?subject=$kSubject&body=";

  if(await canLaunch(scheme)){
    var result = await launch(scheme);
    
    if(!result){
      showShortToast("Can't redirect to email");
    }
  }
  else{
    showShortToast("An error has occured");
  }
}