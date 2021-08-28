import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/model/audio_queue_data.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class NowPlayingBuilder extends StatefulWidget {
  @override
  _NowPlayingBuilderState createState() => _NowPlayingBuilderState();
}

class _NowPlayingBuilderState extends State<NowPlayingBuilder> {

  ScrollController? scrollController;

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
    scrollController?.dispose();
    super.dispose();
  }

  void init() async{
    final songPlayer = context.read<SongPlayerProvider>();

    var currentIndex = await songPlayer.getCurrentIndex();
    var queueLength = songPlayer.getQueueLength();
    
    final tileHeight = (72 * currentIndex).toDouble();
    final tileMaxHeight = (72 * (currentIndex - 7)).toDouble();
    if(currentIndex == 0){
      Future.delayed(Duration(milliseconds: 50), (){
        scrollController = ScrollController(initialScrollOffset: tileHeight);
      });
      print("JUMP MIN SCROLL");
    }
    else if(currentIndex >= (queueLength - 7)){
      Future.delayed(Duration(milliseconds: 50), (){
        scrollController = ScrollController(initialScrollOffset: tileMaxHeight);
      });
      print("JUMP MAX SCROLL");
    }
    else{
      Future.delayed(Duration(milliseconds: 50), (){
        scrollController = ScrollController(initialScrollOffset: tileHeight);
      });
      print("JUMP CUSTOM SCROLL");
    }
  }

  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);

    return StreamBuilder<AudioQueueData>(
      stream: songPlayerProvider.nowPlayingStream(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final queue = snapshot.data!.queue ?? [];
          final currentIndex = snapshot.data!.index;

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
                      final songArtwork = queue[index].artUri!.path;
          
                      return NowPlayingSongTile(
                        key: ValueKey("$index - ${queue[index].title}"),
                        index: index,
                        onTap: () {
                          songPlayerProvider.playQueueSong(index, queue);
                        },
                        isPlaying: index == currentIndex,
                        image: Image.file(File(songArtwork), fit: BoxFit.cover,),
                        songTitle: queue[index].title,
                        artistName: queue[index].artist!,
                        path: queue[index].id,
                        mediaItem: queue[index],
                      );
                    }
                  );
                }
              );
              }

              return Center(
                child: CircularProgressIndicator(
                  color: color3,
                )
              );
            }
          );
        }

        return Container();
      }
    );
  }
}
