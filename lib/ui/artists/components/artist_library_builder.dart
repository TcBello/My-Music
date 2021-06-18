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
        final isSdk28Below = notifier.androidDeviceInfo.version.sdkInt < 29;

        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: List.generate(notifier.albumFromArtist.length, (index){
              final artistName = notifier.albumFromArtist[index].artist;
              final albumName = notifier.albumFromArtist[index].title;
              final albumArtwork = notifier.albumFromArtist[index].albumArt;
              final hasArtWork = File(notifier.artWork(notifier.albumFromArtist[index].id)).existsSync();
              final albumImage = isSdk28Below
                ? albumArtwork != null
                  ? ImageGridFile(
                    albumArtwork,
                    notifier.albumFromArtist[index].id
                  )
                  : ImageGridFile(
                    notifier.defaultAlbum,
                    notifier.albumFromArtist[index].id
                  )
                : hasArtWork
                  ? ImageGridFile(
                    notifier.artWork(notifier.albumFromArtist[index].id),
                    notifier.albumFromArtist[index].id
                  )
                  : ImageGridAsset("defalbum.png", notifier.albumFromArtist[index].id);
                
              return InkWell(
                onTap: () async{
                  await notifier.getSongFromArtist(notifier.albumFromArtist[index].artist, notifier.albumFromArtist[index].id);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LibrarySong(
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
