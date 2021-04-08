import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/themes/background_skin.dart';
import 'package:my_music/themes/text_style.dart';
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
        Consumer<SongModel>(
          builder: (context, songModel, snapshot) {
            return ListTile(
              title: Text("Reset Theme"),
              subtitle: Text("Set to default theme"),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Text("Reset"),
                      content: Text("Are you sure you want to reset the theme?"),
                      actions: [
                        FlatButton(
                          child: Text("Cancel", style: TextStyle(color: Colors.blue),),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text("Reset", style: TextStyle(color: Colors.blue),),
                          onPressed: () async {
                            await songModel.resetTheme().then((value) => Navigator.pop(context));
                          },
                        )
                      ],
                    );
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
