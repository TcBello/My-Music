import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class MyDrawer extends StatelessWidget {

  void _showDialogTimer(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => Consumer<SongPlayerProvider>(
        builder: (context, songPlayer, child) {
          songPlayer.resetTimer();
          
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: ThemeProvider.themeOf(context).data.dialogTheme.shape,
            content: SizedBox(
              height: 300,
              child: Column(
                children: [
                  Text("Minutes", style: ThemeProvider.themeOf(context).data.textTheme.headline5.copyWith(
                    fontSize: 25
                  )),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 100,
                      onSelectedItemChanged: (value) => songPlayer.selectTimerItem(value),
                      children: List.generate(100, (index) => Center(
                        child: Text(
                          (index).toString(),
                          style: ThemeProvider.themeOf(context).data.textTheme.headline5.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 22
                          )
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("CANCEL", style: ThemeProvider.themeOf(context).data.textTheme.button,),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("APPLY", style: ThemeProvider.themeOf(context).data.textTheme.button),
                onPressed: (){
                  songPlayer.setTimer();
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color1,
      child: Consumer2<SongPlayerProvider, SongQueryProvider>(
        builder: (context, songPlayer, songQuery, snapshot) {
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                height: 100,
                child: Center(child: Text("My Music", style: ThemeProvider.themeOf(context).data.textTheme.headline4)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => Themes()));
                },
                leading: Icon(
                  Icons.wallpaper,
                  color: Colors.white,
                ),
                title: Text("Themes", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w500
                ),),
              ),
              ListTile(
                onTap: (){
                  songPlayer.openEqualizer();
                },
                leading: Icon(
                  Icons.equalizer,
                  color: Colors.white,
                ),
                title: Text("Equalizer", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w500
                ),),
              ),  
              ListTile(
                onTap: () async {
                  await songQuery.resetCache();
                  Navigator.pop(context);
                  songQuery.getSongs();
                },
                leading: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                title: Text("Scan", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w500
                ),),
              ),
              ListTile(
                leading: Icon(Icons.timer_rounded, color: Colors.white,),
                title: Text("Sleep Timer", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w500
                ),),
                onTap: () => _showDialogTimer(context),
              )
            ],
          );
        }
      ),
    );
  }
}