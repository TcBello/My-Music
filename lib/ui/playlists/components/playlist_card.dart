import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({this.playlistName, this.songNumber, this.playlistInfo, this.index});

  final String playlistName;
  final int songNumber;
  final PlaylistInfo playlistInfo;
  final int index;

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageGridFile(songQueryProvider.defaultAlbum, "playlist$index"),
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        child: Text(playlistName, style: cardTitleTextStyle,),
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text("$songNumber songs", style: cardSubtitleTextStyle,)
                  ),
                ],
              ),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.centerRight,
                  width: 20,
                  height: 20,
                  child: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: (){
                      showPlaylistBottomSheet(context, playlistInfo, index);
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
