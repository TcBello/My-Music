import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({
    required this.songSearchList
  });

  final List<SongModel> songSearchList;

  Widget _backgroundWidget(){
    return Consumer<CustomThemeProvider>(
      builder: (context, theme, snapshot) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: theme.backgroundFilePath == "" || !File(theme.backgroundFilePath).existsSync()
            ? color1
            : Colors.transparent,
          child: theme.backgroundFilePath == "" || !File(theme.backgroundFilePath).existsSync()
            ? Container()
            : ClipRect(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: theme.blurValue,
                  sigmaY: theme.blurValue
                ),
                child: Image.file(
                  File(theme.backgroundFilePath),
                  fit: BoxFit.cover,
                ),
              ),
            )
          );
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _backgroundWidget(),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    bottom: 10
                  ),
                  child: Text("Search Result", style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w600
                  ),),
                ),
                Consumer2<SongPlayerProvider, SongQueryProvider>(
                  builder: (context, songPlayer, songQuery, child){

                    return Column(
                      children: List.generate(songSearchList.length, (index) => SongTile(
                        songInfo: songSearchList[index],
                        onTap: (){
                          songPlayer.playSong(songSearchList, index);
                        },
                      )),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}