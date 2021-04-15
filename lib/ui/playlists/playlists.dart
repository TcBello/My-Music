import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/ui/library_song/library_song_playlist.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/playlists/components/playlist_card.dart';
import 'package:provider/provider.dart';

import '../library_song/library_song.dart';

class Playlists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongModel>(
      builder: (context, notifier, child){
        return Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 60),
              children: List.generate(notifier.playlistInfo.length, (index){
                final playlistName = notifier.playlistInfo[index].name;
                final songNumber = notifier.playlistInfo[index].memberIds.length;

                return InkWell(
                  onTap: () async{
                    await notifier.getSongFromPlaylist(index);
                    // Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySongList(indexFromOutside: index, isFromArtist: false, isFromPlaylist: true,)));
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySongPlaylist(index)));
                  },
                  child: PlaylistCard(
                    playlistName: playlistName,
                    songNumber: songNumber,
                    playlistInfo: notifier.playlistInfo[index],
                    index: index,
                  ),
                );
              }
            )
          ),
        );
      },
    );
  }
}

