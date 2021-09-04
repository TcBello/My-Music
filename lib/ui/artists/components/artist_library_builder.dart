import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/artists/components/artist_card.dart';
import 'package:my_music/ui/library_song/library_song.dart';
import 'package:provider/provider.dart';

class ArtistLibraryBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child){
        return Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: List.generate(notifier.albumFromArtist!.length, (index){
              final albumName = notifier.albumFromArtist?[index].album;
              // final albumArtwork = notifier.albumFromArtist?[index].albumArt;
              final albumArtwork2 = notifier.albumArtwork(notifier.albumFromArtist![index].id);
              final hasArtWork = File(notifier.albumArtwork(notifier.albumFromArtist![index].id)).existsSync();
              // final albumImage = isSdk28Below
              //   ? albumArtwork != null
              //     ? ImageGridFile(
              //       img: albumArtwork,
              //       heroID: notifier.albumFromArtist![index].id
              //     )
              //     : ImageGridFile(
              //       img: notifier.defaultAlbum,
              //       heroID: notifier.albumFromArtist![index].id
              //     )
              //   : hasArtWork
              //     ? ImageGridFile(
              //       img: albumArtwork2,
              //       heroID: notifier.albumFromArtist![index].id
              //     )
              //     : ImageGridFile(
              //       img: notifier.defaultAlbum,
              //       heroID: notifier.albumFromArtist![index].id
              //     );
              final albumImage = hasArtWork
                ? ImageGridFile(
                  img: albumArtwork2,
                  heroID: notifier.albumFromArtist![index].id.toString()
                )
                : ImageGridFile(
                  img: notifier.defaultAlbum,
                  heroID: notifier.albumFromArtist![index].id.toString()
                );
                
              return InkWell(
                onTap: () async{
                  await notifier.getSongFromAlbum(notifier.albumFromArtist![index].id);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LibrarySong(
                    albumInfo: notifier.albumFromArtist![index],
                    songInfoList: notifier.songInfoFromAlbum!
                  )));
                },
                child: ArtistCard(
                  artistName: albumName!,
                  imageGrid: albumImage,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
