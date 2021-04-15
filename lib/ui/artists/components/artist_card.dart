import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  const ArtistCard({this.imageGrid, this.artistName});

  final imageGrid;
  final String artistName;

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
            padding: const EdgeInsets.all(10.0),
            child: Text(
              artistName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
