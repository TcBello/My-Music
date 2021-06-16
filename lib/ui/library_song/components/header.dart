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
    final artistName = albumInfo.artist;
    final songNumber = "${albumInfo.numberOfSongs} song";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(artistName, style: headerAppBarTextStyle,),
          SizedBox(height: 5,),
          Text(songNumber, style: songCountTextStyle,)
        ],
      ),
    );
  }
}
