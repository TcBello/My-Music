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
  Widget drawerWidget(BuildContext context) {
    return Consumer2<SongPlayerProvider, SongQueryProvider>(
      builder: (context, songPlayer, songQuery, snapshot) {
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              height: 100,
              child: Center(child: Text("Music", style: headerDrawerTextStyle)),
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
              title: Text("Themes"),
            ),
            ListTile(
              onTap: (){
                songPlayer.openEqualizer();
              },
              leading: Icon(
                Icons.equalizer,
                color: Colors.white,
              ),
              title: Text("Equalizer"),
            ),  
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                showDialog(
                  // barrierDismissible: false,
                  context: context,
                  builder: (context){
                    Future.delayed(Duration(seconds: 2), () async{
                      await songQuery.getSongs();
                      Navigator.pop(context);
                    });
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      content: Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Searching..."),
                            SizedBox(height: 20,),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    );
                  }
                );
                // await songQuery.getSongs().then((value){
                //   Navigator.pop(context);
                // });
              },
              leading: Icon(
                Icons.search,
                color: Colors.white,
              ),
              title: Text("Scan"),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return drawerWidget(context);
  }
}