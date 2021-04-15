import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/ui/albums/albums.dart';
import 'package:my_music/ui/artists/artists.dart';
import 'package:my_music/ui/now_playing/now_playing.dart';
import 'package:my_music/ui/playlists/playlists.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/ui/songs/songs.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/themes/themes.dart';
import 'package:my_music/ui/mini_player/mini_player.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/ui/main_screen/components/background_wallpaper.dart';
import 'package:my_music/ui/main_screen/components/blur_effect.dart';
import 'package:my_music/ui/main_screen/components/main_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:miniplayer/miniplayer.dart';

class MainScreen extends StatelessWidget {
  Future<bool> onWillScope(bool isPlayerExpand){
    if(isPlayerExpand){
      miniPlayerController.animateToHeight(state: PanelState.MIN);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongModel>(context);
    
    return WillPopScope(
      onWillPop: (){
        return onWillScope(provider.isPlayerExpand);
      },
      child: Stack(
        children: <Widget>[
          BackgroundWallpaper(),
          BlurEffect(),
          MainUI(),
          Selector<SongModel, bool>(
            selector: (context, notifier) => notifier.isPlayOnce,
            builder: (context, data, child) {
              if(data){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: MiniPlayer(),
                );
              }

              return Container();
            },
          )
        ],
      ),
    );
  }
}

class PopupMenu extends StatefulWidget {
  final int index;
  PopupMenu(this.index);

  @override
  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  final List<String> menu = ["Add to Playlist"];
  TextEditingController _getText = TextEditingController();

  // void showPlaylistDialog(index){
  //   showDialog(
  //       context: context,
  //       builder: (context) => Consumer<SongModel>(
  //         builder: (context, _songModel, snapshot) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //             title: Text("Add to playlist"),
  //             content: Container(
  //               height: 150,
  //               width: 150,
  //               child: ListView.builder(
  //                 itemCount: _songModel.playlistInfo.length,
  //                 itemBuilder: (context, playlistIndex){
  //                   return ListTile(
  //                     title: Text(_songModel.playlistInfo[playlistIndex].name),
  //                     onTap: () async {
  //                       await _songModel.addSongToPlaylist(_songModel.songInfo[index], playlistIndex);
  //                       Fluttertoast.showToast(
  //                           msg: "1 song added to ${_songModel.playlistInfo[playlistIndex].name}",
  //                           toastLength: Toast.LENGTH_SHORT,
  //                           gravity: ToastGravity.BOTTOM,
  //                           backgroundColor: Colors.grey[800],
  //                           textColor: Colors.white,
  //                           fontSize: 16.0
  //                       );
  //                       Navigator.pop(context);
  //                       _songModel.getDataSong();
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //             actions: [
  //               FlatButton(
  //                 onPressed: (){Navigator.pop(context);},
  //                 child: Text("Cancel"),
  //               ),
  //               FlatButton(
  //                 onPressed: (){
  //                   Navigator.pop(context);
  //                   showDialog(
  //                     context: context,
  //                     builder: (context) => AlertDialog(
  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //                       title: Text("Create Playlist"),
  //                       content: TextField(
  //                         controller: _getText,
  //                         decoration: InputDecoration(
  //                             labelText: "Name"
  //                         ),
  //                       ),
  //                       actions: [
  //                         FlatButton(
  //                           onPressed: (){Navigator.pop(context);},
  //                           child: Text("Cancel"),
  //                         ),
  //                         FlatButton(
  //                           onPressed: () async {
  //                             // await _songModel.addSongAndCreatePlaylist(_songModel.songInfo[index], _getText.text);
  //                             await _songModel.createPlaylist(_getText.text);
  //                             await _songModel.getDataSong();
  //                             Fluttertoast.showToast(
  //                                 msg: "${_getText.text} created successfully",
  //                                 toastLength: Toast.LENGTH_SHORT,
  //                                 gravity: ToastGravity.BOTTOM,
  //                                 backgroundColor: Colors.grey[800],
  //                                 textColor: Colors.white,
  //                                 fontSize: 16.0
  //                             );
  //                             _getText.text = "";
  //                             Navigator.pop(context);
  //                             showPlaylistDialog(index);
  //                           },
  //                           child: Text("Create"),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //                 child: Text("New"),
  //               )
  //             ],
  //           );
  //         }
  //       )
  //   );
  // }

  // void selectPopupMenu(String select) {
  //   if (select == menu[0]) {
  //     showPlaylistDialog(widget.index);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      icon: Icon(
        Icons.more_vert,
        color: Colors.pinkAccent,
      ),
      // onSelected: selectPopupMenu,
      itemBuilder: (context) {
        return menu
            .map((menu) => PopupMenuItem(
                  value: menu,
                  child: Center(child: Text(menu)),
                ))
            .toList();
      },
    );
  }
}
