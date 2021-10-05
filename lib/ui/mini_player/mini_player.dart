import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/mini_player/components/collapsed_miniplayer.dart';
import 'package:my_music/ui/mini_player/components/expanded_miniplayer.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/utils/utils.dart';
import 'package:my_music/components/controller.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  final double miniplayerPercentageDeclaration = 0.25;

  ValueNotifier<double> get playerExpandProgress =>
      ValueNotifier(kMiniplayerMinHeight);

  final Color backgroundColor = color2;

  void expandMiniPlayer(){
    miniPlayerController?.animateToHeight(state: PanelState.MAX);
    
  }

  void collapseMiniPlayer(){
    miniPlayerController?.animateToHeight(state: PanelState.MIN);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final playerMaxHeight = size.height;

    return Consumer2<SongQueryProvider, SongPlayerProvider>(builder: (context, songQuery, songPlayer, child) {
      return StreamBuilder<MediaItem?>(
        stream: songPlayer.audioItemStream,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            print(snapshot.data?.title);
            songQuery.addPaletteData();

            final collapsedAlbumImage = RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(File(snapshot.data!.artUri!.path), fit: BoxFit.cover)
              ),
            );

            final expandedAlbumImage = RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(File(snapshot.data!.artUri!.path), fit: BoxFit.cover,),
              ),
            );

            final songTitle = snapshot.data!.title;
            final artistName = snapshot.data!.artist! != kDefaultArtistName
              ? snapshot.data!.artist!
              : "Unknown Artist";
            final duration = toMinSecFormat(snapshot.data!.duration!);
            final durationValue = snapshot.data!.duration!;

            return Miniplayer(
              valueNotifier: playerExpandProgress,
              minHeight: kMiniplayerMinHeight,
              maxHeight: playerMaxHeight,
              controller: miniPlayerController,
              backgroundColor: Colors.transparent,
              onDismissed: (){
                songPlayer.stopSong();
                songPlayer.dismissMiniPlayer();
              },
              curve: Curves.easeOutQuart,
              duration: Duration(milliseconds: 500),
              builder: (height, percentage) {
                final bool miniplayer = percentage < miniplayerPercentageDeclaration;
                final double width = MediaQuery.of(context).size.width;
                final maxImgSize = width * 0.8;
            
                //Declare additional widgets (eg. SkipButton) and variables
                if (!miniplayer) {
                  var percentageExpandedPlayer = percentageFromValueInRange(
                    min: playerMaxHeight * miniplayerPercentageDeclaration +
                      kMiniplayerMinHeight,
                    max: playerMaxHeight,
                    value: height
                  );
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
                    ) / 2;
            
                  return ExpandedMiniplayer(
                    backgroundColor: songQuery.currentPalette != null
                      ? miniplayerBackgroundColor(songQuery.currentPalette!.dominantColor!.color)
                      : backgroundColor,
                    bodyColor: songQuery.currentPalette != null
                      ? miniplayerBodyColor(songQuery.currentPalette!.colors.last, songQuery.currentPalette!.dominantColor!.color)
                      : Colors.pinkAccent,
                    opacityPercentageExpandedPlayer: opacityPercentageExpandedPlayer,
                    paddingLeft: paddingLeft,
                    paddingVertical: paddingVertical,
                    imageSize: imageSize,
                    onPressed: (){
                      collapseMiniPlayer();
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
                    min: playerMaxHeight * 0.16 + kMiniplayerMinHeight,
                    max: kMiniplayerMinHeight,
                    value: height
                  );
            
                  final elementOpacity = percentageMiniplayer;
                           
                  return CollapsedMiniplayer(
                    backgroundColor: songQuery.currentPalette != null && height > kMiniplayerMinHeight
                      ? miniplayerBackgroundColor(songQuery.currentPalette!.dominantColor!.color)
                      : backgroundColor,
                    playerMinHeight: kMiniplayerMinHeight,
                    height: height,
                    maxImgSize: maxImgSize,
                    elementOpacity: elementOpacity,
                    onPressed: (){
                      expandMiniPlayer();
                    },
                    songTitle: songTitle,
                    artistName: artistName,
                    collapsedAlbumImage: collapsedAlbumImage,
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