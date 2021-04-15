import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/themes/themes.dart';
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
          ListTile(
            // onTap: () {Navigator.push(context, CupertinoPageRoute(builder: (context) => EqualizerScreen()));},
            onTap: () {
              Equalizer.open(0);
            },
            leading: Icon(
              Icons.equalizer,
              color: Colors.white,
            ),
            title: Text("Equalizer"),
          ),
          Selector<SongModel, Future<void>>(
            selector: (context, notifier) => notifier.getDataSong(),
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