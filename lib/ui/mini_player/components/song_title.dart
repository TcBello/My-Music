import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:my_music/components/style.dart';

class SongTitleMiniPlayer extends StatelessWidget {
  const SongTitleMiniPlayer({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: MarqueeText(
        alwaysScroll: false,
        text: title,
        style: rubberTextStyle,
        speed: 20,
      ),
    );
  }
}

class SongTitle extends StatelessWidget {
  const SongTitle({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.8,
      child: MarqueeText(
        text: title,
        style: rubberTextStyle,
        speed: 20,
      ),
    );
  }
}