import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
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

    return Container(
        color: Colors.white,
        // child: ListView.builder(
        //   itemCount: songQueryProvider.currentQueue.length,
        //   itemBuilder: (context, index) => NowPlayingSongTile(
        //     songInfo: songQueryProvider.currentQueue[index],
        //     onTap: () {
        //       // provider.setIndex(index);
        //       // provider.playSong(provider.nowPlayingSongs);
        //       songPlayerProvider.playSong(songQueryProvider.currentQueue, index);
        //     },
        //   ),
        // )
        child: StreamBuilder<MediaItem>(
          stream: songPlayerProvider.audioItemStream,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              var currentTitle = snapshot.data.title;

              return ListView.builder(
                itemCount: songQueryProvider.currentQueue.length,
                itemBuilder: (context, index) => NowPlayingSongTile(
                  songInfo: songQueryProvider.currentQueue[index],
                  onTap: () {
                    // provider.setIndex(index);
                    // provider.playSong(provider.nowPlayingSongs);
                    songPlayerProvider.playSong(songQueryProvider.currentQueue, index);
                  },
                  isPlaying: songQueryProvider.currentQueue[index].title == currentTitle,
                ),
              );
            }

            return Container();
          }
        )
    );
  }
}
