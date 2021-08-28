import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class SongBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final sdkInt = songQueryProvider.androidDeviceInfo!.version.sdkInt;

    return songQueryProvider.songInfo.length > 0
      ? Container(
        margin: EdgeInsets.zero,
        child: ListView.builder(
          padding: songPlayerProvider.isPlayOnce || songPlayerProvider.isBackgroundRunning
            ? EdgeInsets.fromLTRB(0, 0, 0, 70)
            : EdgeInsets.zero,
          itemCount: songQueryProvider.songInfo.length,
          itemBuilder: (context, index) {
            return SongTile(
              songInfo: songQueryProvider.songInfo[index],
              onTap: (){
                songPlayerProvider.playSong(songQueryProvider.songInfo, index, sdkInt);
              },
            );
          },
        ),
      )
      : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: CircularProgressIndicator(
            color: color3,
          ),
        ),
      );
  }
}