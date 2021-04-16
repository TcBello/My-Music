import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/now_playing/components/now_playing_builder.dart';

class NowPlaying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Now Playing",
          style: headerLibrarySongListTextStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
      ),
      body: NowPlayingBuilder(),
    );
  }
}
