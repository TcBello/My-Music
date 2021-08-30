import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/library_song/library_song.dart';
import 'package:my_music/components/album_card.dart';
import 'package:provider/provider.dart';

class Albums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child){
        return notifier.albumInfo.length > 0
          ? Container(
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
                children: List.generate(notifier.albumInfo.length, (index){
                  final albumName = notifier.albumInfo[index].album;
                  final artistName = notifier.albumInfo[index].artist!;
                  final id = notifier.albumInfo[index].id;
                  final hasArtWork = File(notifier.albumArtwork(notifier.albumInfo[index].id)).existsSync();
                  final isSdk28Below = notifier.androidDeviceInfo!.version.sdkInt < 29;
                  // final albumImage = isSdk28Below
                  //   ? albumArtwork != null
                  //     ? ImageGridFile(
                  //       img: albumArtwork,
                  //       heroID: notifier.albumInfo[index].id
                  //     )
                  //     : ImageGridFile(
                  //       img: notifier.defaultAlbum,
                  //       heroID: notifier.albumInfo[index].id
                  //     )
                  //   : hasArtWork
                  //     ? ImageGridFile(
                  //       img: notifier.albumArtwork(id),
                  //       heroID: id.toString()
                  //     )
                  //     : ImageGridFile(
                  //       img: notifier.defaultAlbum,
                  //       heroID: id.toString()
                  //     );
                  final albumImage = hasArtWork
                    ? ImageGridFile(
                      img: notifier.albumArtwork(id),
                      heroID: id.toString()
                    )
                    : ImageGridFile(
                      img: notifier.defaultAlbum,
                      heroID: id.toString()
                    );

                  return InkWell(
                    onTap: () async{
                      await notifier.getSongFromAlbum(id);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LibrarySong(
                        albumInfo: notifier.albumInfo[index],
                        songInfoList: notifier.songInfoFromAlbum!
                      )));
                    },
                    child: AlbumCard(
                      albumName: albumName,
                      artistName: artistName,
                      imageGrid: albumImage,
                    ),
                  );
                }
              )
            ),
          )
          : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(
                color: color3,
              ),
            ),
          );
      },
    );
  }
}