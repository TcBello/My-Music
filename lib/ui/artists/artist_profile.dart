import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/singleton/music_player_service.dart';
import 'package:my_music/ui/artists/components/artist_library_builder.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/artists/components/artist_song_builder.dart';
import 'package:my_music/ui/search_bar/search_bar.dart';
import 'package:my_music/utils/utils.dart';
import 'package:theme_provider/theme_provider.dart';

class ArtistProfile extends StatelessWidget {
  final String title;
  final int index;
  final String backgroundSliver;
  
  ArtistProfile({
    required this.title,
    required this.index,
    required this.backgroundSliver
  });

  final _musicPlayerService = MusicPlayerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: NestedScrollView(
        headerSliverBuilder: (context, isScreenScrolled){
          return <Widget>[
            SliverAppBar(
              backgroundColor: color2,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBar()));
                  },
                )
              ],
              expandedHeight: 165,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: "artist$index",
                  child: Image.file(File(backgroundSliver), fit: BoxFit.cover,),
                ),
              ),
            ),
          ];
        },
        body: StreamBuilder<bool>(
          initialData: false,
          stream: _musicPlayerService.audioBackgroundRunningStream,
          builder: (context, snapshot) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: snapshot.data!
                ? const EdgeInsets.only(bottom: kMiniplayerMinHeight)
                : EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myAdBanner(context, "unitId"),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: Center(
                        child: Text(
                          title,
                          style: ThemeProvider.themeOf(context).data.textTheme.headline6
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Text("Albums", style: ThemeProvider.themeOf(context).data.textTheme.headline6,),
                    ),
                    ArtistLibraryBuilder(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                      child: Text("All songs", style: ThemeProvider.themeOf(context).data.textTheme.headline6,),
                    ),
                    ArtistSongBuilder()
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}