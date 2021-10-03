import 'package:flutter/material.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/components/constant.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:theme_provider/theme_provider.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({
    required this.albumInfo,
    required this.imageGrid
  });

  final AlbumModel albumInfo;
  final imageGrid;

  @override
  Widget build(BuildContext context) {
    final artistName = albumInfo.artist! != kDefaultArtistName
      ? albumInfo.artist!
      : "Unknown Artist";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageGrid,
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
                        child: Container(
                          child: Text(albumInfo.album, style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                        )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
                        child: Text(
                          artistName,
                          style: ThemeProvider.themeOf(context).data.textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                          showAlbumBottomSheet(context, albumInfo);
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

class ArtistProfileAlbumCard extends StatelessWidget {
  const ArtistProfileAlbumCard({
    required this.albumInfo,
    required this.imageGrid
  });

  final AlbumModel albumInfo;
  final imageGrid;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageGrid,
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
                        child: Container(
                          child: Text(albumInfo.album, style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                        )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
                        child: Text(
                          "${albumInfo.numOfSongs} Song",
                          style: ThemeProvider.themeOf(context).data.textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                          showAlbumBottomSheet(context, albumInfo);
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