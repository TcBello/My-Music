import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/ui/mini_player/components/animated_pause_play.dart';
import 'package:my_music/ui/mini_player/components/slider_bar.dart';
import 'package:my_music/ui/mini_player/components/song_title.dart';
import 'package:my_music/ui/now_playing/now_playing.dart';
import 'package:my_music/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ExpandedMiniplayer extends StatelessWidget {
  const ExpandedMiniplayer({
    @required this.backgroundColor,
    @required this.opacityPercentageExpandedPlayer,
    @required this.paddingLeft,
    @required this.paddingVertical,
    @required this.imageSize,
    @required this.onPressed,
    @required this.songTitle,
    @required this.artistName,
    @required this.duration,
    @required this.durationValue,
    @required this.expandedAlbumImage
  });

  final Color backgroundColor;
  final double opacityPercentageExpandedPlayer;
  final double paddingLeft;
  final double paddingVertical;
  final double imageSize;
  final Function onPressed;
  final String songTitle;
  final String artistName;
  final String duration;
  final Duration durationValue;
  final Widget expandedAlbumImage;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final songPlayer = Provider.of<SongPlayerProvider>(context);

    return Container(
      color: backgroundColor,
      width: _size.width,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: _size.height * 0.03,
              ),
              Opacity(
                opacity: opacityPercentageExpandedPlayer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: onPressed
                    ),
                    Expanded(
                      child: Container(
                        height: 70,
                        child: Center(
                          child: Text(
                            "Now Playing",
                            style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle
                          )
                        )
                      )
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.equalizer,
                        color: Colors.white,
                      ),
                      onPressed: () => songPlayer.openEqualizer(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.queue_music_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => NowPlaying())),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(
                    left: paddingLeft,
                    top: paddingVertical * 0.05,
                  ),
                  child: SizedBox(height: imageSize),
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: opacityPercentageExpandedPlayer,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SongTitle(
                              title: songTitle,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Text(
                                artistName,
                                style: ThemeProvider.themeOf(context).data.textTheme.subtitle1.copyWith(
                                  color: color5,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      StreamBuilder<Duration>(
                        initialData: Duration.zero,
                        stream: songPlayer.positionStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final position = toMinSecFormat(snapshot.data);
                            final positionValue = snapshot.data;

                            return Column(
                              children: [
                                Container(
                                  height: 70,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: _size.width,
                                        child: SliderBar(
                                          position: positionValue,
                                          duration: durationValue,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                            child: Text(
                                              position,
                                              style: ThemeProvider.themeOf(context).data.textTheme.bodyText1.copyWith(
                                                fontWeight: FontWeight.w500
                                              )
                                            )
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                            child: Text(
                                              duration,
                                              style: ThemeProvider.themeOf(context).data.textTheme.bodyText1.copyWith(
                                                fontWeight:
                                                FontWeight.w500
                                              ),
                                            )
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: songPlayer.currentRepeatIcon,
                              onPressed: () {
                                songPlayer.setRepeatMode();
                              },
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                songPlayer.skipPrevious();
                              },
                            ),
                            SizedBox(width: 10),
                            AnimatedPausePlay(),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                songPlayer.skipNext();
                              },
                            ),
                            SizedBox(width: 10),
                            IconButton(
                                icon: songPlayer.currentShuffleIcon,
                                onPressed: () => songPlayer.setShuffleMode())
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: paddingLeft, bottom: paddingVertical),
              child: SizedBox(
                height: imageSize,
                width: imageSize,
                child: expandedAlbumImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}