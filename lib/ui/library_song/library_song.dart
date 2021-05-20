import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/library_song/components/header.dart';
import 'package:my_music/ui/library_song/components/library_song_builder.dart';
import 'package:provider/provider.dart';

class LibrarySong extends StatelessWidget {
  final AlbumInfo albumInfo;
  final List<SongInfo> songInfoList;
  const LibrarySong(this.albumInfo, this.songInfoList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, isBoxScreenScrolled) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            forceElevated: true,
            actions: [
              Consumer<SongQueryProvider>(builder: (context, notifier, child) {
                return IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    notifier.initSongSearch();
                    showSearch(context: context, delegate: Search());
                  },
                );
              })
            ],
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
                background: albumInfo.albumArt != null
                    ? Image.file(
                        File(albumInfo.albumArt),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/imgs/defalbum.png",
                        fit: BoxFit.cover,
                      )),
          ),
        ];
      },
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                albumInfo: albumInfo,
              ),
              LibrarySongBuilder(
                songInfoList: songInfoList,
              )
            ],
          )),
    ));
  }
}
