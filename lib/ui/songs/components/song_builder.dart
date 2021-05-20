import 'package:flutter/material.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class SongBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);
    final songQueryProvider = Provider.of<SongQueryProvider>(context);

    return Container(
      margin: EdgeInsets.zero,
      child: ListView.builder(
        padding: songPlayerProvider.isPlayOnce
          ? EdgeInsets.fromLTRB(0, 0, 0, 70)
          : EdgeInsets.zero,
        itemCount: songQueryProvider.songInfo.length,
        itemBuilder: (context, index) {
          return SongTile(
            songInfo: songQueryProvider.songInfo[index],
            onTap: (){
              songQueryProvider.setQueue(songQueryProvider.songInfo);
              songPlayerProvider.playSong(songQueryProvider.songInfo, index);
            },
          );
        },
      ),
    );
  }
}