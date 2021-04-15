import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/tempfile/song_info.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/songs/components/song_builder.dart';
import 'package:provider/provider.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> with TickerProviderStateMixin {
  SongModel _songModel;
  TextEditingController _getText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _songModel = context.read<SongModel>();
    _songModel.getCurrentTextColor();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void showPlaylistDialog(int index, SongInfo songInfo){
  //   showDialog(
  //       context: context,
  //       builder: (context) => PlaylistDialog(getText: _getText, songModel: _songModel)
  //   );
  // }

  // Widget _musicBuilder() {
  //   return Container(
  //     margin: EdgeInsets.zero,
  //     child: ListView.builder(
  //       padding: _songModel.isPlayOnce ? EdgeInsets.fromLTRB(0, 0, 0, 60) : EdgeInsets.zero,
  //       itemCount: _songModel.songInfo.length,
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           hoverColor: Colors.pink,
  //           focusColor: Colors.pinkAccent,
  //           contentPadding: const EdgeInsets.only(
  //               right: 0.5,
  //               left: 10.0
  //           ),
  //           title: Container(
  //             padding: EdgeInsets.only(right: 8.0),
  //             child: Text(
  //               _songModel.songInfo[index].title,
  //               style: musicTextStyle(_songModel.textHexColor),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           subtitle: Container(
  //             padding: EdgeInsets.only(right: 8.0),
  //             child: Text(
  //               _songModel.songInfo[index].artist == "<unknown>"
  //                   ? "Unknown Artist"
  //                   : _songModel.songInfo[index].artist,
  //               // style: defTextStyle,
  //               style: artistMusicTextStyle(_songModel.textHexColor),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           trailing: IconButton(
  //             icon: Icon(Icons.more_vert, color: Color(_songModel.textHexColor)),
  //             onPressed: (){
  //               showModalBottomSheet(
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.only(
  //                           topRight: Radius.circular(30.0),
  //                           topLeft: Radius.circular(30.0)
  //                       )
  //                   ),
  //                   backgroundColor: Colors.white,
  //                   context: context,
  //                   builder: (context){
  //                     return Container(
  //                       height: 260,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Center(
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 children: [
  //                                   AutoSizeText(
  //                                     _songModel.songInfo[index].title,
  //                                     style: headerBottomSheetTextStyle,
  //                                     maxLines: 1,
  //                                   ),
  //                                   SizedBox(height: 5),
  //                                   Divider(thickness: 1.0, color: Colors.grey)
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           ListTile(
  //                             title: Text("Play Next"),
  //                             onTap: (){
  //                               _songModel.playNextSong(_songModel.songInfo[index]);
  //                               Navigator.pop(context);
  //                             },
  //                           ),
  //                           ListTile(
  //                             title: Text("Add to Queue"),
  //                             onTap: (){
  //                               _songModel.addToQueueSong(_songModel.songInfo[index]);
  //                               Navigator.pop(context);
  //                             },
  //                           ),
  //                           Consumer<SongModel>(
  //                             builder: (context, _songModel, child) {
  //                               return ListTile(
  //                                 title: Text("Add to playlist"),
  //                                 onTap: (){
  //                                   Navigator.pop(context);
  //                                   showPlaylistDialog(index);
  //                                   },
  //                               );
  //                             }
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   }
  //               );
  //             },
  //           ),
  //           onTap: () async {
  //             _songModel.setIndex(index);
  //             // await _songModel.playSong();
  //             _songModel.playSong(_songModel.songInfo);
  //             print(_songModel.audioItem);
  //             print("PLAY STARTED!");
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget songListTile(String title, String artist, int index){
  //   bool isSelected = false;
  //   return ListTile(
  //     selected: isSelected,
  //     tileColor: Colors.transparent,
  //     selectedTileColor: Colors.pinkAccent,
  //           contentPadding: const EdgeInsets.only(
  //               right: 0.5,
  //               left: 10.0
  //           ),
  //           title: Container(
  //             padding: EdgeInsets.only(right: 8.0),
  //             child: Text(
  //               title,
  //               style: musicTextStyle(_songModel.textHexColor),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           subtitle: Container(
  //             padding: EdgeInsets.only(right: 8.0),
  //             child: Text(
  //               artist == "<unknown>"
  //                   ? "Unknown Artist"
  //                   : artist,
  //               // style: defTextStyle,
  //               style: artistMusicTextStyle(_songModel.textHexColor),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           trailing: IconButton(
  //             icon: Icon(Icons.more_vert, color: Color(_songModel.textHexColor)),
  //             onPressed: (){
  //               showModalBottomSheet(
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.only(
  //                           topRight: Radius.circular(30.0),
  //                           topLeft: Radius.circular(30.0)
  //                       )
  //                   ),
  //                   backgroundColor: Colors.white,
  //                   context: context,
  //                   builder: (context){
  //                     return Container(
  //                       height: 200, //250 orig height (with list tile EDIT)
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Center(
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 children: [
  //                                   AutoSizeText(
  //                                     title,
  //                                     style: headerBottomSheetTextStyle,
  //                                     maxLines: 1,
  //                                   ),
  //                                   SizedBox(height: 10),
  //                                   Divider(thickness: 1.0, color: Colors.grey)
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           // Consumer<SongModel>(
  //                           //   builder: (context, songModel, child) {
  //                           //     return ListTile(
  //                           //       title: Text("Play Next"),
  //                           //       onTap: (){
  //                           //         // TODO: IMPLEMENT PLAY NEXT FUNCTION
  //                           //         Navigator.pop(context);
  //                           //         // songModel.playNextSong(index, songModel.songInfo[index]);
  //                           //       },
  //                           //     );
  //                           //   }
  //                           // ),
  //                           Consumer<SongModel>(
  //                             builder: (context, _songModel, child) {
  //                               return ListTile(
  //                                 title: Text("Add to playlist"),
  //                                 onTap: (){
  //                                   Navigator.pop(context);
  //                                   showPlaylistDialog(index);
  //                                   },
  //                               );
  //                             }
  //                           ),
  //                           // ListTile(
  //                           //   title: Text("Edit"),
  //                           //   onTap: (){
  //                           //     Navigator.pop(context);
  //                           //     Navigator.push(context, MaterialPageRoute(builder: (context) => SongInfoEdit(title: _songModel.songInfo[index].title, index: index, isSong: true, fromArtist: false,)));
  //                           //   },
  //                           // )
  //                         ],
  //                       ),
  //                     );
  //                   }
  //               );
  //             },
  //           ),
  //           onTap: () async {
  //             isSelected = true;
  //             _songModel.setIndex(index);
  //             await _songModel.playSong();
  //             print(_songModel.audioItem);
  //             print("PLAY STARTED!");
  //           },
  //         );
  // }

  // Widget _musicBuilder() {
  //   return Container(
  //     margin: EdgeInsets.zero,
  //     child: ListView.builder(
  //       padding: _songModel.isPlayOnce ? EdgeInsets.fromLTRB(0, 0, 0, 60) : EdgeInsets.zero,
  //       itemCount: _songModel.songInfo.length,
  //       itemBuilder: (context, index) {
  //         String title = _songModel.songInfo[index].title;
  //         String artist = _songModel.songInfo[index].artist;

  //         return songListTile(title , artist, index);
  //       },
  //     ), 
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongModel>(
      builder: (context, song, child) {
        return song.songInfo != null
            ? SongBuilder()
            : Container();
      },
    );
  }
}

class PopupMenuLobby extends StatefulWidget {
  final int index;
  PopupMenuLobby({Key key, this.index}) : super(key: key);

  @override
  _PopupMenuLobbyState createState() => _PopupMenuLobbyState();
}

class _PopupMenuLobbyState extends State<PopupMenuLobby> {
  final List<String> menu = ["Add to Playlist", "Edit", "Delete"];
  SongModel _model;

  @override
  void initState() {
    super.initState();
    _model = context.read<SongModel>();
  }

  @override
  void dispose(){
    super.dispose();
    _model.dispose();
  }

  Future<void> selectPopupMenu(String select) async {
    if(select == menu[0]){
      print("DO SOMETHING!");
    }
    if(select == menu[1]){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SongInfoEdit(title: menu[1], index: widget.index,)));
    }
    if(select == menu[2]){
      return showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Delete File"),
              content: Text("Do you really want to delete this file?"),
              actions: [
                FlatButton(
                  child: Text("YES"),
                  onPressed: () async {
                    try{
                      final file = File(_model.songInfo[widget.index].filePath);
                      final exist = await file.exists();
                      if(exist){
                        await file.delete(recursive: true);
                      }
                      Navigator.pop(context);
                      print("Delete Successful");
                    }catch(e){
                      print(e);
                      print("Delete Failed");
                    }
                  },
                ),
                FlatButton(
                  child: Text("NO"),
                  onPressed: (){Navigator.pop(context);},
                )
              ],
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Colors.white,),
      onSelected: selectPopupMenu,
      itemBuilder: (context){
        return menu.map((menu) => PopupMenuItem(
          value: menu,
          child: Center(child: Text(menu)),
        )).toList();
      },
    );
  }
}
