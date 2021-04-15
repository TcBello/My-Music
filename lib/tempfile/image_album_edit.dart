import 'dart:io';

import 'package:flutter/material.dart';

class ImageAlbumEdit extends StatelessWidget {
  final String img;
  ImageAlbumEdit(this.img);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.file(File(img), fit: BoxFit.cover,),
        )
    );
  }
}
