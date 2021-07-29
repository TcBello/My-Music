import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:theme_provider/theme_provider.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({this.albumName, this.artistName, this.imageGrid});

  final String albumName;
  final String artistName;
  final imageGrid;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: ThemeProvider.themeOf(context).data.cardTheme.shape,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageGrid,
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.05,
              // color: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    albumName,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  Text(
                    artistName,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeProvider.themeOf(context).data.textTheme.caption
                  )
                ],
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Padding(
          //       // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //       padding: const EdgeInsets.symmetric(horizontal: 10),
          //       child: Container(
          //         padding: EdgeInsets.only(right: 5.0),
          //         child: Text(
          //           albumName,
          //           overflow: TextOverflow.ellipsis,
          //           style: cardTitleTextStyle,
          //         ),
          //         width: MediaQuery.of(context).size.width,
          //         height: 20
          //       )),
          // ),
          // Padding(
          //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //     child: Text(
          //       artistName,
          //       overflow: TextOverflow.ellipsis,
          //       style: cardSubtitleTextStyle,
          //     )),
        ],
      ),
    );
  }
}
