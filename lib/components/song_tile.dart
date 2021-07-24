import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/theme.dart';
import 'package:provider/provider.dart';

class SongTile extends StatefulWidget {
  const SongTile({this.songInfo, this.onTap});

  final SongInfo songInfo;
  final Function onTap;

  @override
  _SongTileState createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songTitle = widget.songInfo.title;
    final songArtist = widget.songInfo.artist;
    final songArtwork = widget.songInfo.albumArtwork;
    final songArtwork2 = songQueryProvider.songArtwork(widget.songInfo.id);
    final hasArtWork = File(songQueryProvider.songArtwork(widget.songInfo.id)).existsSync();
    final isSdk28Below = songQueryProvider.androidDeviceInfo.version.sdkInt < 29;

    return ListTile(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
        leading: Container(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            // child: hasArtWork
            //   ? Image.file(File(songQueryProvider.artWork(widget.songInfo.albumId)), fit: BoxFit.cover,)
            //   : Image.file(File(songQueryProvider.defaultAlbum)),
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
          style: musicTextStyle(themeProvider.textHexColor),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          songArtist,
          style: artistMusicTextStyle(themeProvider.textHexColor),
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
  const SongTile2({this.songInfo, this.onTap});

  final SongInfo songInfo;
  final Function onTap;

  @override
  _SongTile2State createState() => _SongTile2State();
}

class _SongTile2State extends State<SongTile2> {
  @override
  Widget build(BuildContext context) {
    final songTitle = widget.songInfo.title;

    return ListTile(
        contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
        title: Text(
          songTitle,
          overflow: TextOverflow.ellipsis,
          style: librarySongTitleTextStyle,
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {
            showSongBottomSheet(context, widget.songInfo);
          },
        ),
        onTap: widget.onTap);
  }
}

class NowPlayingSongTile extends StatefulWidget {
  const NowPlayingSongTile({
    Key key,
    // this.songInfo,
    this.onTap,
    this.isPlaying,
    this.image,
    this.index,
    this.songTitle,
    this.artistName,
    this.path,
    this.mediaItem
  }) : super(key: key);

  // final SongInfo songInfo;
  final Function onTap;
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
    // final songTitle = widget.songInfo.title;
    // final songArtist = widget.songInfo.artist;
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
          style: nowPlayingStyle,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.artistName,
          style: nowPlayingStyle2,
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
        // trailing: widget.isPlaying
        //   ? Container(
        //       margin: const EdgeInsets.all(10),
        //       width: 35,
        //       height: 35,
        //       child: Image.asset("assets/imgs/playing.gif", fit: BoxFit.contain,),
        //     )
        //   // : IconButton(
        //   //     icon: Icon(
        //   //       Icons.more_vert,
        //   //       color: Colors.white,
        //   //     ),
        //   //     onPressed: () {
        //   //       showSongBottomSheet(context, widget.songInfo);
        //   //     },
        //   //   ),
        //   : Container(
        //     height: 1,
        //     width: 1,
        //   ),
        onTap: widget.onTap,
        onLongPress: (){
          var songInfo = songQuery.getSongInfoByPath(widget.path);
          showQueueBottomSheet(context, songInfo, widget.mediaItem, widget.index);
        },
    );
  }
}

class PlaylistSongTile extends StatefulWidget {
  const PlaylistSongTile({this.songInfo, this.onTap, this.index});

  final SongInfo songInfo;
  final Function onTap;
  final int index;

  @override
  _PlaylistSongTileState createState() => _PlaylistSongTileState();
}

class _PlaylistSongTileState extends State<PlaylistSongTile> {
  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songTitle = widget.songInfo.title;
    final hasArtWork = File(songQueryProvider.songArtwork(widget.songInfo.id)).existsSync();
    final artistName = widget.songInfo.artist;
    final songArtwork = widget.songInfo.albumArtwork;
    final songArtwork2 = songQueryProvider.songArtwork(widget.songInfo.id);
    final isSdk28Below = songQueryProvider.androidDeviceInfo.version.sdkInt < 29;

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
            style: librarySongTitleTextStyle,
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            artistName,
            overflow: TextOverflow.ellipsis,
            style: libraryArtistTextStyle,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {
            // showSongBottomSheet(context, widget.songInfo);
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0))),
                backgroundColor: Colors.white,
                context: context,
                builder: (context) {
                  return Container(
                    height: 260, //250 orig height
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
                                  style: headerBottomSheetTextStyle,
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
                            style: bottomSheetTextStyle,
                          ),
                          onTap: () {
                            songQueryProvider.playNextSong(widget.songInfo);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Add to Queue",
                            style: bottomSheetTextStyle,
                          ),
                          onTap: () {
                            songQueryProvider.addToQueueSong(widget.songInfo);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Remove from playlist",
                            style: bottomSheetTextStyle,
                          ),
                          onTap: () async {
                            Navigator.pop(context);

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  title: Text("Remove from playlist", style: dialogTitleTextStyle,),
                                  content: Text(
                                    'Are you sure you want to remove "$songTitle" from this playlist?',
                                    style: dialogContentTextStyle,
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text("Cancel", style: dialogButtonTextStyle,),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      child: Text("Remove", style: dialogButtonTextStyle,),
                                      onPressed: () async {
                                        await songQueryProvider
                                            .removeSongFromPlaylist(
                                                widget.songInfo, widget.index);
                                        await songQueryProvider
                                            .getSongFromPlaylist(widget.index);
                                        songQueryProvider
                                            .getSongs()
                                            .whenComplete(
                                                () => Navigator.pop(context));
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        // ListTile(
                        //   title: Text("Edit"),
                        //   onTap: (){
                        //     Navigator.pop(context);
                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => SongInfoEdit(title: song.songInfoFromPlaylist[index].title, index: index, isSong: false, fromArtist: true,)));
                        //   },
                        // )
                      ],
                    ),
                  );
                });
          },
        ),
        onTap: widget.onTap);
  }
}