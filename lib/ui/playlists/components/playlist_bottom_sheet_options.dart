import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:my_music/components/delete_dialog.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class PlaylistBottomSheetOptions extends StatelessWidget {
  const PlaylistBottomSheetOptions({this.playlistInfo, this.index});

  final PlaylistInfo playlistInfo;
  final int index;

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songPlayerProvider  = Provider.of<SongPlayerProvider>(context);
    final playlistName = playlistInfo.name;

    return Container(
      height: 305,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MarqueeText(
                    text: playlistName,
                    style: headerBottomSheetTextStyle,
                    speed: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1.0,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Play Playlist", style: bottomSheetTextStyle,),
            onTap: () async {
              await songQueryProvider.getSongFromPlaylist(index);
              // provider.setIndex(0);
              // await provider
              //     .playSong(provider.songInfoFromPlaylist)
              //     .whenComplete(() => Navigator.pop(context));
              songQueryProvider.setQueue(songQueryProvider.songInfoFromPlaylist);
              songPlayerProvider.playSong(songQueryProvider.songInfoFromPlaylist, 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Play Next", style: bottomSheetTextStyle,),
            onTap: () async {
              songQueryProvider.getSongFromPlaylist(index).whenComplete(() {
                songQueryProvider.playNextPlaylist(songQueryProvider.songInfoFromPlaylist);
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            title: Text("Add to Queue", style: bottomSheetTextStyle,),
            onTap: () {
              songQueryProvider.getSongFromPlaylist(index).whenComplete(() {
                songQueryProvider.addToQueuePlaylist(songQueryProvider.songInfoFromPlaylist);
                Navigator.pop(context);
              });
            },
          ),
          Consumer<SongQueryProvider>(
            builder: (context, notifier, child) {
              final playlistName = notifier.playlistInfo[index].name;

              return ListTile(
                title: Text("Delete Playlist", style: bottomSheetTextStyle,),
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DeleteDialog(
                        index: index,
                        title: "Delete $playlistName",
                        content: "Are you sure you want to delete this playlist?",
                        onPressedDelete: () async {
                          await notifier.deletePlaylist(index);
                          await notifier.getSongs().then((value) {
                            Navigator.pop(context);
                          });
                        },
                      );
                    },
                  );
                },
              );
          }),
        ],
      ),
    );
  }
}
