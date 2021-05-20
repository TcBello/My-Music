import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({this.albumInfo});

  final AlbumInfo albumInfo;

  @override
  Widget build(BuildContext context) {
    final albumName = albumInfo.title;
    final artistName = albumInfo.artist != '<unknown>' ? albumInfo.artist : "";

    final songNumber = "${albumInfo.numberOfSongs} song";

    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 65, left: 15, right: 15),
              child: AutoSizeText(
                albumName,
                maxLines: 2,
                style: headerLibrarySongListTextStyle,
              ),
            ),
          ),
          Positioned.fill(
            top: 40,
            child: ListTile(
              title: Text(
                artistName,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(songNumber),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
              ),
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
