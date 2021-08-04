import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        return Container(
          width: size.width,
          child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
              children: List.generate(notifier.artistInfo.length, (index){
                final artistName = notifier.artistInfo[index].name;     
                final artistArtwork = notifier.artistInfo[index].artistArtPath;
                final artistArtwork2 = notifier.artistArtwork(notifier.artistInfo[index].id);
                final isSdk28Below = notifier.androidDeviceInfo.version.sdkInt < 29;
                final hasArtWork = File(notifier.artistArtwork(notifier.artistInfo[index].id)).existsSync();
                final backgroundSliver = isSdk28Below
                  ? artistArtwork
                  : hasArtWork
                    ? artistArtwork2
                    : notifier.defaultAlbum;
                final albumImage = isSdk28Below
                  ? artistArtwork != null
                    ? ImageGridFile(
                      img: artistArtwork,
                      heroID: "artist$index"
                    )
                    : ImageGridFile(
                      img: notifier.defaultAlbum,
                      heroID: "artist$index"
                    )
                  : hasArtWork
                    ? ImageGridFile(
                      img: artistArtwork2,
                      heroID: "artist$index"
                    )
                    : ImageGridFile(
                      img: notifier.defaultAlbum,
                      heroID: "artist$index"
                    );

                return InkWell(
                  onTap: () async{
                    await notifier.getAlbumFromArtist(artistName);
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => ArtistProfile(
                      title: artistName,
                      index: index,
                      backgroundSliver: backgroundSliver,
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
