import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:provider/provider.dart';

class BackgroundWallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongModel>(builder: (context, x, child) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: x.backgroundFilePath == x.defaultBgPath ||
                x.backgroundFilePath == "" ||
                !File(x.backgroundFilePath).existsSync()
            ? Image.asset(
                "assets/imgs/starry.jpg",
                fit: BoxFit.cover,
              )
            : Image.file(
                File(x.backgroundFilePath),
                fit: BoxFit.cover,
              )
      );
    });
  }
}
