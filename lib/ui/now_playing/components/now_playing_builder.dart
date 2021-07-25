import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/model/audio_queue_state.dart';
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

  Future<bool> delayDisplay() async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void init() async{
    final songPlayer = context.read<SongPlayerProvider>();
    final songQuery = context.read<SongQueryProvider>();
    // scrollController = ScrollController();

    var currentIndex = await songPlayer.getCurrentIndex();
    var queueLength = songPlayer.getQueueLength();
    
    final tileHeight = (72 * currentIndex).toDouble();
    final tileMaxHeight = (72 * (currentIndex - 7)).toDouble();
    if(currentIndex == 0){
      // scrollController.jumpTo(scrollController.position.minScrollExtent);
      Future.delayed(Duration(milliseconds: 50), (){
        // scrollController.jumpTo(scrollController.position.minScrollExtent);
        scrollController = ScrollController(initialScrollOffset: tileHeight);
      });
      print("JUMP MIN SCROLL");
    }
    else if(currentIndex >= (queueLength - 7)){
      // scrollController.jumpTo(scrollController.position.maxScrollExtent);
      Future.delayed(Duration(milliseconds: 50), (){
        // scrollController.jumpTo(scrollController.position.maxScrollExtent);
        scrollController = ScrollController(initialScrollOffset: tileMaxHeight);
      });
      print("JUMP MAX SCROLL");
    }
    else{
      // scrollController.jumpTo(tileHeight);
      Future.delayed(Duration(milliseconds: 50), (){
        // scrollController.jumpTo(tileHeight);
        scrollController = ScrollController(initialScrollOffset: tileHeight);
      });
      print("JUMP CUSTOM SCROLL");
    }
  }

  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);
    print("TITLE: ${AudioService.currentMediaItem.title} - QUEUE ID: ${AudioService.currentMediaItem.extras['queueId']}");

    return StreamBuilder<AudioQueueData>(
      stream: songPlayerProvider.nowPlayingStream(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final queue = snapshot.data.queue;
          final currentIndex = snapshot.data.index;

          // return Consumer<SongQueryProvider>(
          //   builder: (context, songQuery, child) {
          //     return ReorderableListView.builder(
          //       scrollController: scrollController,
          //       buildDefaultDragHandles: false,
          //       onReorder: (oldIndex, newIndex) => songQuery.reorderSong(
          //         oldIndex,
          //         newIndex,
          //       ),
          //       itemCount: queue.length,
          //       itemBuilder: (context, index){
          //         final songArtwork = queue[index].artUri.path;

          //         return NowPlayingSongTile(
          //           key: ValueKey("$index - ${queue[index].title}"),
          //           index: index,
          //           // songInfo: songQuery.currentQueue[index],
          //           onTap: () {
          //             songPlayerProvider.playQueueSong(index, queue);
          //           },
          //           isPlaying: index == currentIndex,
          //           image: Image.file(File(songArtwork), fit: BoxFit.cover,),
          //           songTitle: queue[index].title,
          //           artistName: queue[index].artist,
          //           path: queue[index].id,
          //           mediaItem: queue[index],
          //         );

          //         // return ListTile(
          //         //   key: ValueKey("$index - ${queue[index].title}"),
          //         //   title: Text(queue[index].title, style: TextStyle(color: Colors.white),),
          //         // );
          //       }
          //     );
          //   }
          // );

          return FutureBuilder<bool>(
            future: delayDisplay(),
            builder: (context, snapshot) {
              print("Yey");
              if(snapshot.hasData){
                return Consumer<SongQueryProvider>(
                builder: (context, songQuery, child) {
                  return ReorderableListView.builder(
                    scrollController: scrollController,
                    buildDefaultDragHandles: false,
                    onReorder: (oldIndex, newIndex) => songQuery.reorderSong(
                      oldIndex,
                      newIndex,
                    ),
                    itemCount: queue.length,
                    itemBuilder: (context, index){
                      final songArtwork = queue[index].artUri.path;
          
                      return NowPlayingSongTile(
                        key: ValueKey("$index - ${queue[index].title}"),
                        index: index,
                        // songInfo: songQuery.currentQueue[index],
                        onTap: () {
                          songPlayerProvider.playQueueSong(index, queue);
                        },
                        isPlaying: index == currentIndex,
                        image: Image.file(File(songArtwork), fit: BoxFit.cover,),
                        songTitle: queue[index].title,
                        artistName: queue[index].artist,
                        path: queue[index].id,
                        mediaItem: queue[index],
                      );
          
                      // return ListTile(
                      //   key: ValueKey("$index - ${queue[index].title}"),
                      //   title: Text(queue[index].title, style: TextStyle(color: Colors.white),),
                      // );
                    }
                  );
                }
              );
              }

              return Center(
                child: CircularProgressIndicator(color: Colors.white,)
              );
            }
          );
        }

        return Container();
      }
    );
  }
}
