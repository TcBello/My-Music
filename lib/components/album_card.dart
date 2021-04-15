import 'package:flutter/material.dart';

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
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  albumName,
                  overflow: TextOverflow.ellipsis,
                ),
                width: MediaQuery.of(context).size.width,
                height: 20,
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                artistName,
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }
}
