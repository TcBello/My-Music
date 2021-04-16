import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/delete_dialog.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:provider/provider.dart';

class PlaylistBottomSheetOptions extends StatelessWidget {
  const PlaylistBottomSheetOptions({this.playlistInfo, this.index});

  final PlaylistInfo playlistInfo;
  final int index;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongModel>(context);
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
                  AutoSizeText(
                    playlistName,
                    style: headerBottomSheetTextStyle,
                    maxLines: 1,
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
            title: Text("Play Playlist"),
            onTap: () async {
              await provider.getSongFromPlaylist(index);
              provider.setIndex(0);
              await provider
                  .playSong(provider.songInfoFromPlaylist)
                  .whenComplete(() => Navigator.pop(context));
            },
          ),
          ListTile(
            title: Text("Play Next"),
            onTap: () async {
              provider.getSongFromPlaylist(index).whenComplete(() {
                provider.playNextPlaylist(provider.songInfoFromPlaylist);
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            title: Text("Add to Queue"),
            onTap: () {
              provider.getSongFromPlaylist(index).whenComplete(() {
                provider.addToQueuePlaylist(provider.songInfoFromPlaylist);
                Navigator.pop(context);
              });
            },
          ),
          Consumer<SongModel>(
            builder: (context, notifier, child) {
              final playlistName = notifier.playlistInfo[index].name;

              return ListTile(
                title: Text("Delete Playlist"),
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
                          await notifier.getDataSong().then((value) {
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
