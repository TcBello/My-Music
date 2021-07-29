import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/delete_dialog.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/theme.dart';
import 'package:my_music/ui/themes/background/background_skin.dart';
import 'package:my_music/ui/themes/components/reset_dialog.dart';
import 'package:my_music/ui/themes/text/text_style.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class Themes extends StatelessWidget {

  Widget _themesWidget(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text("Background Skin", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
            fontWeight: FontWeight.bold
          ),),
          subtitle: Text("Customize background wallpaper", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
            color: Colors.white
          ),),
          onTap: (){Navigator.push(context, CupertinoPageRoute(builder: (context) => BackgroundSkin()));},
        ),
        ListTile(
          title: Text("Text", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
            fontWeight: FontWeight.bold
          ),),
          subtitle: Text("Customize text style", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
            color: Colors.white
          ),),
          onTap: (){Navigator.push(context, CupertinoPageRoute(builder: (context) => TextStyleTheme()));},
        ),
        Consumer<CustomThemeProvider>(
          builder: (context, theme, snapshot) {
            return ListTile(
              title: Text("Reset Theme", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text("Set to default theme", style: ThemeProvider.themeOf(context).data.textTheme.subtitle2.copyWith(
                color: Colors.white
              ),),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ResetDialog(
                      title: "Reset",
                      content: "Are you sure you want to reset the theme?",
                      onPressedDelete: () async {
                        await theme.resetTheme(context).whenComplete(() => Navigator.pop(context));
                      },
                    );
                    // return AlertDialog(
                    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    //   title: Text("Reset"),
                    //   content: Text("Are you sure you want to reset the theme?"),
                    //   actions: [
                    //     FlatButton(
                    //       child: Text("Cancel", style: TextStyle(color: Colors.blue),),
                    //       onPressed: () => Navigator.pop(context),
                    //     ),
                    //     FlatButton(
                    //       child: Text("Reset", style: TextStyle(color: Colors.blue),),
                    //       onPressed: () async {
                            
                    //       },
                    //     )
                    //   ],
                    // );
                  },
                );
              },
            );
          }
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Themes", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
        backgroundColor: color2,
      ),
      body: _themesWidget(context),
    );
  }
}
