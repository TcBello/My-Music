import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/mini_player/components/animated_pause_play.dart';
import 'package:my_music/ui/mini_player/components/song_title.dart';
import 'package:my_music/ui/now_playing/now_playing.dart';
import 'package:my_music/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class DriveModeUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Material(
      child: Consumer2<SongQueryProvider, SongPlayerProvider>(
        builder: (context, songQuery, songPlayer, child) {
          return StreamBuilder<MediaItem?>(
            stream: songPlayer.audioItemStream,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                final songTitle = snapshot.data!.title;
                final artistName = snapshot.data!.artist!;
                final durationValue = snapshot.data!.duration!;
                final albumImage = ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(File(snapshot.data!.artUri!.path), fit: BoxFit.cover,),
                );
                final maxImageSize = _size.width * 0.8;
    
                return AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOutQuart,
                  color: songQuery.currentPalette != null
                    ? miniplayerBackgroundColor(songQuery.currentPalette!.dominantColor!.color)
                    : color2,
                  width: _size.width,
                  height: _size.height,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: _size.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                }
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
                                  Icons.queue_music_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => NowPlaying())),
                              )
                            ],
                          ),
                          SizedBox(height: _size.height * 0.015,),
                          SizedBox(
                            height: maxImageSize,
                            width: maxImageSize,
                            child: albumImage,
                          ),
                          Expanded(
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
                                          style: ThemeProvider.themeOf(context).data.textTheme.subtitle1?.copyWith(
                                            color: Colors.grey[300],
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
                                      final positionValue = snapshot.data!;
                
                                      return ProgressBar(
                                        progress: positionValue,
                                        total: durationValue,
                                        onSeek: (duration){
                                          songPlayer.seek(duration);
                                        },
                                        progressBarColor: miniplayerBodyColor(songQuery.currentPalette!.colors.last, songQuery.currentPalette!.dominantColor!.color),
                                        thumbColor: miniplayerBodyColor(songQuery.currentPalette!.colors.last, songQuery.currentPalette!.dominantColor!.color),
                                        baseBarColor: Colors.grey[200],
                                        timeLabelPadding: 15.0,
                                        timeLabelTextStyle: ThemeProvider.themeOf(context).data.textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.w500
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
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
                                      AnimatedPausePlay(
                                        color: songQuery.currentPalette != null
                                          ? miniplayerBodyColor(songQuery.currentPalette!.colors.last, songQuery.currentPalette!.dominantColor!.color)
                                          : Colors.pinkAccent
                                      ),
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
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: _size.height * 0.125,
                        right: _size.width * 0.05,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: color3
                          ),
                          child: Icon(Icons.drive_eta, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                );
              }
    
              return Container();
            }
          );
        }
      ),
    );
  }
}
