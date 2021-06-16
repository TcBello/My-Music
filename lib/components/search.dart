

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends SearchDelegate<SongInfo>{
  final recent = [];

  @override
  buildActions(BuildContext context) {
    return <Widget>[];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.grey[700],),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final _song = context.select((SongQueryProvider s) => s.songInfo);
    final _songSearchList = _song.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
    print(_songSearchList);
    
    Widget _backgroundWidget(){
      return Consumer<ThemeProvider>(
        builder: (context, theme, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: theme.backgroundFilePath == theme.defaultBgPath || theme.backgroundFilePath == "" || !File(theme.backgroundFilePath).existsSync()
              ? color1
              : Colors.transparent,
            child: theme.backgroundFilePath == theme.defaultBgPath ||
                      theme.backgroundFilePath == "" || !File(theme.backgroundFilePath).existsSync()
                  ? Container()
                  : Image.file(
                      File(theme.backgroundFilePath),
                      fit: BoxFit.cover,
                    )
          );
        }
      );
    }

    Widget _songListBuilder(){
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 40,
                    left: 20,
                    bottom: 10
                ),
                child: Text("Songs", style: headerSearchResult,),
              ),
              Consumer2<SongPlayerProvider, SongQueryProvider>(
                builder: (context, songPlayer, songQuery, child){
                  return ListBody(
                    children: List.generate(_songSearchList.length, (index) => SongTile(
                      songInfo: _songSearchList[index],
                      onTap: (){
                        songQuery.setQueue(_songSearchList);
                        songPlayer.playSong(_songSearchList, index);
                      },
                    )),
                  );
                },
              )
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        _backgroundWidget(),
        Positioned.fill(
          child: FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              var pref = snapshot.data;
              double blurValue = pref.getDouble('currentblur');

              if(snapshot.hasData){
                if(blurValue == null){
                  blurValue = 0.0;
                }
                
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurValue,
                    sigmaY: blurValue,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                );
              }
              else{
                return Container();
              }
            }
          ),
        ),
        _songListBuilder()
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _model = context.select((SongQueryProvider s) => s.stringSongs);
    final _suggestionList = query.isEmpty ? recent : _model.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: _suggestionList.length,
      itemBuilder: (context, index){
        return ListTile(
            leading: CircleAvatar(
              backgroundColor: color2,
              child: Icon(Icons.music_note, color: Colors.white,),
            ),
            onTap: (){
              query = _suggestionList[index];
              showResults(context);
            },
            title: Text(_suggestionList[index], style: searchSuggestionTextStyle,)
        );
      },
    );
  }
}