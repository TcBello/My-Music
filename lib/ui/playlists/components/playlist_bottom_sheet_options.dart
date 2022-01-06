import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:my_music/components/delete_dialog.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/utils/utils.dart';
import 'package:on_audio_room/details/rooms/playlists/playlist_entity.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class PlaylistBottomSheetOptions extends StatelessWidget {
  const PlaylistBottomSheetOptions({
    required this.playlistInfo,
    required this.index
  });

  final PlaylistEntity playlistInfo;
  final int index;

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songPlayerProvider  = Provider.of<SongPlayerProvider>(context);
    final playlistName = playlistInfo.playlistName;

    return Container(
      height: 290,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RepaintBoundary(
                    child: MarqueeText(
                      text: TextSpan(text: playlistName),
                      style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                      speed: 20,
                    ),
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
            title: Text("Play Playlist", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            onTap: () async {
              if(playlistInfo.playlistSongs.length != 0){
                songPlayerProvider.playPlaylistSong(playlistInfo.playlistSongs, 0);
              }
              else{
                showShortToast("Playlist is empty");
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Play Next", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () async {
              if(playlistInfo.playlistSongs.length != 0){
                songQueryProvider.playNextPlaylist(playlistInfo.playlistSongs);
              }
              else{
                showShortToast("Playlist is empty");
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () async{
              if(playlistInfo.playlistSongs.length != 0){
                songQueryProvider.addToQueuePlaylist(playlistInfo.playlistSongs);
              }
              else{
                showShortToast("Playlist is empty");
              }
              Navigator.pop(context);
            },
          ),
          Consumer<SongQueryProvider>(
            builder: (context, notifier, child) {
              final playlistName = notifier.playlistInfo?[index].playlistName;

              return ListTile(
                title: Text("Delete Playlist", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),),
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DeleteDialog(
                        title: "Delete $playlistName",
                        content: "Are you sure you want to delete this playlist?",
                        onPressedDelete: () async {
                          await notifier.deletePlaylist(playlistInfo.key);
                          await notifier.getPlaylists();
                          Navigator.pop(context);
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
