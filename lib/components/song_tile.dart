import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class SongTile extends StatefulWidget {
  const SongTile({
    required this.songInfo,
    required this.onTap
  });

  final SongInfo songInfo;
  final Function() onTap;

  @override
  _SongTileState createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemeProvider>(context);
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songTitle = widget.songInfo.title!;
    final songArtist = widget.songInfo.artist!;
    final songArtwork = widget.songInfo.albumArtwork;
    final songArtwork2 = songQueryProvider.songArtwork(widget.songInfo.id);
    final hasArtWork = File(songQueryProvider.songArtwork(widget.songInfo.id)).existsSync();
    final isSdk28Below = songQueryProvider.androidDeviceInfo!.version.sdkInt < 29;

    return ListTile(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
        leading: Container(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: isSdk28Below
              ? songArtwork != null
                ? Image.file(File(songArtwork), fit: BoxFit.cover,)
                : Image.file(File(songQueryProvider.defaultAlbum))
              : hasArtWork
                ? Image.file(File(songArtwork2), fit: BoxFit.cover,)
                : Image.file(File(songQueryProvider.defaultAlbum)),
          )
        ),
        title: Text(
          songTitle,
          style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.bold,
            color: Color(themeProvider.textHexColor)
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          songArtist,
          style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
            color: Color(themeProvider.textHexColor)
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: Color(themeProvider.textHexColor)),
          onPressed: () {
            showSongBottomSheet(context, widget.songInfo);
          },
        ),
        onTap: widget.onTap);
  }
}

class SongTile2 extends StatefulWidget {
  const SongTile2({
    required this.songInfo,
    required this.onTap
  });

  final SongInfo songInfo;
  final Function() onTap;

  @override
  _SongTile2State createState() => _SongTile2State();
}

class _SongTile2State extends State<SongTile2> {
  @override
  Widget build(BuildContext context) {
    final songTitle = widget.songInfo.title!;

    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
      title: Text(
        songTitle,
        overflow: TextOverflow.ellipsis,
        style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert, color: Colors.white),
        onPressed: () {
          showSongBottomSheet(context, widget.songInfo);
        },
      ),
      onTap: widget.onTap
    );
  }
}

class NowPlayingSongTile extends StatefulWidget {
  const NowPlayingSongTile({
    required Key key,
    required this.onTap,
    required this.isPlaying,
    required this.image,
    required this.index,
    required this.songTitle,
    required this.artistName,
    required this.path,
    required this.mediaItem
  }) : super(key: key);

  final Function() onTap;
  final bool isPlaying;
  final Image image;
  final int index;
  final String songTitle;
  final String artistName;
  final String path;
  final MediaItem mediaItem;

  @override
  _NowPlayingSongTileState createState() => _NowPlayingSongTileState();
}

class _NowPlayingSongTileState extends State<NowPlayingSongTile> {
  @override
  Widget build(BuildContext context) {
    final songQuery = Provider.of<SongQueryProvider>(context);
    final imageSize = 50.0;

    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
      tileColor: widget.isPlaying ? color4 : color1,
      leading: Container(
        height: imageSize,
        width: imageSize,
        child: Stack(
          children: [
            Container(
              height: imageSize,
              width: imageSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: widget.image
              ),
            ),
            widget.isPlaying
              ? Container(
                  height: imageSize,
                  width: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black.withOpacity(0.35),
                  ),
                  child: Container(
                    height: imageSize * 0.5,
                    width: imageSize * 0.5,
                    child: Image.asset("assets/imgs/playing.gif", fit: BoxFit.fill,),
                  ),
              )
              : Container()
          ],
        ),
      ),
      title: Text(
        widget.songTitle,
        style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.artistName,
        style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: ReorderableDragStartListener(
        index: widget.index,
        child: Container(
          width: 35,
          height: 35,
          margin: const EdgeInsets.all(10),
          child: Icon(Icons.menu, color: Colors.white,),
        ),
      ),
      onTap: widget.onTap,
      onLongPress: (){
        var songInfo = songQuery.getSongInfoByPath(widget.path)!;
        showQueueBottomSheet(context, songInfo, widget.mediaItem, widget.index);
      },
    );
  }
}

class PlaylistSongTile extends StatefulWidget {
  const PlaylistSongTile({
    required this.songInfo,
    required this.onTap, 
    required this.index
  });

  final SongInfo songInfo;
  final Function() onTap;
  final int index;

  @override
  _PlaylistSongTileState createState() => _PlaylistSongTileState();
}

class _PlaylistSongTileState extends State<PlaylistSongTile> {
  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songTitle = widget.songInfo.title!;
    final hasArtWork = File(songQueryProvider.songArtwork(widget.songInfo.id)).existsSync();
    final artistName = widget.songInfo.artist!;
    final songArtwork = widget.songInfo.albumArtwork;
    final songArtwork2 = songQueryProvider.songArtwork(widget.songInfo.id);
    final isSdk28Below = songQueryProvider.androidDeviceInfo!.version.sdkInt < 29;

    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
      leading: Container(
        height: 50,
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: isSdk28Below
            ? songArtwork != null
              ? Image.file(File(songArtwork), fit: BoxFit.cover,)
              : Image.file(File(songQueryProvider.defaultAlbum))
            : hasArtWork
              ? Image.file(File(songArtwork2), fit: BoxFit.cover,)
              : Image.file(File(songQueryProvider.defaultAlbum)),
        )
      ),
      title: Container(
        padding: EdgeInsets.only(right: 8.0),
        child: Text(
          songTitle,
          overflow: TextOverflow.ellipsis,
          style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.bold
          )
        ),
      ),
      subtitle: Container(
        padding: EdgeInsets.only(right: 8.0),
        child: Text(
          artistName,
          overflow: TextOverflow.ellipsis,
          style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)
              )
            ),
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
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
                            style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                            ),
                            speed: 20,
                          ),
                          SizedBox(height: 10),
                          Divider(thickness: 1.0, color: Colors.grey)
                        ],
                      ),
                    ),
                  ),
                    ListTile(
                      title: Text(
                        "Play Next",
                        style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      onTap: () {
                        songQueryProvider.playNextSong(widget.songInfo);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Add to Queue",
                        style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      onTap: () {
                        songQueryProvider.addToQueueSong(widget.songInfo);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Remove from Playlist",
                        style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: ThemeProvider.themeOf(context).data.dialogTheme.shape,
                              title: Text("Remove from Playlist", style: ThemeProvider.themeOf(context).data.dialogTheme.titleTextStyle,),
                              content: Text(
                                'Are you sure you want to remove "$songTitle" from this playlist?',
                                style: ThemeProvider.themeOf(context).data.dialogTheme.contentTextStyle,
                              ),
                              actions: [
                                TextButton(
                                  child: Text("CANCEL", style: ThemeProvider.themeOf(context).data.textTheme.button),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text("REMOVE", style: ThemeProvider.themeOf(context).data.textTheme.button,),
                                  onPressed: () async {
                                    await songQueryProvider.removeSongFromPlaylist(widget.songInfo, widget.index);
                                    await songQueryProvider.getSongFromPlaylist(widget.index);
                                    songQueryProvider.getSongs().whenComplete(() => Navigator.pop(context));
                                  },
                                )
                              ],
                            );
                          },
                        );
                    },
                  ),
                ],
              ),
            );
          });
        },
      ),
      onTap: widget.onTap
    );
  }
}