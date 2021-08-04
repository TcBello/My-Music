import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ArtistCard extends StatelessWidget {
  const ArtistCard({
    @required this.imageGrid,
    @required this.artistName
  });

  final imageGrid;
  final String artistName;

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
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                artistName,
                overflow: TextOverflow.ellipsis,
                style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}