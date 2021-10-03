import 'package:flutter/material.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/components/constant.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:theme_provider/theme_provider.dart';

class ArtistCard extends StatelessWidget {
  const ArtistCard({
    required this.artistInfo,
    required this.imageGrid
  });

  final ArtistModel artistInfo;
  final imageGrid;

  @override
  Widget build(BuildContext context) {
    final artistName = artistInfo.artist != kDefaultArtistName
      ? artistInfo.artist
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
                          child: Text(artistName, style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
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
                          "${artistInfo.numberOfAlbums} Album • ${artistInfo.numberOfTracks} Song",
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
                          showArtistBottomSheet(context, artistInfo);
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