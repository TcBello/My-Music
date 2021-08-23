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

  // ORIG TEST

  // if(luminance <= 0.07){
  //   return _lighten(color, 0.4);
  // }
  // else{
  //   return _lighten(color, 0.2);
  // }

  // TEST 2 -----------
  
  // if(luminance <= 0.07){
  //   print("light: 0.4");
  //   return _lighten(color, 0.4);
  // }
  // else if(luminance >= 0.08 && luminance <= 0.3){
  //   print("light: 0");
  //   return color;
  // }
  // else{
  //   print("light: 0.1");
  //   return _lighten(color);
  // }

  // TEST 3 ---------

  // if(luminance <= 0.07){
  //   print("light: 0.4");
  //   return _lighten(bodyColor, 0.4);
  // }
  // else if(luminance >= 0.08 && luminance <= 0.205){
  //   print("light: 0.2");
  //   return _lighten(bodyColor, 0.2);
  //   // return color;
  // }
  // else if(luminance >= 0.206 && luminance <= 0.26){
  //   print("light: 0.1 (1)");
  //   return _lighten(bodyColor);
  // }
  // else if(luminance >= 0.27 && luminance <= 0.5){
  //   print("light: 0");
  //   return bodyColor;
  // }
  // else{
  //   print("light: 0.1 (2)");
  //   // return _lighten(bodyColor);
  //   return bodyColor;
  // }


  // TEST 4 -------------

  // if(luminance >= 0.1619 && luminance <= 0.1621){
  //   print("light: default");
  //   return _lighten(bodyColor, 0.4);
  // }
  // // else if(luminance <= 0.07){
  // //   print("light: 0.4");
  // //   return _lighten(bodyColor, 0.2);
  // // }
  // else if(luminance <= 0.01){
  //   print("light: 0.1");
  //   return _lighten(bodyColor);
  //   // return bodyColor;
  // }
  // else if(luminance > 0.01 && luminance <= 0.5){
  //   print("light: 0.2");
  //   // return _lighten(bodyColor, 0.2);
  //   return bodyColor;
  // }
  // else{
  //   print("light: 0.0");
  //   return bodyColor;
  //   // return _lighten(bodyColor);
  // }

  // TEST 5 -----------

  // if(luminance >= 0.1619 && luminance <= 0.1621){
  //   print("light: default");
  //   return _lighten(bodyColor, 0.4);
  // }
  // else if(((luminance < 0.5 && bodyLuminance < 0.5) && bodyLuminance > luminance) || (luminance > 0.5 && bodyLuminance < 0.5)){
  //   print("light: 0.0");
  //   // return bodyColor;
  //   return _lighten(bodyColor);
  // }
  // else if((luminance > 0.5 && bodyLuminance > 0.5) || bodyLuminance < luminance){
  //   print("light: 0.2");
  //   return _lighten(bodyColor, 0.2);
  //   // return bodyColor;
  // }
  // else{
  //   return Colors.green;
  // }

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