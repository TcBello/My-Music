import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_music/components/album_card.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/provider/song_query.dart';
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
              final albumArt = notifier.albumArtwork(notifier.albumFromArtist![index].id);
              final hasArtWork = File(notifier.albumArtwork(notifier.albumFromArtist![index].id)).existsSync();
              final albumImage = hasArtWork
                ? ImageGridFile(
                  img: albumArt,
                  heroID: "album${notifier.albumFromArtist![index].id}"
                )
                : ImageGridFile(
                  img: notifier.defaultAlbum,
                  heroID: "album${notifier.albumFromArtist![index].id}"
                );
                
              return InkWell(
                onTap: () async{
                  await notifier.getSongFromAlbum(notifier.albumFromArtist![index].id);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LibrarySong(
                    albumInfo: notifier.albumFromArtist![index],
                    songInfoList: notifier.songInfoFromAlbum!
                  )));
                },
                child: ArtistProfileAlbumCard(
                  imageGrid: albumImage,
                  albumInfo: notifier.albumFromArtist![index],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
