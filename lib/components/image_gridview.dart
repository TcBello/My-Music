import 'dart:io';

import 'package:flutter/material.dart';

class ImageGridFile extends StatelessWidget {
  final String img;
  final String id;
  ImageGridFile(this.img, this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0)
          ),
          child: Hero(
            tag: id,
            child: Image.file(File(img), fit: BoxFit.cover,)
          ),
        )
    );
  }
}

