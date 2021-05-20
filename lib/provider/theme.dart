import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{

  int textHexColor = 4294967295;
  int textHexColor2 = 4294967295;
  double blurValue = 0.0;
  String backgroundFilePath = "";
  String defaultBgPath = "assets/imgs/starry.jpg";

  Future<void> getCurrentTextColor() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int color = _prefs.getInt('textcolor');
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
    final _currentBG = _prefs.getString('currentbg');
    final _currentBlur = _prefs.getDouble('currentblur');

    if(_currentBG == null){
      backgroundFilePath = defaultBgPath;
      blurValue = 0.0;
    }
    else{
      backgroundFilePath = _currentBG;
      blurValue = _currentBlur;
    }

    if(_currentBlur == null){
      blurValue = 0.0;
    }
    else{
      blurValue = _currentBlur;
    }

    notifyListeners();
  }

  Future<void> changeTextColor(int hex) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('textcolor', hex);
  }

  Future<void> updateBG(String bgPath, double blurValue) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('currentbg', bgPath);
    await _prefs.setDouble('currentblur', blurValue);
  }

  Future<void> resetTheme() async {
    await updateBG('assets/imgs/starry.jpg', 0.0);
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
    int color = _prefs.getInt('textcolor2');
    if(color == null){
      textHexColor2 = 4294967295;
    }
    else{
      textHexColor2 = color;
    }
  }
  
  notifyListeners();
}