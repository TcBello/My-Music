import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/theme.dart';
import 'package:provider/provider.dart';

class BackgroundWallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: theme.backgroundFilePath == theme.defaultBgPath ||
                  theme.backgroundFilePath == "" ||
                  !File(theme.backgroundFilePath).existsSync()
              ? Image.asset(
                  "assets/imgs/starry.jpg",
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(theme.backgroundFilePath),
                  fit: BoxFit.cover,
                )
        );
    });
  }
}
