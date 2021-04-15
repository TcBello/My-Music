import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
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
              Consumer<SongModel>(builder: (context, notifier, child) {
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
            flexibleSpace: FlexibleSpaceBar(background: Consumer<SongModel>(
              builder: (context, notifier, child) {
                // TODO: FIX ALBUM ART FROM PLAYLIST
                // return notifier.albumInfo[widget.indexFromOutside].albumArt != null
                //     ? Image.file(
                //         File(notifier.albumInfo[widget.indexFromOutside].albumArt),
                //         fit: BoxFit.cover,
                //       )
                //     : Image.asset(
                //         "assets/imgs/defalbum.png",
                //         fit: BoxFit.cover,
                //       );
                return albumInfo.albumArt != null
                    ? Image.file(
                        File(albumInfo.albumArt),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/imgs/defalbum.png",
                        fit: BoxFit.cover,
                      );
              },
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
              Header(albumInfo: albumInfo,),
              LibrarySongBuilder(
                songInfoList: songInfoList,
              )
            ],
          )),
    ));
  }
}

