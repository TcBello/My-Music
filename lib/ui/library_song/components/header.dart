import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:theme_provider/theme_provider.dart';

class Header extends StatelessWidget {
  const Header({
    @required this.albumInfo
  });

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
          Text(artistName, style: ThemeProvider.themeOf(context).data.appBarTheme.textTheme.headline6,),
          SizedBox(height: 5,),
          Text(songNumber, style: ThemeProvider.themeOf(context).data.textTheme.bodyText1.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[350]
          ),)
        ],
      ),
    );
  }
}
