import 'package:flutter/material.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class PlaylistBuilder extends StatelessWidget {
  const PlaylistBuilder({
    required this.songInfo
  });

  final SongModel songInfo;

  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child) {
        return ListView.separated(
          itemCount: notifier.playlistInfo!.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
          ),
          itemBuilder: (context, playlistIndex){
            final playlistName = notifier.playlistInfo![playlistIndex].playlistName;

            return ListTile(
              title: Text(playlistName, style: ThemeProvider.themeOf(context).data.dialogTheme.contentTextStyle,),
              onTap: () async{
                await notifier.addSongToPlaylist(songInfo, playlistName, notifier.playlistInfo![playlistIndex].key);
                Navigator.pop(context);
                notifier.getPlaylists();
              },
            );
          },
        );
      }
    );
  }
}