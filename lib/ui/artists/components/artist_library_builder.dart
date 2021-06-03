import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/album_card.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/library_song/library_song.dart';
import 'package:provider/provider.dart';

class ArtistLibraryBuilder extends StatelessWidget {
  const ArtistLibraryBuilder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child){
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: List.generate(notifier.albumFromArtist.length, (index){
              // final imageGrid = notifier.albumFromArtist[index].albumArt != null
              //   ? ImageGridFile(notifier.albumFromArtist[index].albumArt)
              //   : ImageGridAsset("defalbum.png");

              final artistName = notifier.albumFromArtist[index].artist != "<unknown>"
                ? notifier.albumFromArtist[index].artist
                : "Unknown Artist";
              
              final albumName = notifier.albumFromArtist[index].title;

              final hasArtWork = File(notifier.artWork(notifier.albumFromArtist[index].id)).existsSync();

              final albumImage = hasArtWork
                  ? ImageGridFile(notifier.artWork(notifier.albumFromArtist[index].id))
                  : ImageGridAsset("defalbum.png");
                
              return InkWell(
                onTap: () async{
                  await notifier.getSongFromArtist(notifier.albumFromArtist[index].artist, notifier.albumFromArtist[index].id);
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySong(
                    notifier.albumFromArtist[index],
                    notifier.songInfoFromArtist
                  )));
                },
                child: AlbumCard(
                  albumName: albumName,
                  artistName: artistName,
                  imageGrid: albumImage,
                ),
              );
            }),
          ),
        );
//      return FlatButton(
//        onPressed: (){print(song.albumFromArtist); print(song.albumFromArtist.length);},
//        child: Text("GET VALUES"),
//      );
      },
    );
  }
}
