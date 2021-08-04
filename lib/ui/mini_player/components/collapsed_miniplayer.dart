import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/ui/mini_player/components/song_title.dart';
import 'package:provider/provider.dart';

class CollapsedMiniplayer extends StatelessWidget {
  const CollapsedMiniplayer({
    @required this.backgroundColor,
    @required this.playerMinHeight,
    @required this.height,
    @required this.maxImgSize,
    @required this.elementOpacity,
    @required this.onPressed,
    @required this.songTitle,
    @required this.artistName,
    @required this.collapsedAlbumImage
  });

  final Color backgroundColor;
  final double playerMinHeight;
  final double height;
  final double maxImgSize;
  final double elementOpacity;
  final Function onPressed;
  final String songTitle;
  final String artistName;
  final Widget collapsedAlbumImage;

  @override
  Widget build(BuildContext context) {
    final songPlayer = Provider.of<SongPlayerProvider>(context);

    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
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
                  child: Opacity(
                    opacity: elementOpacity,
                    child: InkWell(
                      onTap: onPressed,
                      child: SongTitleMiniPlayer(
                        title: songTitle,
                        artist: artistName,
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
                      child: StreamBuilder<PlaybackState>(
                          stream: songPlayer.playbackStateStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return IconButton(
                                onPressed: () {
                                  songPlayer.pauseResume();
                                },
                                icon: songPlayer.playPauseMiniPlayerIcon(
                                    snapshot.data.playing),
                              );
                            }

                            return IconButton(
                              onPressed: () {
                                songPlayer.pauseResume();
                              },
                              icon: songPlayer.playPauseMiniPlayerIcon(true),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
