import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class FontSelectionUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeProvider>(context);

    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Font Selection", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
        backgroundColor: color2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: () async {
              var result = await theme.applyFont(context);
              if(result){
                Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
                  Navigator.pop(context);
                });
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                title: Text("Roboto (Default)", style: defaultStyle),
                value: "default_theme",
                groupValue: theme.font,
                onChanged: (value) => theme.changeFont(value),
                activeColor: color4,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile(
                title: Text("Montserrat", style: monserratStyle),
                value: "montserrat_theme",
                groupValue: theme.font,
                onChanged: (value) => theme.changeFont(value),
                activeColor: color4,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile(
                title: Text("Comfortaa", style: comfortaaStyle),
                value: "comfortaa_theme",
                groupValue: theme.font,
                onChanged: theme.changeFont,
                activeColor: color4,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile(
                title: Text("HK Grotesk", style: hkGroteskStyle),
                value: "hkgrotesk_theme",
                groupValue: theme.font,
                onChanged: theme.changeFont,
                activeColor: color4,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile(
                title: Text("Chivo", style: chivoStyle),
                value: "chivo_theme",
                groupValue: theme.font,
                onChanged: theme.changeFont,
                activeColor: color4,
                controlAffinity: ListTileControlAffinity.trailing,
              )
            ],
          ),
        ),
      ),
    );
  }
}