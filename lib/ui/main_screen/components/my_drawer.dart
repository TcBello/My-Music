import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/themes/themes.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {

  void _showDialogTimer(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => Consumer<SongPlayerProvider>(
        builder: (context, songPlayer, child) {
          songPlayer.resetTimer();
          
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              height: 300,
              child: Column(
                children: [
                  Text("Minutes", style: timerHeaderTextStyle),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 100,
                      onSelectedItemChanged: (value) => songPlayer.selectTimerItem(value),
                      children: List.generate(100, (index) => Center(
                        child: Text(
                          (index).toString(),
                          style: timerTextStyle,
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancel", style: dialogButtonTextStyle,),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Apply", style: dialogButtonTextStyle,),
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
                child: Center(child: Text("My Music", style: headerDrawerTextStyle)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => Themes()));
                },
                leading: Icon(
                  Icons.wallpaper,
                  color: Colors.white,
                ),
                title: Text("Themes", style: drawerTextStyle,),
              ),
              ListTile(
                onTap: (){
                  songPlayer.openEqualizer();
                },
                leading: Icon(
                  Icons.equalizer,
                  color: Colors.white,
                ),
                title: Text("Equalizer", style: drawerTextStyle,),
              ),  
              ListTile(
                onTap: () async {
                  var file = await songQuery.validatorFile();
                  await songQuery.resetCache();
                  Navigator.pop(context);
                  songQuery.getSongs();
                },
                leading: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                title: Text("Scan", style: drawerTextStyle,),
              ),
              ListTile(
                leading: Icon(Icons.timer_rounded, color: Colors.white,),
                title: Text("Sleep Timer", style: drawerTextStyle,),
                onTap: () => _showDialogTimer(context),
              )
            ],
          );
        }
      ),
    );
  }
}