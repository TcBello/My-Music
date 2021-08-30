import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class ArtistSongBuilder extends StatelessWidget {
  const ArtistSongBuilder({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<SongQueryProvider, SongPlayerProvider>(
      builder: (context, songQuery, songPlayer, child){
        return Column(
          children: List.generate(songQuery.songInfoFromArtist!.length, (index) => SongTile2(
            songInfo: songQuery.songInfoFromArtist![index],
            onTap: (){
              songPlayer.playSong(songQuery.songInfoFromArtist!, index);
            },
          ),
        ));
      },
    );
  }
}