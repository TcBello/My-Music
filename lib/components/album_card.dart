import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({
    required this.albumName,
    required this.artistName,
    required this.imageGrid
  });

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    albumName,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
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
        ],
      ),
    );
  }
}
