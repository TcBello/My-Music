import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:my_music/components/playlist_dialog.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class SongBottomSheetOptions extends StatelessWidget {
  const SongBottomSheetOptions({
    required this.songInfo
  });

  final SongModel songInfo;

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
      height: 235,
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
                      text: songTitle,
                      style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                      speed: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 1.0, color: Colors.grey)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Play Next", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black
            )),
            onTap: () {
              songQueryProvider.playNextSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            onTap: () {
              songQueryProvider.addToQueueSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Playlist", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
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
    required this.songInfo,
    required this.mediaItem,
    required this.index
  });

  final SongModel songInfo;
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
                      text: songTitle,
                      style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                      speed: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 1.0, color: Colors.grey)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Play Next", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () {
              songQueryProvider.playNextSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            onTap: () {
              songQueryProvider.addToQueueSong(songInfo);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Playlist", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () {
              Navigator.pop(context);
              showPlaylistDialog(context);
            },
          ),
          ListTile(
            title: Text("Remove from Queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
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

class ArtistBottomSheetOptions extends StatelessWidget {
  const ArtistBottomSheetOptions({
    required this.artistInfo
  });

  final ArtistModel artistInfo;

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);
    final artistName = artistInfo.artist;

    return Container(
      height: 235,
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
                      text: artistName,
                      style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                      speed: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 1.0, color: Colors.grey)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Play Artist", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black
            )),
            onTap: () async{
              await songQueryProvider.getSongFromArtist(artistInfo.id);
              songPlayerProvider.playSong(songQueryProvider.songInfoFromArtist!, 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Play Next", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            onTap: () async{
              await songQueryProvider.getSongFromArtist(artistInfo.id);
              songQueryProvider.playNextArtist(songQueryProvider.songInfoFromArtist!, artistName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () async{
              await songQueryProvider.getSongFromArtist(artistInfo.id);
              songQueryProvider.addToQueueArtistSong(songQueryProvider.songInfoFromArtist!, artistName);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

class AlbumBottomSheetOptions extends StatelessWidget {
  const AlbumBottomSheetOptions({
    required this.albumInfo
  });

  final AlbumModel albumInfo;

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);
    final albumName = albumInfo.album;

    return Container(
      height: 235,
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
                      text: albumName,
                      style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                      speed: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 1.0, color: Colors.grey)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Play Album", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black
            )),
            onTap: () async{
              await songQueryProvider.getSongFromAlbum(albumInfo.id);
              songPlayerProvider.playSong(songQueryProvider.songInfoFromAlbum!, 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Play Next", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            onTap: () async{
              await songQueryProvider.getSongFromAlbum(albumInfo.id);
              songQueryProvider.playNextAlbum(songQueryProvider.songInfoFromAlbum!, albumName);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add to Queue", style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),),
            onTap: () async{
              await songQueryProvider.getSongFromAlbum(albumInfo.id);
              songQueryProvider.addToQueueAlbumSong(songQueryProvider.songInfoFromAlbum!, albumName);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}