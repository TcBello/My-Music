import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class LibrarySongBuilder extends StatelessWidget {
  const LibrarySongBuilder({this.songInfoList});
  final List<SongInfo> songInfoList;

  @override
  Widget build(BuildContext context) {
    return Consumer2<SongQueryProvider, SongPlayerProvider>(
      builder: (context, songQuery, songPlayer, child) {
        return ListBody(
          children: List.generate(songInfoList.length,(index) => SongTile2(
            songInfo: songInfoList[index],
            onTap: () async {
              // notifier.setIndex(index);
              // await notifier.playSong(songInfoList);
              songQuery.setQueue(songInfoList);
              songPlayer.playSong(songInfoList, index);
            },
          )),
        );
      },
    );
  }
}