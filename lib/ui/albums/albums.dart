import 'dart:io';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/data_placeholder.dart';
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
            child: RepaintBoundary(
              child: DraggableScrollbar.semicircle(
                controller: albumScrollController!,
                backgroundColor: color3,
                child: GridView.count(
                  controller: albumScrollController,
                    crossAxisCount: 2,
                    padding: const EdgeInsets.only(top: 15),
                    children: List.generate(notifier.albumInfo.length, (index){
                      final id = notifier.albumInfo[index].id;
                      final hasArtWork = File(notifier.albumArtwork(notifier.albumInfo[index].id)).existsSync();
                      final albumImage = hasArtWork
                        ? ImageGridFile(
                          img: notifier.albumArtwork(id),
                          heroID: "album$id"
                        )
                        : ImageGridFile(
                          img: notifier.defaultAlbum,
                          heroID: "album$id"
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
                          albumInfo: notifier.albumInfo[index],
                          imageGrid: albumImage,
                        ),
                      );
                    }
                  )
                ),
              ),
            ),
          )
          : DataPlaceholder(
            text: "Album is empty",
          );
      },
    );
  }
}