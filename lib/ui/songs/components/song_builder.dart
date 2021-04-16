import 'package:flutter/material.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:provider/provider.dart';

class SongBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongModel>(context);

    return Container(
      margin: EdgeInsets.zero,
      child: ListView.builder(
        padding: provider.isPlayOnce ? EdgeInsets.fromLTRB(0, 0, 0, 70) : EdgeInsets.zero,
        itemCount: provider.songInfo.length,
        itemBuilder: (context, index) {
          return SongTile(
            songInfo: provider.songInfo[index],
            onTap: (){
              provider.setIndex(index);
              provider.playSong(provider.songInfo);
            },
          );
        },
      ),
    );
  }
}