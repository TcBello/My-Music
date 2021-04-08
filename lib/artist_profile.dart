import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/image_gridview.dart';
import 'package:my_music/library_song_artist.dart';
import 'package:my_music/library_song_album.dart';
import 'package:my_music/search.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/style.dart';
import 'package:provider/provider.dart';

class ArtistProfile extends StatelessWidget {
  final String title;
  final int index;
  final String backgroundSliver;
  ArtistProfile({this.title, this.index, this.backgroundSliver});

  Widget _albumFromArtistWidget(){
    return Consumer<SongModel>(
      builder: (context, song, child){
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: List.generate(song.albumFromArtist.length, (index) => InkWell(
              onTap: () async{
                await song.getSongFromArtist(song.albumFromArtist[index].artist, song.albumFromArtist[index].id);
                // Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySongList(indexFromOutside: index, isFromArtist: true, isFromPlaylist: false,)));
                Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySongArtist(index)));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    song.albumFromArtist[index].albumArt != null ? ImageGridFile(song.albumFromArtist[index].albumArt)
                        : ImageGridAsset("defalbum.png"),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Container(child: Text(song.albumFromArtist[index].title), width: MediaQuery.of(context).size.width, height: 20,)
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                            song.albumFromArtist[index].artist != "<unknown>" ? song.albumFromArtist[index].artist
                                : "Unknown Artist"
                        )
                    ),
                  ],
                ),
              ),
            )),
          ),
        );
//      return FlatButton(
//        onPressed: (){print(song.albumFromArtist); print(song.albumFromArtist.length);},
//        child: Text("GET VALUES"),
//      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScreenScrolled){
          return <Widget>[
            SliverAppBar(
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: (){showSearch(context: context, delegate: Search());},
                )
              ],
              expandedHeight: 165,
              flexibleSpace: FlexibleSpaceBar(
                  background: backgroundSliver != null ? Image.file(File(backgroundSliver), fit: BoxFit.cover,) : Image.asset('assets/imgs/defalbum.png', fit: BoxFit.cover,)
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Center(
                  child: Text(
                    title != "<unknown>" ? title
                        : "UnknownArtist",
                    style: headerLibrarySongListTextStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text("In my library", style: headerLibrarySongListTextStyle,),
              ),
              _albumFromArtistWidget()
            ],
          ),
        ),
      ),
    );
  }
}
