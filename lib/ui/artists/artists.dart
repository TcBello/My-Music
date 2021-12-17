import 'dart:io';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/data_placeholder.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/artists/artist_profile.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/ui/artists/components/artist_card.dart';
import 'package:provider/provider.dart';

class Artists extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child){
        return notifier.artistInfo.length > 0
          ? Container(
            width: size.width,
            child: RepaintBoundary(
              child: DraggableScrollbar.semicircle(
                backgroundColor: color3,
                controller: artistScrollController!,
                child: GridView.count(
                  controller: artistScrollController,
                    crossAxisCount: 2,
                    padding: const EdgeInsets.only(top: 15),
                    children: List.generate(notifier.artistInfo.length, (index){
                      final artistName = notifier.artistInfo[index].artist;     
                      final artistArt = notifier.artistArtwork(notifier.artistInfo[index].id);                  
                      final hasArtWork = File(notifier.artistArtwork(notifier.artistInfo[index].id)).existsSync();
                      final backgroundSliver = hasArtWork
                        ? artistArt
                        : notifier.defaultAlbum;
                      final albumImage = hasArtWork
                        ? ImageGridFile(
                          img: artistArt,
                          heroID: "artist$index"
                        )
                        : ImageGridFile(
                          img: notifier.defaultAlbum,
                          heroID: "artist$index"
                        );
                        
                      return InkWell(
                        onTap: () async{
                          await notifier.getAlbumFromArtist(artistName);
                          await notifier.getSongFromArtist(notifier.artistInfo[index].id);
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => ArtistProfile(
                            title: artistName,
                            index: index,
                            backgroundSliver: backgroundSliver,
                          )));
                        },
                        child: ArtistCard(
                          imageGrid: albumImage,
                          artistInfo: notifier.artistInfo[index],
                        ),
                      );
                    }
                  )
                ),
              ),
            ),
          )
          : DataPlaceholder(
            text: "Artist is empty",
          );
      },
    );
  }
}
