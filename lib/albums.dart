import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/image_gridview.dart';
import 'package:my_music/library_song_album.dart';
import 'package:my_music/song_model.dart';
import 'package:provider/provider.dart';

class Albums extends StatelessWidget {

  Widget _albumBuilderWidget(){
    return Consumer<SongModel>(
      builder: (context, song, child){
        return Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
              children: List.generate(song.albumInfo.length, (index) => InkWell(
                onTap: () async{
                  await song.getSongFromAlbum(song.albumInfo[index].id);
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySongAlbum(index)));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      song.albumInfo[index].albumArt != null ? ImageGridFile(song.albumInfo[index].albumArt)
                          : ImageGridAsset("defalbum.png"),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Container(padding: EdgeInsets.only(right: 5.0),child: Text(song.albumInfo[index].title, overflow: TextOverflow.ellipsis,), width: MediaQuery.of(context).size.width, height: 20,)
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                              song.albumInfo[index].artist != "<unknown>" ? song.albumInfo[index].artist
                                  : "Unknown Artist",
                                  overflow: TextOverflow.ellipsis,
                          )
                      ),
                    ],
                  ),
                ),
              ))
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _albumBuilderWidget();
  }
}
