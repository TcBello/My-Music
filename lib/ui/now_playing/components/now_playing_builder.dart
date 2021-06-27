import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class NowPlayingBuilder extends StatefulWidget {
  @override
  _NowPlayingBuilderState createState() => _NowPlayingBuilderState();
}

class _NowPlayingBuilderState extends State<NowPlayingBuilder> {

  ScrollController scrollController;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async{
    final songPlayer = context.read<SongPlayerProvider>();
    final songQuery = context.read<SongQueryProvider>();
    scrollController = ScrollController();

    await songPlayer.initIndex();
    // final tileHeight = (MediaQuery.of(context).size.height * 0.0895) * songPlayer.initPlayerIndex;
    final tileHeight = (72 * songPlayer.initPlayerIndex).toDouble();
    if(songPlayer.initPlayerIndex == 0){
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
    else if(songPlayer.initPlayerIndex >= (songQuery.currentQueue.length - 7)){
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
    else{
      scrollController.jumpTo(tileHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);

    return StreamBuilder(
      initialData: songPlayerProvider.initPlayerIndex,
      stream: songPlayerProvider.indexStream,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data;

        return Consumer<SongQueryProvider>(
          builder: (context, songQuery, child) {
            final isSdk28Below = songQuery.androidDeviceInfo.version.sdkInt < 29;
            final sdkInt = songQuery.androidDeviceInfo.version.sdkInt;

            return ReorderableListView.builder(
              scrollController: scrollController,
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) => songQuery.reorderSong(
                oldIndex,
                newIndex,
                songQuery.currentQueue[oldIndex]
              ),
              itemCount: songQuery.currentQueue.length,
              itemBuilder: (context, index){
                final songArtwork = songQuery.currentQueue[index].albumArtwork;
                final hasArtWork = File(songQuery.artWork(songQuery.currentQueue[index].albumId)).existsSync();

                return NowPlayingSongTile(
                  key: ValueKey("$index${songQuery.currentQueue[index].id}"),
                  index: index,
                  songInfo: songQuery.currentQueue[index],
                  onTap: () {
                    songPlayerProvider.playSong(songQuery.currentQueue, index, sdkInt);
                  },
                  isPlaying: index == currentIndex,
                  image: isSdk28Below
                    ? songArtwork != null
                      ? Image.file(File(songArtwork), fit: BoxFit.cover,)
                      : Image.file(File(songQuery.defaultAlbum))
                    : hasArtWork
                      ? Image.file(File(songQuery.artWork(songQuery.currentQueue[index].albumId)), fit: BoxFit.cover,)
                      : Image.file(File(songQuery.defaultAlbum)),
                );
              }
            );
          }
        );
      }
    );
  }
}
