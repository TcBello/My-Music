import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/library_song/components/playlist_song_tile.dart';
import 'package:provider/provider.dart';

class LibrarySongPlaylist extends StatelessWidget {
  final int indexFromOutside;
  LibrarySongPlaylist(this.indexFromOutside);

  Widget _librarySongWidget() {
    return Consumer2<SongQueryProvider, SongPlayerProvider>(
      builder: (context, songQuery, songPlayer, child) {
        return ListBody(
          children: List.generate(
              songQuery.songInfoFromPlaylist.length, (index) => PlaylistSongTile(
                songInfo: songQuery.songInfoFromPlaylist[index],
                onTap: (){
                  songPlayer.playSong(songQuery.songInfoFromPlaylist, index);
                },
                index: indexFromOutside,
              )
          ),
        );
      },
    );
  }

  Widget _headerWidget() {
    return Consumer<SongQueryProvider>(builder: (context, song, child) {
      return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: AutoSizeText(
            song.playlistInfo[indexFromOutside].name,
            maxLines: 2,
            style: headerLibrarySongListTextStyle,
          ),
        ),
      );
    });
  }

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
              Consumer<SongQueryProvider>(builder: (context, song, child) {
                return IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (song.isConvertToStringOnce) {
                      song.songInfo.forEach((element) {
                        song.stringSongs.add(element.title);
                      });
                      print(song.stringSongs);
                      song.isConvertToStringOnce = false;
                    }
                    showSearch(context: context, delegate: Search());
                  },
                );
              })
            ],
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(background: Consumer<SongQueryProvider>(
              builder: (context, song, child) {
                // TODO: FIX ALBUM ART FROM PLAYLIST
                return song.songInfoFromPlaylist.isNotEmpty
                    ? song.songInfoFromPlaylist[0].albumArtwork != null
                        ? Image.file(
                            File(song.songInfoFromPlaylist[0].albumArtwork),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/imgs/defalbum.png",
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
            children: [_headerWidget(), _librarySongWidget()],
          )),
    ));
  }
}
