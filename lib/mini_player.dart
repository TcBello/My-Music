import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:my_music/now_playing.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/style.dart';
import 'package:my_music/utils.dart';
import 'package:my_music/components/controller.dart';
import 'package:provider/provider.dart';
import 'package:equalizer/equalizer.dart';

class MiniPlayer extends StatelessWidget {
  // final AudioObject audioObject;

  // const MiniPlayer({Key key, @required this.audioObject}) : super(key: key);
  final double playerMinHeight = 70.0;
  final double miniplayerPercentageDeclaration = 0.25;
  ValueNotifier<double> get playerExpandProgress =>
      ValueNotifier(playerMinHeight);
  final Color backgroundColor = Colors.black;

  String toMinSecFormat(Duration duration) {
    if (duration.inMinutes < 60) {
      String minutes = (duration.inSeconds / 60).truncate().toString();
      String seconds =
          (duration.inSeconds % 60).truncate().toString().padLeft(2, '0');

      return "$minutes:$seconds";
    } else {
      String hours = (duration.inMinutes / 60).truncate().toString();
      String minutes =
          (duration.inMinutes % 60).truncate().toString().padLeft(2, '0');
      String seconds =
          (duration.inSeconds % 60).truncate().toString().padLeft(2, '0');

      return "$hours:$minutes:$seconds";
    }
  }

  String toMinSecFormatWhileDragging(double dragPosition, Duration duration) {
    if ((Duration(milliseconds: dragPosition.toInt()).inMinutes) < 60) {
      if (duration.inSeconds.toDouble() > dragPosition) {
        double newDouble = duration.inSeconds.toDouble() - dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String minutes = (newDuration.inSeconds / 60).truncate().toString();
        String seconds =
            (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$minutes:$seconds";
      } else {
        double newDouble = duration.inSeconds.toDouble() + dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String minutes = (newDuration.inSeconds / 60).truncate().toString();
        String seconds =
            (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$minutes:$seconds";
      }
    } else {
      if (duration.inSeconds.toDouble() > dragPosition) {
        double newDouble = duration.inSeconds.toDouble() - dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String hours = (newDuration.inMinutes / 60).truncate().toString();
        String minutes =
            (newDuration.inMinutes % 60).truncate().toString().padLeft(2, '0');
        String seconds =
            (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$hours:$minutes:$seconds";
      } else {
        double newDouble = duration.inSeconds.toDouble() + dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String hours = (newDuration.inMinutes / 60).truncate().toString();
        String minutes =
            (newDuration.inMinutes % 60).truncate().toString().padLeft(2, '0');
        String seconds =
            (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$hours:$minutes:$seconds";
      }
    }
  }

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

    return Consumer<SongModel>(builder: (context, notifier, child) {
      final albumImage = notifier.audioItem.albumArtwork != null
          ? Image.file(File(notifier.audioItem.albumArtwork))
          : Image.asset("assets/imgs/defalbum.png");
      final artistName = notifier.audioItem.artist != '<unknown>'
          ? notifier.audioItem.artist
          : "Unknown Artist";
      final songTitle = notifier.audioItem.title;
      final repeatIcon = notifier.repeatIcons[notifier.currentRepeatMode];

      return Miniplayer(
        valueNotifier: playerExpandProgress,
        minHeight: playerMinHeight,
        maxHeight: playerMaxHeight,
        controller: miniPlayerController,
        elevation: 4,
        onDismissed: () {
          notifier.dismissMiniPlayer();
          notifier.stopPlayer();
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
                min: 0, max: 150, percentage: percentageExpandedPlayer);
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
                        height: 30,
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
                                color: Colors.pinkAccent,
                                size: 30,
                              ),
                              onPressed: (){
                                collapseMiniPlayer();
                                notifier.setPlayerExpandBool(false);
                              }
                            ),
                            Expanded(
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: Text("Now Playing", style: rubberTextStyle,)
                                )
                              )
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.equalizer,
                                color: Colors.pinkAccent,
                              ),
                              onPressed: () => Equalizer.open(0),
                            ),
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
                            top: paddingVertical * 0.2,
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
                                height: 50,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Text(
                                        songTitle,
                                        style: rubberTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Text(
                                        artistName,
                                        style: defTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              StreamBuilder<PlaybackDisposition>(
                                initialData: PlaybackDisposition.zero(),
                                stream: notifier.audioPlayer.onProgress
                                    .asBroadcastStream(
                                        onListen: notifier.onStreamDuration(),
                                        onCancel:
                                            notifier.onStreamDurationCancel()),
                                builder: (context, snapshot) {
                                  // String position = snapshot.data.position
                                  //     .toString()
                                  //     .split('.')
                                  //     .first;
                                  // String duration = snapshot.data.duration
                                  //     .toString()
                                  //     .split('.')
                                  //     .first;
                                  String position = notifier.isDrag
                                      ? toMinSecFormatWhileDragging(
                                          notifier.dragSliderValue,
                                          snapshot.data.position)
                                      : toMinSecFormat(snapshot.data.position);

                                  String duration =
                                      toMinSecFormat(snapshot.data.duration);

                                  double durationMin = snapshot
                                      .data.position.inMilliseconds
                                      .toDouble();
                                  double durationMax = snapshot
                                      .data.duration.inMilliseconds
                                      .toDouble();

                                  if (snapshot.hasData) {
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
                                                child: Slider(
                                                  activeColor:
                                                      Colors.pinkAccent,
                                                  inactiveColor:
                                                      Colors.pink[100],
                                                  value: notifier.isDrag
                                                      ? notifier.dragSliderValue
                                                      : durationMin,
                                                  min: 0.0,
                                                  max: durationMax,
                                                  onChanged:
                                                      (double duration) async {
                                                    if (notifier.isDrag) {
                                                      notifier
                                                          .setDragSliderValue(
                                                              duration);
                                                    }
                                                  },
                                                  onChangeStart: (value) {
                                                    notifier.setDragBool(true);
                                                  },
                                                  onChangeEnd: (double
                                                      finalDuration) async {
                                                    notifier.setDragBool(false);

                                                    if (!notifier.isDrag) {
                                                      await notifier.seekPlayer(
                                                          finalDuration);
                                                    }
                                                  },
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
                                                        style: defTextStyle,
                                                      )),
                                                  Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 20, 0),
                                                      child: Text(
                                                        // _songModel.songDuration,
                                                        duration,
                                                        style: defTextStyle,
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
                                      icon: repeatIcon,
                                      onPressed: () {
                                        notifier.changeRepeatMode();
                                        Fluttertoast.showToast(
                                            msg: notifier.repeatModeMessage,
                                            gravity: ToastGravity.BOTTOM,
                                            toastLength: Toast.LENGTH_SHORT);
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
                                        notifier.onSkipPrev();
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    ClipOval(
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.pinkAccent,
                                                    width: 6)),
                                          ),
                                          Positioned.fill(
                                            child: IconButton(
                                              icon: notifier.playPause2,
                                              onPressed: notifier.onPauseResume,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(
                                        Icons.skip_next,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        notifier.onSkipNext();
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(
                                        Icons.queue_music,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    NowPlaying()));
                                      },
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
                          bottom: paddingVertical * 1.5),
                      child: SizedBox(
                        height: imageSize,
                        width: imageSize,
                        child: albumImage,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          //Miniplayer
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
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxImgSize),
                        child: albumImage,
                      ),
                      Expanded(
                        //asdasdadadadasddas
                        child: Opacity(
                          opacity: elementOpacity,
                          child: InkWell(
                            onTap: (){
                              expandMiniPlayer();
                              notifier.setPlayerExpandBool(true);
                            },
                            child: Container(
                              height: 70,
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              //  color: Colors.yellow,
                              child: Center(
                                  child: Text(
                                songTitle,
                                style: rubberTextStyle,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
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
                            child: FlatButton(
                              onPressed: () {
                                notifier.onPauseResume();
                              },
                              child: notifier.playPause,
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 10),
                      //     child: Opacity(
                      //       opacity: elementOpacity,
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Text(audioObject.title,
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .bodyText2
                      //                   .copyWith(fontSize: 16)),
                      //           Text(
                      //             audioObject.subtitle,
                      //             style: Theme.of(context)
                      //                 .textTheme
                      //                 .bodyText2
                      //                 .copyWith(
                      //                     color: Colors.black.withOpacity(0.55)),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Opacity(
                      //   opacity: elementOpacity,
                      //   child: buttonPlay,
                      // ),
                      // Opacity(
                      //   opacity: elementOpacity,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(right: 3.0),
                      //     child: IconButton(
                      //         icon: Icon(Icons.skip_next),
                      //         onPressed: () {
                      //           controller.animateToHeight(state: PanelState.MAX);
                      //         }),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
