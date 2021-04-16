import 'package:flutter/material.dart';

const String defaultFont = "Montserrat";

const TabBarTheme tabBarStyle = TabBarTheme(
  labelColor: Colors.pinkAccent,
  unselectedLabelColor: Colors.white,
  labelStyle: TextStyle(fontFamily: defaultFont),
  unselectedLabelStyle: TextStyle(fontFamily: defaultFont),
);

const AppBarTheme appBarStyle = AppBarTheme(
    textTheme: TextTheme(
        title: TextStyle(
            fontFamily: defaultFont,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20)),
    actionsIconTheme: IconThemeData(color: Colors.white));

const TextStyle rubberTextStyle = TextStyle(
    fontFamily: defaultFont,
    color: Colors.pinkAccent,
    fontWeight: FontWeight.w500,
    fontSize: 18
);

const TextTheme textStyle =
TextTheme(title: TextStyle(fontFamily: defaultFont, color: Colors.black));

const TextStyle defTextStyle = TextStyle(fontFamily: defaultFont, color: Colors.white);

TextStyle musicTextStyle(int color) {return TextStyle(fontFamily: defaultFont, color: Color(color), fontWeight: FontWeight.bold);}
TextStyle artistMusicTextStyle(int color){return TextStyle(fontFamily: defaultFont, color: Color(color));}

const TextStyle musicTextStyle2 = TextStyle(fontFamily: defaultFont, color: Colors.black, fontWeight: FontWeight.bold);

const TextTheme drawerTextStyle = TextTheme(
    title: TextStyle(
        fontFamily: defaultFont,
        color: Colors.white,
        fontWeight: FontWeight.bold));

const TextStyle headerDrawerTextStyle = TextStyle(
    fontFamily: defaultFont,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 40,
    letterSpacing: 5.0
);

const TextStyle currentAlbumTextStyle = TextStyle(
  fontFamily: defaultFont,
  color: Colors.white,
  fontSize: 10,
  fontStyle: FontStyle.italic,
);

const TextStyle headerBottomSheetTextStyle = TextStyle(
    fontFamily: defaultFont,
    color: Colors.black,
    fontSize: 21,
    fontWeight: FontWeight.w500
);

const TextStyle headerLibrarySongListTextStyle = TextStyle(
    fontFamily: defaultFont,
    color: Colors.black,
    fontSize: 21,
    fontWeight: FontWeight.w600
);

const TextStyle headerSearchResult = TextStyle(
    fontFamily: defaultFont,
    color: Colors.white,
    fontSize: 21,
    fontWeight: FontWeight.w600
);

TextStyle nowPlayingStyle(bool isPlaying){
  if(isPlaying){
    return TextStyle(
      color: Colors.white
    );
  }
  else{
    return TextStyle(
      color: Colors.black
    );
  }
}