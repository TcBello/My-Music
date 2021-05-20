import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
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
    final songTitle = widget.songInfo.title;
    final songArtist = widget.songInfo.artist != "<unknown>"
        ? widget.songInfo.artist
        : "Unknown Artist";

    return ListTile(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
        title: Container(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            songTitle,
            style: musicTextStyle(themeProvider.textHexColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            songArtist,
            style: artistMusicTextStyle(themeProvider.textHexColor),
            overflow: TextOverflow.ellipsis,
          ),
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
        title: Container(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            songTitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {
            showSongBottomSheet(context, widget.songInfo);
          },
        ),
        onTap: widget.onTap);
  }
}

class NowPlayingSongTile extends StatefulWidget {
  const NowPlayingSongTile({this.songInfo, this.onTap, this.isPlaying});

  final SongInfo songInfo;
  final Function onTap;
  final bool isPlaying;

  @override
  _NowPlayingSongTileState createState() => _NowPlayingSongTileState();
}

class _NowPlayingSongTileState extends State<NowPlayingSongTile> {
  @override
  Widget build(BuildContext context) {
    final songTitle = widget.songInfo.title;
    final songArtist = widget.songInfo.artist != "<unknown>"
        ? widget.songInfo.artist
        : "Unknown Artist";

    return ListTile(
        contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
        tileColor: widget.isPlaying ? Colors.pinkAccent : Colors.white,
        title: Container(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            songTitle,
            style: nowPlayingStyle(widget.isPlaying),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            songArtist,
            style: nowPlayingStyle(widget.isPlaying),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: widget.isPlaying ? Colors.white : Colors.black,
          ),
          onPressed: () {
            showSongBottomSheet(context, widget.songInfo);
          },
        ),
        onTap: widget.onTap);
  }
}