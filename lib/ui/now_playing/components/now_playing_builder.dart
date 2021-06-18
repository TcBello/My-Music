import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class NowPlayingBuilder extends StatefulWidget {
  const NowPlayingBuilder({
    Key key,
  }) : super(key: key);

  @override
  _NowPlayingBuilderState createState() => _NowPlayingBuilderState();
}

class _NowPlayingBuilderState extends State<NowPlayingBuilder> {
  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final isSdk28Below = songQueryProvider.androidDeviceInfo.version.sdkInt < 29;

    return Container(
        child: StreamBuilder<MediaItem>(
          stream: songPlayerProvider.audioItemStream,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final currentTitle = snapshot.data.title;

              return ListView.builder(
                itemCount: songQueryProvider.currentQueue.length,
                itemBuilder: (context, index){
                  final songArtwork = songQueryProvider.currentQueue[index].albumArtwork;
                  final hasArtWork = File(songQueryProvider.artWork(songQueryProvider.currentQueue[index].albumId)).existsSync();

                  return NowPlayingSongTile(
                    songInfo: songQueryProvider.currentQueue[index],
                    onTap: () {
                      songPlayerProvider.playSong(songQueryProvider.currentQueue, index);
                    },
                    isPlaying: songQueryProvider.currentQueue[index].title == currentTitle,
                    image: isSdk28Below
                      ? songArtwork != null
                        ? Image.file(File(songArtwork), fit: BoxFit.cover,)
                        : Image.file(File(songQueryProvider.defaultAlbum))
                      : hasArtWork
                        ? Image.file(File(songQueryProvider.artWork(songQueryProvider.currentQueue[index].albumId)), fit: BoxFit.cover,)
                        : Image.file(File(songQueryProvider.defaultAlbum)),
                  );
                }
              );
            }

            return Container();
          }
        )
    );
  }
}
