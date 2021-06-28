import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class SearchSongUI extends StatelessWidget {
  const SearchSongUI({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: color1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedTextKit(
            animatedTexts: [WavyAnimatedText("Searching Songs...", textStyle: searchTextStyle)],
            repeatForever: true,
          ),
          Container(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  child: Consumer<SongQueryProvider>(
                    builder: (context, songQuery, child) {
                      return Text(songQuery.locationSongSearch, style: searchSongTextStyle,);
                    }
                  ),
                ),
              ],
            ),
          ),
          Consumer<SongQueryProvider>(
            builder: (context, songQuery, child) {
              return SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width * 0.8,
                child: LinearProgressIndicator(
                value: songQuery.searchProgress,
                valueColor: AlwaysStoppedAnimation(color3),
                backgroundColor: color5,
                ),
              );
            }
          )
        ],
      ),
    );
  }
}