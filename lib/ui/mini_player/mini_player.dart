import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/mini_player/components/collapsed_miniplayer.dart';
import 'package:my_music/ui/mini_player/components/expanded_miniplayer.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/utils/utils.dart';
import 'package:my_music/components/controller.dart';
import 'package:provider/provider.dart';

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
                songPlayer.stopSong();
                songPlayer.dismissMiniPlayer();
              },
              curve: Curves.easeOut,
              builder: (height, percentage) {
                final bool miniplayer = percentage < miniplayerPercentageDeclaration;
                final double width = MediaQuery.of(context).size.width;
                final maxImgSize = width * 0.8;

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

                  return ExpandedMiniplayer(
                    backgroundColor: backgroundColor,
                    opacityPercentageExpandedPlayer: opacityPercentageExpandedPlayer,
                    paddingLeft: paddingLeft,
                    paddingVertical: paddingVertical,
                    imageSize: imageSize,
                    onPressed: (){
                      collapseMiniPlayer();
                      songPlayer.setPlayerExpandBool(false);
                    },
                    songTitle: songTitle,
                    artistName: artistName,
                    duration: duration,
                    durationValue: durationValue,
                    expandedAlbumImage: expandedAlbumImage
                  );
                }

                /////////////MINI PLAYER
                final percentageMiniplayer = percentage >= 0.16
                    ? 0.0
                    : percentageFromValueInRange(
                      min: playerMaxHeight * 0.16 + playerMinHeight,
                      max: playerMinHeight,
                      value: height
                    );

                final elementOpacity = percentageMiniplayer;

                
                return CollapsedMiniplayer(
                  backgroundColor: backgroundColor,
                  playerMinHeight: playerMinHeight,
                  height: height,
                  maxImgSize: maxImgSize,
                  elementOpacity: elementOpacity,
                  onPressed: (){
                    expandMiniPlayer();
                    songPlayer.setPlayerExpandBool(true);
                  },
                  songTitle: songTitle,
                  artistName: artistName,
                  collapsedAlbumImage: collapsedAlbumImage
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