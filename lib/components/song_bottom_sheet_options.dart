import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:my_music/components/playlist_dialog.dart';
import 'package:my_music/main.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class SongBottomSheetOptions extends StatelessWidget {
  const SongBottomSheetOptions({Key key, this.songInfo}) : super(key: key);

  final SongInfo songInfo;

  void showPlaylistDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => PlaylistDialog(songInfo: songInfo,),
    );
  }

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songTitle = songInfo.title;

    return Container(
      height: 260,
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
                    text: songTitle,
                    style: ThemeProvider.themeOf(context).data.textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    ),
                    speed: 20,
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 1.0, color: Colors.grey)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Play Next", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black
            )),
            onTap: () {
              songQueryProvider.playNextSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            onTap: () {
              songQueryProvider.addToQueueSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to playlist", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () {
              Navigator.pop(context);
              showPlaylistDialog(context);
            },
          )
        ],
      ),
    );
  }
}

class QueueBottomSheetOptions extends StatelessWidget {
  const QueueBottomSheetOptions({
    @required this.songInfo,
    @required this.mediaItem,
    @required this.index
  });

  final SongInfo songInfo;
  final MediaItem mediaItem;
  final int index;

  void showPlaylistDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => PlaylistDialog(songInfo: songInfo,),
    );
  }

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songTitle = songInfo.title;

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
                    text: songTitle,
                    style: ThemeProvider.themeOf(context).data.textTheme.headline6.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                    speed: 20,
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 1.0, color: Colors.grey)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Play Next", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () {
              songQueryProvider.playNextSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            onTap: () {
              songQueryProvider.addToQueueSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to playlist", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () {
              Navigator.pop(context);
              showPlaylistDialog(context);
            },
          ),
          ListTile(
            title: Text("Remove from queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            onTap: () {
              songQueryProvider.removeQueueSong(mediaItem, index);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
