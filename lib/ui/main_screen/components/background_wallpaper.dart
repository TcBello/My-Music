import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:provider/provider.dart';

class BackgroundWallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomThemeProvider>(
      builder: (context, theme, child) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: theme.backgroundFilePath == "" || !File(theme.backgroundFilePath).existsSync()
            ? color1
            : Colors.transparent,
          child: theme.backgroundFilePath == "" || !File(theme.backgroundFilePath).existsSync()
              ? Container()
              : ClipRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: theme.blurValue,
                    sigmaY: theme.blurValue
                  ),
                  child: Image.file(
                      File(theme.backgroundFilePath),
                      fit: BoxFit.cover,
                    ),
                ),
              )
        );
    });
  }
}
