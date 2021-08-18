import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class SearchSongUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final songQuery = Provider.of<SongQueryProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: color1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Selector<SongQueryProvider, String>(
            selector: (context, songQuery) => songQuery.searchHeader,
            builder: (context, searchHeader, child) {
              return AnimatedTextKit(
                pause: Duration(milliseconds: 300),
                animatedTexts: [
                  WavyAnimatedText(
                    searchHeader,
                    textStyle: ThemeProvider.themeOf(context).data.textTheme.headline6,
                    speed: Duration(milliseconds: 150)
                  )
                ],
                repeatForever: true,
              );
            }
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
                      return Text(songQuery.locationSongSearch, style: ThemeProvider.themeOf(context).data.textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),);
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