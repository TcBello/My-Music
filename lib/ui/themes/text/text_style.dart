import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/ui/font_selection/font_selection_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class TextStyleTheme extends StatefulWidget {
  @override
  _TextStyleThemeState createState() => _TextStyleThemeState();
}

class _TextStyleThemeState extends State<TextStyleTheme> {
  int _hex = 0;
  int _white = 4294967295;
  Color _pickerColor = Color(4294967295);

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final _num = _prefs.getInt('textcolor');
    if(_num == null){
      setState(() {
        _hex = _white;
        _pickerColor = Color(_white);
      });
    }
    else{
      setState(() {
        _hex = _num;
        _pickerColor = Color(_num);
      });
    }
  }

  void changeTextColor(Color color){
    setState(() {
      _pickerColor = color;
    });
  }

  void _openColorDialog(BuildContext context){
    final _themeProvider = Provider.of<CustomThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Pick a color!", style: ThemeProvider.themeOf(context).data.textTheme.headline6.copyWith(
            color: Colors.black
          ),),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ColorPicker(
              pickerColor: _pickerColor,
              onColorChanged: changeTextColor,
            ),
          ),
          actions: [
            TextButton(
              child: Text("Apply", style: ThemeProvider.themeOf(context).data.textTheme.button),
              onPressed: () async {
                await _themeProvider.changeTextColor(_pickerColor.value);
                await _themeProvider.getCurrentTextColor();
                setState(() {
                  _hex = _pickerColor.value;
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  Widget _primaryWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text("Primary", style: ThemeProvider.themeOf(context).data.textTheme.bodyText1.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18
          )),
        ),
        SizedBox(height: 10,),
        Container(
          child: Text("Sample Text", style: ThemeProvider.themeOf(context).data.textTheme.headline5.copyWith(
            fontWeight: FontWeight.w500,
            color: Color(_hex),
            fontSize: 30
          )),
        ),
        SizedBox(height: 20,),
        ListTile(
          title: Text("Color", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
            fontWeight: FontWeight.bold
          ),),
          subtitle: Text("Customize text color", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
            color: Colors.white
          ),),
          onTap: (){_openColorDialog(context);},
          focusColor: Colors.blue,
        ),
        ListTile(
          title: Text("Font", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
            fontWeight: FontWeight.bold
          ),),
          subtitle: Text("Customize font style", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
            color: Colors.white
          ),),
          onTap: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context) => FontSelectionUI()));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color2,
        title: Text("Text Style", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: _primaryWidget()
        ),
      ),
    );
  }
}
