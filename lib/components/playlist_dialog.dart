import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/playlist_builder.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class PlaylistDialog extends StatelessWidget {
  const PlaylistDialog({
    required this.songInfo
  });

  final SongInfo songInfo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ThemeProvider.themeOf(context).data.dialogTheme.shape,
      title: Text("Add to Playlist", style: ThemeProvider.themeOf(context).data.dialogTheme.titleTextStyle,),
      content: Container(
        height: 175,
        width: 150,
        child: PlaylistBuilder(songInfo: songInfo,),
      ),
      actions: [
        TextButton(
          onPressed: (){Navigator.pop(context);},
          child: Text("CANCEL", style: ThemeProvider.themeOf(context).data.textTheme.button,),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text("Create Playlist", style: ThemeProvider.themeOf(context).data.dialogTheme.titleTextStyle,),
                content: TextField(
                  controller: playlistController,
                  decoration: InputDecoration(
                      labelText: "Name"
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: (){Navigator.pop(context);},
                    child: Text("CANCEL", style: ThemeProvider.themeOf(context).data.textTheme.button,),
                  ),
                  Consumer<SongQueryProvider>(
                    builder: (context, notifier, child) {
                      return TextButton(
                        onPressed: () async {
                          await notifier.createPlaylist(playlistController!.text, songInfo, playlistController!.text);
                          playlistController!.text = "";
                          Navigator.pop(context);
                        },
                        child: Text("CREATE", style:ThemeProvider.themeOf(context).data.textTheme.button,),
                      );
                    }
                  ),
                ],
              ),
            );
          },
          child: Text("NEW", style: ThemeProvider.themeOf(context).data.textTheme.button,),
        )
      ],
    );
  }
}