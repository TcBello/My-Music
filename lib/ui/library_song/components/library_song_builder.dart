import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class LibrarySongBuilder extends StatelessWidget {
  const LibrarySongBuilder({
    required this.songInfoList
  });

  final List<SongModel> songInfoList;

  @override
  Widget build(BuildContext context) {
    return Consumer2<SongQueryProvider, SongPlayerProvider>(
      builder: (context, songQuery, songPlayer, child) {
        final sdkInt = songQuery.androidDeviceInfo!.version.sdkInt;

        return ListBody(
          children: List.generate(songInfoList.length,(index) => SongTile2(
            songInfo: songInfoList[index],
            onTap: (){
              songPlayer.playSong(songInfoList, index);
            },
          )),
        );
      },
    );
  }
}