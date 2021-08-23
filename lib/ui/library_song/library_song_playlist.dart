import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class LibrarySongPlaylist extends StatelessWidget {
  final int indexFromOutside;
  
  const LibrarySongPlaylist({
    @required this.indexFromOutside
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
              builder: (context, songQuery, child) {
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: ConstrainedBox(
                    child: AutoSizeText(
                      songQuery.playlistInfo[indexFromOutside].name,
                      style: ThemeProvider.themeOf(context).data.textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                      maxHeight: 35
                    ),
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
                        songPlayer.playSong(songQuery.songInfoFromPlaylist, index, sdkInt);
                      },
                      index: indexFromOutside,
                    )
                ),
              );
            },
          )
      ),
    ));
  }
}
