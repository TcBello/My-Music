import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({this.albumName, this.artistName, this.imageGrid});

  final String albumName;
  final String artistName;
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
                    style: cardTitleTextStyle,
                  ),
                  Text(
                    artistName,
                    overflow: TextOverflow.ellipsis,
                    style: cardSubtitleTextStyle,
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
