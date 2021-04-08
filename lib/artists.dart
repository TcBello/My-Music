import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/artist_profile.dart';
import 'package:my_music/image_gridview.dart';
import 'package:my_music/song_model.dart';
import 'package:provider/provider.dart';

class Artists extends StatelessWidget {

  Widget artistBuilderWidget(){
    return Consumer<SongModel>(
      builder: (context, song, child){
        return Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
              children: List.generate(song.artistInfo.length, (index) => InkWell(
                onTap: () async{
                  await song.getAlbumFromArtist(song.artistInfo[index].name);
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ArtistProfile(title: song.artistInfo[index].name, index: index, backgroundSliver: song.artistInfo[index].artistArtPath,)));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      song.artistInfo[index].artistArtPath != null ? ImageGridFile(song.artistInfo[index].artistArtPath)
                          : ImageGridAsset("defalbum.png"),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            song.artistInfo[index].name != "<unknown>" ? song.artistInfo[index].name
                                : "Unknown Artist",
                                overflow: TextOverflow.ellipsis,
                        ),
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
    return artistBuilderWidget();
  }
}
