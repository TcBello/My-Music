import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/playlist_dialog.dart';
import 'package:my_music/main.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class SongBottomSheetOptions extends StatelessWidget {
  const SongBottomSheetOptions({Key key, this.songInfo}) : super(key: key);

  final SongInfo songInfo;

  void showPlaylistDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => PlaylistDialog(songInfo: songInfo,),
    );
  }

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songTitle = songInfo.title;

    return Container(
      height: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  AutoSizeText(
                    songTitle,
                    style: headerBottomSheetTextStyle,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 1.0, color: Colors.grey)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Play Next"),
            onTap: () {
              songQueryProvider.playNextSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Queue"),
            onTap: () {
              songQueryProvider.addToQueueSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to playlist"),
            onTap: () {
              Navigator.pop(context);
              showPlaylistDialog(context);
            },
          )
        ],
      ),
    );
  }
}
