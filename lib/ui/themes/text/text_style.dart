import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/theme.dart';
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
  int _hex2 = 0;
  int _white = 4294967295;
  Color pickerColor = Color(4294967295);
  Color pickerColor2 = Color(4294967295);

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final _num = _prefs.getInt('textcolor');
    final _num2 = _prefs.getInt('textcolor2');
    if(_num == null){
      setState(() {
        _hex = _white;
        pickerColor = Color(_white);
      });
    }
    else{
      setState(() {
        _hex = _num;
        pickerColor = Color(_num);
      });
    }

    if(_num2 == null){
      setState(() {
        _hex2 = _white;
        pickerColor2 = Color(_white);
      });
    }
    else{
      setState(() {
        _hex2 = _num2;
        pickerColor2 = Color(_num2);
      });
    }

  }

  void changeTextColor(Color color){
    setState(() {
      pickerColor = color;
    });
  }

  void changeTextColor2(Color color){
    setState(() {
      pickerColor2 = color;
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
              pickerColor: pickerColor,
              onColorChanged: changeTextColor,
            ),
          ),
          actions: [
            FlatButton(
              child: Text("Apply", style: ThemeProvider.themeOf(context).data.textTheme.button),
              onPressed: () async {
                await _themeProvider.changeTextColor(pickerColor.value);
                await _themeProvider.getCurrentTextColor();
                setState(() {
                  _hex = pickerColor.value;
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  // void _openColorDialog2(BuildContext context){
  //   final _themeProvider = Provider.of<CustomThemeProvider>(context, listen: false);

  //   showDialog(
  //       context: context,
  //       builder: (context){
  //         return AlertDialog(
  //           title: Text("Pick a color!"),
  //           content: SingleChildScrollView(
  //             scrollDirection: Axis.vertical,
  //             child: ColorPicker(
  //               pickerColor: pickerColor2,
  //               onColorChanged: changeTextColor2,
  //             ),
  //           ),
  //           actions: [
  //             FlatButton(
  //               child: Text("Apply"),
  //               onPressed: () async {
  //                 await _themeProvider.changeTextColor2(pickerColor2.value);
  //                 await _themeProvider.getCurrentTextColor2();
  //                 setState(() {
  //                   _hex2 = pickerColor2.value;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //             )
  //           ],
  //         );
  //       }
  //   );
  // }

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
          // color: _hex == _white ? Colors.black : null,
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

  // Widget _secondaryWidget(){
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       ListTile(
  //         title: Text("Secondary", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
  //       ),
  //       SizedBox(height: 10,),
  //       Container(
  //         color: _hex2 == _white ? Colors.black : null,
  //         child: Text(
  //           "Sample Text",
  //           style: TextStyle(
  //               fontSize: 30.0,
  //               color: Color(_hex2)
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 20,),
  //       ListTile(
  //         title: Text("Color"),
  //         subtitle: Text("Customize text color"),
  //         onTap: (){_openColorDialog2(context);},
  //         focusColor: Colors.blue,
  //       ),
  //       InkWell(
  //         highlightColor: Colors.blue,
  //         splashColor: Colors.blue,
  //         onTap: (){},
  //         child: ListTile(
  //           title: Text("Font"),
  //           subtitle: Text("Customize font style"),
  //           // onTap: (){},
  //         ),
  //       )
  //     ],
  //   );
  // }

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
          child: Column(
            children: [
              _primaryWidget(),
              // _secondaryWidget()
            ],
          ),
        ),
      ),
    );
  }
}
