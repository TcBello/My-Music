import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:theme_provider/theme_provider.dart';

class SongTitleMiniPlayer extends StatelessWidget {
  const SongTitleMiniPlayer({
    required this.title,
    required this.artist
  });

  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10.0, right: 7.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RepaintBoundary(
            child: MarqueeText(
              alwaysScroll: false,
              text: TextSpan(text: title),
              style: ThemeProvider.themeOf(context).data.textTheme.bodyText1?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
              speed: 20,
            ),
          ),
          Text(
            artist,
            style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
              color: Colors.white
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class SongTitle extends StatelessWidget {
  const SongTitle({
    required this.title
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.8,
        child: MarqueeText(
          text: TextSpan(text: title),
          style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
            fontSize: 22
          ),
          speed: 20,
        ),
      ),
    );
  }
}