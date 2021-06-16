import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/playlist_builder.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class PlaylistDialog extends StatelessWidget {
  const PlaylistDialog({this.songInfo});

  final SongInfo songInfo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Add to playlist", style: dialogTitleTextStyle,),
      content: Container(
        height: 175,
        width: 150,
        child: PlaylistBuilder(songInfo: songInfo,),
      ),
      actions: [
        FlatButton(
          onPressed: (){Navigator.pop(context);},
          child: Text("Cancel", style: dialogButtonTextStyle,),
        ),
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text("Create Playlist", style: dialogTitleTextStyle,),
                content: TextField(
                  controller: playlistController,
                  decoration: InputDecoration(
                      labelText: "Name"
                  ),
                ),
                actions: [
                  FlatButton(
                    onPressed: (){Navigator.pop(context);},
                    child: Text("Cancel", style: dialogButtonTextStyle,),
                  ),
                  Consumer<SongQueryProvider>(
                    builder: (context, notifier, child) {
                      return FlatButton(
                        onPressed: () async {
                          // await _songModel.addSongAndCreatePlaylist(_songModel.songInfo[index], _getText.text);
                          await notifier.createPlaylist(playlistController.text, songInfo);
                          // await notifier.getDataSong();
                          Fluttertoast.showToast(
                              msg: "1 song added to ${playlistController.text}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[800],
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          playlistController.text = "";
                          Navigator.pop(context);
                        },
                        child: Text("Create", style: dialogButtonTextStyle,),
                      );
                    }
                  ),
                ],
              ),
            );
          },
          child: Text("New", style: dialogButtonTextStyle,),
        )
      ],
    );
  }
}