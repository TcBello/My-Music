import 'dart:io';

import 'package:flutter/material.dart';

class ImageGridFile extends StatelessWidget {
  final String _img;
  ImageGridFile(this._img);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 147,
        height: MediaQuery.of(context).size.height * 0.182,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0)
          ),
          child: Image.file(File(_img), fit: BoxFit.cover,),
        )
    );
  }
}

class ImageGridAsset extends StatelessWidget {
  final String _img;
  ImageGridAsset(this._img);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 147,
        height: MediaQuery.of(context).size.height * 0.182,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0)
          ),
          child: Image.asset("assets/imgs/${_img}", fit: BoxFit.cover,),
        )
    );
  }
}

