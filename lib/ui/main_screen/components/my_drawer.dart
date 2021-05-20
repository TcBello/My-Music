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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
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
          Consumer<SongPlayerProvider>(
            builder: (context, songPlayer, child) {
              return ListTile(
                onTap: () async{
                  await songPlayer.openEqualizer();
                },
                leading: Icon(
                  Icons.equalizer,
                  color: Colors.white,
                ),
                title: Text("Equalizer"),
              );
            }
          ),
          Selector<SongQueryProvider, Future<void>>(
            selector: (context, notifier) => notifier.getSongs(),
            builder: (context, data, child) {
              return ListTile(
                onTap: () async {
                  await data.then((value) => Navigator.pop(context));
                },
                leading: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                title: Text("Scan"),
              );
            }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
          textTheme: drawerTextStyle,
        ),
        child: drawerWidget(context));
  }
}