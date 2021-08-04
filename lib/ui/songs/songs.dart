import 'package:flutter/material.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/songs/components/song_builder.dart';
import 'package:provider/provider.dart';

class Songs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
      builder: (context, song, child) {
        return song.songInfo != null
          ? SongBuilder()
          : Container();
      },
    );
  }
}