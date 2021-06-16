import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/artists/artist_profile.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/ui/artists/components/artist_card.dart';
import 'package:provider/provider.dart';

class Artists extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child){
        return Container(
          width: size.width,
          child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
              children: List.generate(notifier.artistInfo.length, (index){
                final artistName = notifier.artistInfo[index].name;       
                final albumImage = notifier.artistInfo[index].artistArtPath != null
                  ? ImageGridFile(
                    notifier.artistInfo[index].artistArtPath, "artist$index"
                  )
                  : ImageGridAsset("defalbum.png", "artist$index");

                return InkWell(
                  onTap: () async{
                    await notifier.getAlbumFromArtist(artistName);
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => ArtistProfile(
                      title: artistName,
                      index: index,
                      backgroundSliver: notifier.artistInfo[index].artistArtPath,
                    )));
                  },
                  child: ArtistCard(
                    imageGrid: albumImage,
                    artistName: artistName,
                  ),
                );
              }
            )
          ),
        );
      },
    );
  }
}
