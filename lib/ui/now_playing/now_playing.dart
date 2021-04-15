import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/tempfile/song_info.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/now_playing/components/now_playing_builder.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  TextEditingController _getText = TextEditingController();
  SongModel _songModel;

  @override
  void initState() {
    super.initState();
    _songModel = context.read<SongModel>();
  }

  // void showPlaylistDialog(int index) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: Text("Add to playlist"),
  //             content: Container(
  //               height: 150,
  //               width: 150,
  //               child: ListView.builder(
  //                 itemCount: _songModel.playlistInfo.length,
  //                 itemBuilder: (context, playlistIndex) {
  //                   return ListTile(
  //                     title: Text(_songModel.playlistInfo[playlistIndex].name),
  //                     onTap: () async {
  //                       await _songModel.addSongToPlaylist(
  //                           _songModel.songInfo[index], playlistIndex);
  //                       Fluttertoast.showToast(
  //                           msg:
  //                               "1 song added to ${_songModel.playlistInfo[playlistIndex].name}",
  //                           toastLength: Toast.LENGTH_SHORT,
  //                           gravity: ToastGravity.BOTTOM,
  //                           backgroundColor: Colors.grey[800],
  //                           textColor: Colors.white,
  //                           fontSize: 16.0);
  //                       Navigator.pop(context);
  //                       _songModel.getDataSong();
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //             actions: [
  //               FlatButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("Cancel"),
  //               ),
  //               FlatButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   showDialog(
  //                     context: context,
  //                     builder: (context) => AlertDialog(
  //                       title: Text("Create Playlist"),
  //                       content: TextField(
  //                         controller: _getText,
  //                         decoration: InputDecoration(labelText: "Name"),
  //                       ),
  //                       actions: [
  //                         FlatButton(
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           },
  //                           child: Text("Cancel"),
  //                         ),
  //                         FlatButton(
  //                           onPressed: () async {
  //                             // TODO: FIX PLAYLSIT
  //                             // await _songModel.createPlaylist(_getText.text);
  //                             await _songModel.getDataSong();
  //                             Fluttertoast.showToast(
  //                                 msg: "${_getText.text} created successfully",
  //                                 toastLength: Toast.LENGTH_SHORT,
  //                                 gravity: ToastGravity.BOTTOM,
  //                                 backgroundColor: Colors.grey[800],
  //                                 textColor: Colors.white,
  //                                 fontSize: 16.0);
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
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Now Playing",
            style: headerLibrarySongListTextStyle,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0.0,
        ),
        body: NowPlayingBuilder(),
        // body: Container(
          // color: Colors.white,
          // child: Consumer<SongModel>(
          //   builder: (context, songModel, child) {
          //     var nowPlayingSong = songModel.nowPlayingSongs;
          //     return ListView.builder(
          //       itemCount: nowPlayingSong.length,
          //       itemBuilder: (context, index) => SongTile2(
          //         songInfo: nowPlayingSong[index],
          //         onTap: (){},
          //       ),
                // itemBuilder: (context, index) => ListTile(
                //     tileColor: nowPlayingSong[index].title == songModel.audioItem.title
                //       ? Colors.pinkAccent
                //       : Colors.white,
                //     onTap: () async {
                //       songModel.setIndex(index);
                //       songModel.playSong(songModel.nowPlayingSongs);
                //       print("PLAY STARTED!");
                //     },
                //     contentPadding: EdgeInsets.only(right: 0.5, left: 10.0),
                //     title: Text(
                //       nowPlayingSong[index].title,
                //       overflow: TextOverflow.ellipsis,
                //       style: nowPlayingSong[index].title == songModel.audioItem.title
                //           ? nowPlayingStyle(true)
                //           : nowPlayingStyle(false),
                //     ),
                //     subtitle: Text(
                //       nowPlayingSong[index].artist == "<unknown>"
                //           ? "Unknown Artist"
                //           : nowPlayingSong[index].artist,
                //       overflow: TextOverflow.ellipsis,
                //       style: nowPlayingSong[index].title == songModel.audioItem.title
                //           ? nowPlayingStyle(true)
                //           : nowPlayingStyle(false),
                //     ),
                //     trailing: IconButton(
                //       icon: Icon(
                //         Icons.more_vert,
                //         color: nowPlayingSong[index].title == songModel.audioItem.title
                //           ? Colors.white
                //           : Colors.black
                //       ),
                //       onPressed: () {
                //         showModalBottomSheet(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.only(
                //                     topRight: Radius.circular(30.0),
                //                     topLeft: Radius.circular(30.0))),
                //             backgroundColor: Colors.white,
                //             context: context,
                //             builder: (context) {
                //               return Container(
                //                 height: 260,
                //                 child: Column(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceEvenly,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Center(
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Column(
                //                           children: [
                //                             AutoSizeText(
                //                               nowPlayingSong[index].title,
                //                               style: headerBottomSheetTextStyle,
                //                               maxLines: 1,
                //                             ),
                //                             SizedBox(height: 5),
                //                             Divider(thickness: 1.0, color: Colors.grey)
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                     ListTile(
                //                       title: Text("Play Next"),
                //                       onTap: (){
                //                         songModel.playNextSong(songModel.nowPlayingSongs[index]);
                //                         Navigator.pop(context);
                //                       },
                //                     ),
                //                     ListTile(
                //                       title: Text("Add to Queue"),
                //                       onTap: (){
                //                         songModel.addToQueueSong(songModel.nowPlayingSongs[index]);
                //                         Navigator.pop(context);
                //                       },
                //                     ),
                //                     Consumer<SongModel>(
                //                       builder: (context, _songModel, child) {
                //                         return ListTile(
                //                           title: Text("Add to playlist"),
                //                           onTap: (){
                //                             Navigator.pop(context);
                //                             showPlaylistDialog(index);
                //                             },
                //                         );
                //                       }
                //                     ),
                //                   ],
                //                 ),
                //               );
                //             });
                //       },
                //     ),
                //   ),
              // );
            // },
          // ),
        // )
    );
  }
}