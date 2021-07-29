import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/mini_player/components/animated_pause_play.dart';
import 'package:my_music/ui/mini_player/components/slider_bar.dart';
import 'package:my_music/ui/mini_player/components/song_title.dart';
import 'package:my_music/ui/now_playing/now_playing.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/utils/utils.dart';
import 'package:my_music/components/controller.dart';
import 'package:provider/provider.dart';
import 'package:equalizer/equalizer.dart';
import 'package:theme_provider/theme_provider.dart';

class MiniPlayer extends StatelessWidget {
  final double playerMinHeight = 70.0;

  final double miniplayerPercentageDeclaration = 0.25;

  ValueNotifier<double> get playerExpandProgress =>
      ValueNotifier(playerMinHeight);

  final Color backgroundColor = color2;

  void expandMiniPlayer(){
    miniPlayerController.animateToHeight(state: PanelState.MAX);
    
  }

  void collapseMiniPlayer(){
    miniPlayerController.animateToHeight(state: PanelState.MIN);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final playerMaxHeight = size.height;

    return Consumer2<SongQueryProvider, SongPlayerProvider>(builder: (context, songQuery, songPlayer, child) {
      // final albumImage = Image.file(File(songPlayer.audioItem.artUri.path));
      // final artistName = songPlayer.audioItem.artist != '<unknown>'
      //     ? songPlayer.audioItem.artist
      //     : "Unknown Artist";
      //notifier.repeatIcons[notifier.currentRepeatMode];

      return StreamBuilder<MediaItem>(
        stream: songPlayer.audioItemStream,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            print(snapshot.data.title);

            final collapsedAlbumImage = ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(File(snapshot.data.artUri.path), fit: BoxFit.cover)
            );

            final expandedAlbumImage = ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.file(File(snapshot.data.artUri.path), fit: BoxFit.cover,),
            );

            final songTitle = snapshot.data.title;
            final artistName = snapshot.data.artist;
            final duration = toMinSecFormat(snapshot.data.duration);
            final durationValue = snapshot.data.duration;

            return Miniplayer(
              valueNotifier: playerExpandProgress,
              minHeight: playerMinHeight,
              maxHeight: playerMaxHeight,
              controller: miniPlayerController,
              elevation: 4,
              onDismissed: () async{
                // await notifier.stopPlayer();
                songPlayer.stopSong();
                songPlayer.dismissMiniPlayer();
              },
              curve: Curves.easeOut,
              builder: (height, percentage) {
                final bool miniplayer = percentage < miniplayerPercentageDeclaration;
                final double width = MediaQuery.of(context).size.width;
                final maxImgSize = width * 0.8;
                // final text = Text(audioObject.title);
                // const buttonPlay = IconButton(
                //   icon: Icon(Icons.pause),
                //   onPressed: onTap,
                // );
                final progressIndicator = LinearProgressIndicator(value: 0.3);
                // print(height);
                //Declare additional widgets (eg. SkipButton) and variables
                if (!miniplayer) {
                  var percentageExpandedPlayer = percentageFromValueInRange(
                      min: playerMaxHeight * miniplayerPercentageDeclaration +
                          playerMinHeight,
                      max: playerMaxHeight,
                      value: height);
                  var opacityPercentageExpandedPlayer = percentage > 0.75
                      ? percentageFromValueInRange(
                          min: playerMaxHeight - (playerMaxHeight * 0.25),
                          max: playerMaxHeight,
                          value: height)
                      : 0.0;

                  if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;
                  final paddingVertical = valueFromPercentageInRange(
                      min: 0, max: size.height * 0.3, percentage: percentageExpandedPlayer);
                  final double heightWithoutPadding = height - paddingVertical * 2;
                  final double imageSize = heightWithoutPadding > maxImgSize
                      ? maxImgSize
                      : heightWithoutPadding;
                  final paddingLeft = valueFromPercentageInRange(
                        min: 0,
                        max: width - imageSize,
                        percentage: percentageExpandedPlayer,
                      ) /
                      2;

                  // const buttonSkipForward = IconButton(
                  //   icon: Icon(Icons.forward_30),
                  //   iconSize: 33,
                  //   onPressed: onTap,
                  // );
                  // const buttonSkipBackwards = IconButton(
                  //   icon: Icon(Icons.replay_10),
                  //   iconSize: 33,
                  //   onPressed: onTap,
                  // );
                  // const buttonPlayExpanded = IconButton(
                  //   icon: Icon(Icons.pause_circle_filled),
                  //   iconSize: 50,
                  //   onPressed: onTap,
                  // );

                  return Container(
                    color: backgroundColor,
                    width: size.width,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
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
                                    onPressed: (){
                                      collapseMiniPlayer();
                                      songPlayer.setPlayerExpandBool(false);
                                    }
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 70,
                                      child: Center(
                                        child: Text("Now Playing", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle)
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
                                  // PopupMenu(_songModel.index)
                                ],
                              ),
                            ),
                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child: Padding(
                            //     padding: EdgeInsets.only(
                            //         left: paddingLeft,
                            //         top: paddingVertical,
                            //         bottom: paddingVertical / 2),
                            //     child: SizedBox(
                            //       height: imageSize,
                            //       child: img,
                            //     ),
                            //   ),
                            // ),
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
                            // padding: const EdgeInsets.symmetric(horizontal: 33),
                            Expanded(
                              child: Opacity(
                                opacity: opacityPercentageExpandedPlayer,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // text,
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     buttonSkipBackwards,
                                    //     buttonPlayExpanded,
                                    //     buttonSkipForward
                                    //   ],
                                    // ),
                                    // progressIndicator,
                                    // Container(),
                                    // Container(),

                                    Container(
                                      height: 60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SongTitle(title: songTitle,),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.0, right: 20.0),
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
                                          final position =  toMinSecFormat(snapshot.data);
                                          final positionValue = snapshot.data;

                                          return Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width,
                                                      child: SliderBar(
                                                        position: positionValue,
                                                        duration: durationValue,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.fromLTRB(
                                                                    20, 0, 0, 0),
                                                            child: Text(
                                                              // _songModel.currentPosition,
                                                              position,
                                                              style: ThemeProvider.themeOf(context).data.textTheme.bodyText1.copyWith(
                                                                fontWeight: FontWeight.w500
                                                              )
                                                            )),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.fromLTRB(
                                                                    0, 0, 20, 0),
                                                            child: Text(
                                                              // _songModel.songDuration,
                                                              duration,
                                                              style: ThemeProvider.themeOf(context).data.textTheme.bodyText1.copyWith(
                                                                fontWeight: FontWeight.w500
                                                              ),
                                                            ))
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
                                              // notifier.onSkipPrev();
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
                                              // notifier.onSkipNext();
                                              songPlayer.skipNext();
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                            icon: songPlayer.currentShuffleIcon,
                                            onPressed: () => songPlayer.setShuffleMode()
                                          )
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
                            padding: EdgeInsets.only(
                              left: paddingLeft,
                              // top: paddingVertical * 0.1,
                              bottom: paddingVertical
                            ),
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

                /////////////MINI PLAYER
                // final percentageMiniplayer = percentageFromValueInRange(
                //     min: playerMinHeight,
                //     max: playerMaxHeight * miniplayerPercentageDeclaration +
                //         playerMinHeight,
                //     value: height);
                final percentageMiniplayer = percentage >= 0.16
                    ? 0.0
                    : percentageFromValueInRange(
                        // min: playerMinHeight,
                        // max: playerMaxHeight * 0.15 + (playerMinHeight),
                        min: playerMaxHeight * 0.16 + playerMinHeight,
                        max: playerMinHeight,
                        value: height);

                final elementOpacity = percentageMiniplayer;
                final progressIndicatorHeight = 4 - 4 * percentageMiniplayer;

                return Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // ConstrainedBox(
                            //   constraints: BoxConstraints(
                            //     maxHeight: maxImgSize,
                            //   ),
                            //   child: albumImage,
                            // ),
                            SizedBox(
                              height: playerMinHeight + height,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.cover,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: maxImgSize,
                                    minWidth: playerMinHeight,
                                    minHeight: playerMinHeight
                                  ),
                                  height: playerMinHeight,
                                  width: playerMinHeight,
                                  child: collapsedAlbumImage,
                                ),
                              ),
                            ),
                            Expanded(
                              //asdasdadadadasddas
                              child: Opacity(
                                opacity: elementOpacity,
                                child: InkWell(
                                  onTap: (){
                                    expandMiniPlayer();
                                    songPlayer.setPlayerExpandBool(true);
                                  },
                                  child: SongTitleMiniPlayer(title: songTitle, artist: artistName,),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: elementOpacity,
                              child: Container(
                                height: 50,
                                width: 50,
                                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: ClipOval(
                                  child: StreamBuilder<PlaybackState>(
                                    stream: songPlayer.playbackStateStream,
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                        return FlatButton(
                                          onPressed: () {
                                            // notifier.onPauseResume();
                                            songPlayer.pauseResume();
                                          },
                                          child: songPlayer.playPauseMiniPlayerIcon(snapshot.data.playing),
                                        );
                                      }

                                      return FlatButton(
                                        onPressed: () {
                                          // notifier.onPauseResume();
                                          songPlayer.pauseResume();
                                        },
                                        child: songPlayer.playPauseMiniPlayerIcon(true),
                                      );
                                    }
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return Container();
        }
      );
    });
  }
}