import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/ui/artists/components/artist_library_builder.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/artists/components/artist_song_builder.dart';
import 'package:my_music/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ArtistProfile extends StatelessWidget {
  final String title;
  final int index;
  final String backgroundSliver;
  
  const ArtistProfile({
    required this.title,
    required this.index,
    required this.backgroundSliver
  });

  @override
  Widget build(BuildContext context) {
    final songPlayer = Provider.of<SongPlayerProvider>(context);

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
                  onPressed: (){showSearch(context: context, delegate: Search());},
                )
              ],
              expandedHeight: 165,
              flexibleSpace: FlexibleSpaceBar(
                // background: backgroundSliver != null
                //   ? Hero(
                //     tag: "artist$index",
                //     child: Image.file(File(backgroundSliver), fit: BoxFit.cover,),
                //   )
                //   : Hero(
                //     tag: "artist$index",
                //     child: Image.asset('assets/imgs/defalbum.png', fit: BoxFit.cover,),
                //   )
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
          stream: songPlayer.backgroundRunningStream,
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