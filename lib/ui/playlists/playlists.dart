import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/library_song/library_song_playlist.dart';
import 'package:my_music/ui/playlists/components/playlist_card.dart';
import 'package:provider/provider.dart';

class Playlists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child){
        return notifier.playlistInfo.length > 0
          ? Container(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LibrarySongPlaylist(indexFromOutside: index,)));
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
          )
          : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(
                color: color3,
              ),
            ),
          );
      },
    );
  }
}

