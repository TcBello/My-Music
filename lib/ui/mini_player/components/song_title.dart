import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:my_music/components/style.dart';

class SongTitleMiniPlayer extends StatelessWidget {
  const SongTitleMiniPlayer({this.title, this.artist});

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
          MarqueeText(
            alwaysScroll: false,
            text: title,
            style: songTitleMiniplayerTextStyle,
            speed: 20,
          ),
          Text(
            artist,
            style: artistMiniplayerTextStyle,
            overflow: TextOverflow.ellipsis,
          )
        ],
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
        style: songTitleMiniplayerTextStyle2,
        speed: 20,
      ),
    );
  }
}