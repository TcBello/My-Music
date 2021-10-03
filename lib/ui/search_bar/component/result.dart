import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ResultSong extends StatelessWidget {
  const ResultSong({
    required this.suggestionNotifier,
  });

  final ValueNotifier<List<SongModel>> suggestionNotifier;

  @override
  Widget build(BuildContext context) {
    final songPlayer = Provider.of<SongPlayerProvider>(context);

    return ValueListenableBuilder<List<SongModel>>(
      valueListenable: suggestionNotifier,
      builder: (context, suggestion, child) {
        return Column(
          children: List.generate(suggestion.length, (index){
            return SongTile(
              songInfo: suggestion[index],
              onTap: (){
                songPlayer.playSong(suggestion, index);
              }
            );
          }),
        );
      }
    );
  }
}

class ResultArtist extends StatelessWidget {
  const ResultArtist({
    required this.suggestionNotifier,
  });

  final ValueNotifier<List<SongModel>> suggestionNotifier;

  @override
  Widget build(BuildContext context) {
    final songPlayer = Provider.of<SongPlayerProvider>(context);

    return ValueListenableBuilder<List<SongModel>>(
      valueListenable: suggestionNotifier,
      builder: (context, suggestion, child) {
        return Column(
          children: List.generate(suggestion.length, (index){
            return SongTile(
              songInfo: suggestion[index],
              onTap: (){
                songPlayer.playSong(suggestion, index);
              }
            );
          }),
        );
      }
    );
  }
}