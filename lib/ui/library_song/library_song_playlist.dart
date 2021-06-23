import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/library_song/components/playlist_song_tile.dart';
import 'package:provider/provider.dart';

class LibrarySongPlaylist extends StatelessWidget {
  final int indexFromOutside;
  LibrarySongPlaylist(this.indexFromOutside);

  // Widget _librarySongWidget() {
  //   return Consumer2<SongQueryProvider, SongPlayerProvider>(
  //     builder: (context, songQuery, songPlayer, child) {
  //       final sdkInt = songQuery.androidDeviceInfo.version.sdkInt;

  //       return ListBody(
  //         children: List.generate(
  //             songQuery.songInfoFromPlaylist.length, (index) => PlaylistSongTile(
  //               songInfo: songQuery.songInfoFromPlaylist[index],
  //               onTap: (){
  //                 songQuery.setQueue(songQuery.songInfoFromPlaylist);
  //                 songPlayer.playSong(songQuery.songInfoFromPlaylist, index, sdkInt);
  //               },
  //               index: indexFromOutside,
  //             )
          
  //         // children: List.generate(
  //         //     songQuery.songInfoFromPlaylist.length, (index) => SongTile2(
  //         //       songInfo: songQuery.songInfoFromPlaylist[index],
  //         //       onTap: (){
  //         //         songQuery.setQueue(songQuery.songInfoFromPlaylist);
  //         //         songPlayer.playSong(songQuery.songInfoFromPlaylist, index);
  //         //       },
  //         //       // index: indexFromOutside,
  //         //     )
  //         ), 
  //       );
  //     },
  //   );
  // }

  // Widget _headerWidget() {
  //   return Consumer<SongQueryProvider>(builder: (context, song, child) {
  //     return Container(
  //       height: 50,
  //       width: MediaQuery.of(context).size.width,
  //       child: Center(
  //         child: AutoSizeText(
  //           song.playlistInfo[indexFromOutside].name,
  //           maxLines: 2,
  //           style: headerLibrarySongListTextStyle,
  //         ),
  //       ),
  //     );
  //   });
  // }

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
              builder: (context, songQuery, child) {
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: ConstrainedBox(
                    child: Text(songQuery.playlistInfo[indexFromOutside].name, style: headerLibrarySongTextStyle2, ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  ),
                  background: Container(
                    color: color1,
                    child: Hero(
                      tag: "playlist$indexFromOutside",
                      child: Image.asset(
                        "assets/imgs/defalbum.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                //   background: Consumer<SongQueryProvider>(
                //   builder: (context, song, child) {
                //     // TODO: FIX ALBUM ART FROM PLAYLIST
                //     // return song.songInfoFromPlaylist.isNotEmpty
                //     //     ? song.songInfoFromPlaylist[0].albumArtwork != null
                //     //         ? Image.file(
                //     //             File(song.songInfoFromPlaylist[0].albumArtwork),
                //     //             fit: BoxFit.cover,
                //     //           )
                //     //         : Image.asset(
                //     //             "assets/imgs/defalbum.png",
                //     //             fit: BoxFit.cover,
                //     //           )
                //     //     : Image.asset(
                //     //         "assets/imgs/defalbum.png",
                //     //         fit: BoxFit.cover,
                //     //       );
                    
                //   },
                // )
                );
              }
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Consumer2<SongQueryProvider, SongPlayerProvider>(
            builder: (context, songQuery, songPlayer, child) {
              final sdkInt = songQuery.androidDeviceInfo.version.sdkInt;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    songQuery.songInfoFromPlaylist.length, (index) => PlaylistSongTile(
                      songInfo: songQuery.songInfoFromPlaylist[index],
                      onTap: (){
                        songQuery.setQueue(songQuery.songInfoFromPlaylist);
                        songPlayer.playSong(songQuery.songInfoFromPlaylist, index, sdkInt);
                      },
                      index: indexFromOutside,
                    )
                
                // children: List.generate(
                //     songQuery.songInfoFromPlaylist.length, (index) => SongTile2(
                //       songInfo: songQuery.songInfoFromPlaylist[index],
                //       onTap: (){
                //         songQuery.setQueue(songQuery.songInfoFromPlaylist);
                //         songPlayer.playSong(songQuery.songInfoFromPlaylist, index);
                //       },
                //       // index: indexFromOutside,
                //     )
                ),
              );
            },
          )
      ),
    ));
  }
}
