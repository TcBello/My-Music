import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/ui/library_song/library_song.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/album_card.dart';
import 'package:provider/provider.dart';

class Albums extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<SongModel>(
      builder: (context, notifier, child){
        return Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
              children: List.generate(notifier.albumInfo.length, (index){
                final albumName = notifier.albumInfo[index].title;
                final artistName = notifier.albumInfo[index].artist != "<unknown>"
                  ? notifier.albumInfo[index].artist
                  : "Unknown Artist";
                  
                final albumImage = notifier.albumInfo[index].albumArt != null
                  ? ImageGridFile(notifier.albumInfo[index].albumArt)
                  : ImageGridAsset("defalbum.png");

                return InkWell(
                  onTap: () async{
                    await notifier.getSongFromAlbum(notifier.albumInfo[index].id);
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySong(
                      notifier.albumInfo[index],
                      notifier.songInfoFromAlbum
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
        );
      },
    );
  }
}