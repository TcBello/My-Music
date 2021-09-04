import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/library_song/components/header.dart';
import 'package:my_music/ui/library_song/components/library_song_builder.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class LibrarySong extends StatelessWidget {
  final AlbumModel albumInfo;
  final List<SongModel> songInfoList;

  const LibrarySong({
    required this.albumInfo,
    required this.songInfoList
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: NestedScrollView(
        headerSliverBuilder: (context, isBoxScreenScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: color2,
              floating: true,
              pinned: true,
              forceElevated: true,
              actions: [
                Consumer<SongQueryProvider>(
                  builder: (context, notifier, child) {
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
              flexibleSpace: Consumer<SongQueryProvider>(
                builder: (context, notifier, snapshot) {
                  // final albumArtwork = albumInfo.albumArt;
                  final albumArtwork2 = notifier.albumArtwork(albumInfo.id);
                  final hasArtWork = File(notifier.albumArtwork(albumInfo.id)).existsSync();

                  return FlexibleSpaceBar(
                    title: ConstrainedBox(
                      child: AutoSizeText(
                        albumInfo.album,
                        style: ThemeProvider.themeOf(context).data.textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                        maxHeight: 35
                      ),
                    ),
                    centerTitle: true,
                    background: Container(
                      color: color1,
                      child: Hero(
                        tag: albumInfo.id,
                        // child: isSdk28Below
                        //   ? albumArtwork != null
                        //     ? Image.file(
                        //         File(albumArtwork),
                        //         fit: BoxFit.cover,
                        //       )
                        //     : Image.file(
                        //         File(notifier.defaultAlbum),
                        //         fit: BoxFit.cover,
                        //       )
                        //   : hasArtWork
                        //     ? Image.file(
                        //         File(albumArtwork2),
                        //         fit: BoxFit.cover,
                        //       )
                        //     : Image.file(
                        //         File(notifier.defaultAlbum),
                        //         fit: BoxFit.cover,
                        //       ),
                        child: hasArtWork
                          ? Image.file(
                              File(albumArtwork2),
                              fit: BoxFit.cover,
                          )
                          : Image.file(
                              File(notifier.defaultAlbum),
                              fit: BoxFit.cover,
                          ),
                      ),
                    ),
                  );
                }
              ),
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
          )
        ),
      )
    );
  }
}
