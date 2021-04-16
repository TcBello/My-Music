import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/ui/artists/components/artist_library_builder.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/components/style.dart';

class ArtistProfile extends StatelessWidget {
  final String title;
  final int index;
  final String backgroundSliver;
  ArtistProfile({this.title, this.index, this.backgroundSliver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScreenScrolled){
          return <Widget>[
            SliverAppBar(
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: (){showSearch(context: context, delegate: Search());},
                )
              ],
              expandedHeight: 165,
              flexibleSpace: FlexibleSpaceBar(
                  background: backgroundSliver != null ? Image.file(File(backgroundSliver), fit: BoxFit.cover,) : Image.asset('assets/imgs/defalbum.png', fit: BoxFit.cover,)
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Center(
                  child: Text(
                    title != "<unknown>" ? title
                        : "UnknownArtist",
                    style: headerLibrarySongListTextStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text("In my library", style: headerLibrarySongListTextStyle,),
              ),
              ArtistLibraryBuilder()
            ],
          ),
        ),
      ),
    );
  }
}