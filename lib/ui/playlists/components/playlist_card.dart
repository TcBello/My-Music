import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/components/image_gridview.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({this.playlistName, this.songNumber, this.playlistInfo, this.index});

  final String playlistName;
  final int songNumber;
  final PlaylistInfo playlistInfo;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageGridAsset("defalbum.png"),
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        child: Text(playlistName),
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                          "$songNumber songs")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6, top: 7),
                    child: InkWell(
                      onTap: () {
                        showPlaylistBottomSheet(context, playlistInfo, index);
                      },
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.grey[800],
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}