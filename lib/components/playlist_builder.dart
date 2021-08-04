import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class PlaylistBuilder extends StatelessWidget {
  const PlaylistBuilder({
    @required this.songInfo
  });

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
              title: Text(playlistName, style: ThemeProvider.themeOf(context).data.dialogTheme.contentTextStyle,),
              onTap: (){
                notifier.addSongToPlaylist(songInfo, playlistIndex, playlistName);
                Navigator.pop(context);
                notifier.getSongs();
              },
            );
          },
        );
      }
    );
  }
}