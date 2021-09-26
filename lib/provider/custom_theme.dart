import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uuid/uuid.dart';

class CustomThemeProvider with ChangeNotifier{

  int textHexColor = 4294967295;
  int textHexColor2 = 4294967295;
  double blurValue = 0.0;
  String backgroundFilePath = "";
  String defaultBgPath = "assets/imgs/starry.jpg";

  Future<void> getCurrentTextColor() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? color = _prefs.getInt('textcolor');
    if(color == null){
      textHexColor = 4294967295;
    }
    else{
      textHexColor = color;
    }

    notifyListeners();
  }

  Future<void> getCurrentBackground() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final appDir = await getApplicationDocumentsDirectory();
    final backgroundId = _prefs.getString('backgroundId');
    final _currentBlur = _prefs.getDouble('currentblur') ?? 0.0;
    final _currentBG = "${appDir.path}/background-$backgroundId";

    if(!File(_currentBG).existsSync()){
      backgroundFilePath = "";
      blurValue = 0.0;
    }
    else{
      backgroundFilePath = _currentBG;
      blurValue = _currentBlur;
    }

    // if(_currentBlur == null){
    //   blurValue = 0.0;
    // }
    // else{
    //   blurValue = _currentBlur;
    // }

    notifyListeners();
  }

  Future<void> changeTextColor(int hex) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('textcolor', hex);
  }

  Future<void> updateBG(String bgPath, double blurValue) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final appDir = await getApplicationDocumentsDirectory();
    final currentBackgroundId = _prefs.getString('backgroundId');
    final currentBackgroundFile = File("${appDir.path}/background-$currentBackgroundId");
    
    if(currentBackgroundId != null && currentBackgroundFile.existsSync() && bgPath != currentBackgroundFile.path){
      currentBackgroundFile.deleteSync();
    }

    final uuid = Uuid().v4();
    final imagePath = "${appDir.path}/background-$uuid";
    
    await _prefs.setDouble('currentblur', blurValue);
    
    if(bgPath != "" && bgPath != currentBackgroundFile.path){
      var imageBytes = await File(bgPath).readAsBytes();
      File(imagePath).writeAsBytesSync(imageBytes);
      await _prefs.setString('backgroundId', uuid);
    }
    // await _prefs.setString('currentbg', bgPath);
    // await _prefs.setDouble('currentblur', blurValue);
  }

  Future<void> resetTheme(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final appDir = await getApplicationDocumentsDirectory();
    final currentBackgroundId = _prefs.getString('backgroundId');
    final bgFile = File("${appDir.path}/background-$currentBackgroundId");

    if(bgFile.existsSync()) bgFile.deleteSync();

    var result = await _prefs.setString('font', "default_theme");

    if(result){
       ThemeProvider.controllerOf(context).setTheme("default_theme");
    }

    await updateBG("", 0.0);
    await changeTextColor(4294967295);
    await getCurrentBackground();
    await getCurrentTextColor();
  }

  Future<void> changeTextColor2(int hex) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('textcolor2', hex);
  }

  Future<void> getCurrentTextColor2() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? color = _prefs.getInt('textcolor2');
    if(color == null){
      textHexColor2 = 4294967295;
    }
    else{
      textHexColor2 = color;
    }
  }
  

  Future<bool> applyFont(BuildContext context, String font) async{
    var prefs = await SharedPreferences.getInstance();
    var result = await prefs.setString('font', font);
    if(result)  ThemeProvider.controllerOf(context).setTheme(font);
    print(font);

    return result;
  }
}