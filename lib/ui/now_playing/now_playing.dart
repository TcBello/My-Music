import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/ui/now_playing/components/now_playing_builder.dart';

class NowPlaying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        title: Text(
          "Up Next",
          style: headerAppBarTextStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
      ),
      body: NowPlayingBuilder(),
    );
  }
}
