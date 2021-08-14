import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/search_result/search_result.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class Search extends SearchDelegate<SongInfo>{
  final _recent = [];

  @override
  buildActions(BuildContext context) {
    return <Widget>[];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white,),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final _song = context.select((SongQueryProvider s) => s.songInfo);
    final _songSearchList = _song.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();

    return SearchResult(songSearchList: _songSearchList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _model = context.select((SongQueryProvider s) => s.stringSongs);
    final _suggestionList = query.isEmpty
      ? _recent
      : _model.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: _suggestionList.length,
      itemBuilder: (context, index){
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: color3,
            child: Icon(Icons.music_note, color: Colors.white,),
          ),
          onTap: (){
            query = _suggestionList[index];
            showResults(context);
          },
          title: Text(_suggestionList[index], style: ThemeProvider.themeOf(context).data.textTheme.bodyText2.copyWith(
            fontWeight: FontWeight.w500,
          ))
        );
      },
    );
  }

  @override
  String get searchFieldLabel => "Search Song";

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData themeData = ThemeProvider.themeOf(context).data.copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none
        )
      ),
      appBarTheme: AppBarTheme(
        color: color2,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.grey[900],
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      primaryColor: color2,
      scaffoldBackgroundColor: color1,
      hintColor: Colors.grey[400],
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
      splashColor: color4,
      highlightColor: color4
    );

    return themeData;
  }

  
}