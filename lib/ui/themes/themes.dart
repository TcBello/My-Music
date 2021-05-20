import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/delete_dialog.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/theme.dart';
import 'package:my_music/ui/themes/background/background_skin.dart';
import 'package:my_music/ui/themes/text/text_style.dart';
import 'package:provider/provider.dart';

class Themes extends StatelessWidget {

  Widget _themesWidget(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text("Background Skin"),
          subtitle: Text("Customize background wallpaper"),
          onTap: (){Navigator.push(context, CupertinoPageRoute(builder: (context) => BackgroundSkin()));},
        ),
        ListTile(
          title: Text("Text"),
          subtitle: Text("Customize text style"),
          onTap: (){Navigator.push(context, CupertinoPageRoute(builder: (context) => TextStyleTheme()));},
        ),
        Consumer<ThemeProvider>(
          builder: (context, theme, snapshot) {
            return ListTile(
              title: Text("Reset Theme"),
              subtitle: Text("Set to default theme"),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DeleteDialog(
                      title: "Reset",
                      content: "Are you sure you want to reset the theme?",
                      onPressedDelete: () async {
                        await theme.resetTheme().then((value) => Navigator.pop(context));
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
      appBar: AppBar(
        title: Text("Themes"),
      ),
      body: _themesWidget(context),
    );
  }
}
