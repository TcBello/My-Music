import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class PlaylistBuilder extends StatelessWidget {
  const PlaylistBuilder({this.songInfo});

  final SongInfo songInfo;

  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child) {
        return ListView.separated(
          itemCount: notifier.playlistInfo.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
          ),
          itemBuilder: (context, playlistIndex){
            final playlistName = notifier.playlistInfo[playlistIndex].name;

            return ListTile(
              title: Text(playlistName, style: dialogContentTextStyle,),
              onTap: () async {
                await notifier.addSongToPlaylist(songInfo, playlistIndex);
                Fluttertoast.showToast(
                    msg: "1 song added to $playlistName",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[800],
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.pop(context);
                await notifier.getSongs();
              },
            );
          },
        );
      }
    );
  }
}