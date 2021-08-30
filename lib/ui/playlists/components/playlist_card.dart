import 'package:flutter/material.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/playlists/playlist_entity.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    required this.playlistName,
    required this.songNumber,
    required this.playlistInfo,
    required this.index
  });

  final String playlistName;
  final int songNumber;
  final PlaylistEntity playlistInfo;
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
          ImageGridFile(
            img: songQueryProvider.defaultAlbum,
            heroID: "playlist$index"
          ),
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Container(
                          child: Text(playlistName, style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),),
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                        )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text("$songNumber songs", style: ThemeProvider.themeOf(context).data.textTheme.caption,)
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
