import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class FontSelectionUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeProvider>(context);
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Font Selection", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
        backgroundColor: color2,
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: () async {
              var result = await theme.applyFont(context);
              if(result)  Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: _size.width,
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
              // RadioListTile(
              //   title: Text("Montserrat", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              //     fontWeight: FontWeight.w600
              //   ),),
              //   value: "Montserrat",
              //   groupValue: theme.font,
              //   onChanged: theme.changeFont,
              //   activeColor: color4,
              //   controlAffinity: ListTileControlAffinity.trailing,
              // ),
              // RadioListTile(
              //   title: Text("Montserrat", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              //     fontWeight: FontWeight.w600
              //   ),),
              //   value: "Montserrat",
              //   groupValue: theme.font,
              //   onChanged: theme.changeFont,
              //   activeColor: color4,
              //   controlAffinity: ListTileControlAffinity.trailing,
              // ),
              // RadioListTile(
              //   title: Text("Montserrat", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              //     fontWeight: FontWeight.w600
              //   ),),
              //   value: "Montserrat",
              //   groupValue: theme.font,
              //   onChanged: theme.changeFont,
              //   activeColor: color4,
              //   controlAffinity: ListTileControlAffinity.trailing,
              // )
            ],
          ),
        ),
      ),
    );
  }
}