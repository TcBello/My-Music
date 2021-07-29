import 'package:flutter/material.dart';

const String montserrat = "Montserrat";

const Color color1 = Color(0xFF363636);
const Color color2 = Color(0xFF474747);
const Color color3 = Color(0xFFE8175D);
const Color color4 = Color(0xFFCC527A);
const Color color5 = Color(0xFFA8A7A7);

const TabBarTheme kTabBarTheme = TabBarTheme(
  labelColor: Colors.pinkAccent,
  unselectedLabelColor: Colors.white,
  labelStyle: TextStyle(
    color: Colors.pinkAccent,
    fontWeight: FontWeight.w600
  ),
  unselectedLabelStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600
  ),
);

const AppBarTheme kAppBarTheme = AppBarTheme(
  textTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20
    )
  ),
  titleTextStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20
  )
);

TextTheme textTheme = TextTheme(
  headline4: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 40
  ),
  headline5: TextStyle(
    fontWeight: FontWeight.w600
  ),
  headline6: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20
  ),
  bodyText1: TextStyle(
    color: Colors.white
  ),
  bodyText2: TextStyle(
    color: Colors.white
  ),
  button: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w500,
    fontSize: 15
  ),
  caption: TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey[700]
  )
);

DialogTheme dialogTheme = DialogTheme(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  ),
  titleTextStyle: TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontSize: 20
  ),
  contentTextStyle: TextStyle(
    // fontWeight: FontWeight.w500,
    color: Colors.black,
    fontSize: 15
  )
);

CardTheme cardTheme = CardTheme(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  )
);

const TextStyle defaultStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w600
);

const TextStyle monserratStyle = TextStyle(
  color: Colors.white,
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w600
);

// const TabBarTheme tabBarStyle = TabBarTheme(
//   labelColor: Colors.pinkAccent,
//   unselectedLabelColor: Colors.white,
//   labelStyle: TextStyle(fontFamily: defaultFont),
//   unselectedLabelStyle: TextStyle(fontFamily: defaultFont),
// );

// const AppBarTheme appBarStyle = AppBarTheme(
//     textTheme: TextTheme(
//         title: TextStyle(
//             fontFamily: defaultFont,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20)),
//     actionsIconTheme: IconThemeData(color: Colors.white));

// const TextStyle songTitleMiniplayerTextStyle = TextStyle(
//     fontFamily: defaultFont,
//     color: Colors.white,
//     fontWeight: FontWeight.bold,
//     fontSize: 18
// );

// const TextStyle songTitleMiniplayerTextStyle2 = TextStyle(
//     fontFamily: defaultFont,
//     color: Colors.white,
//     fontWeight: FontWeight.bold,
//     fontSize: 22
// );

// const TextTheme textStyle =
// TextTheme(title: TextStyle(fontFamily: defaultFont, color: Colors.black));

// const TextStyle defTextStyle = TextStyle(fontFamily: defaultFont, color: Colors.white);

// TextStyle musicTextStyle(int color) {
//   return TextStyle(
//     fontFamily: defaultFont,
//     color: Color(color),
//     fontWeight: FontWeight.bold
//   );
// }
// TextStyle artistMusicTextStyle(int color){
//   return TextStyle(
//     fontFamily: defaultFont,
//     color: Color(color),
//     fontWeight: FontWeight.w500
//   );
// }

// const TextStyle artistMiniplayerTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.w500
// );

// const TextStyle artistMiniplayerTextStyle2 = TextStyle(
//   fontFamily: defaultFont,
//   color: color5,
//   fontWeight: FontWeight.w600,
//   fontSize: 18
// );

// const TextStyle musicTextStyle2 = TextStyle(fontFamily: defaultFont, color: Colors.black, fontWeight: FontWeight.bold);

// const TextStyle headerDrawerTextStyle = TextStyle(
//     fontFamily: defaultFont,
//     color: Colors.white,
//     fontWeight: FontWeight.w600,
//     fontSize: 40,
// );

// const TextStyle drawerTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.w500
// );

// const TextStyle currentAlbumTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontSize: 10,
//   fontStyle: FontStyle.italic,
// );

// const TextStyle headerBottomSheetTextStyle = TextStyle(
//     fontFamily: defaultFont,
//     color: Colors.black,
//     fontSize: 21,
//     fontWeight: FontWeight.w500
// );

// const TextStyle headerLibrarySongListTextStyle = TextStyle(
//     fontFamily: defaultFont,
//     color: Colors.white,
//     fontSize: 20,
//     fontWeight: FontWeight.bold
// );

// const TextStyle headerSearchResult = TextStyle(
//     fontFamily: defaultFont,
//     color: Colors.white,
//     fontSize: 21,
//     fontWeight: FontWeight.w600
// );

// const TextStyle nowPlayingStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.bold
// );

// const TextStyle nowPlayingStyle2 = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.w500
// );

// const TextStyle headerAppBarTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.bold,
//   fontSize: 20
// );

// const TextStyle durationTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.w500,
//   fontSize: 16
// );

// const TextStyle librarySongTitleTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.bold,
// );

// const TextStyle libraryArtistTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.w500
// );

// const TextStyle musicHeaderTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: Colors.white,
//   fontWeight: FontWeight.bold
// );

// const TextStyle selectedTabTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: color3,
//   fontWeight: FontWeight.w600
// );

// const TextStyle unselectedTabTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   color: color3,
//   fontWeight: FontWeight.w600
// );

// const TextStyle themeTitleTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.bold,
//   color: Colors.white
// );

// const TextStyle themeSubtitleTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w500,
//   color: Colors.white
// );

// const TextStyle bottomSheetTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w500,
//   color: Colors.black
// );

// const TextStyle searchTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
//   fontSize: 20
// );

// const TextStyle headerBodyTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w600,
//   color: Colors.white,
//   fontSize: 18
// );

// const TextStyle dialogTitleTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w600,
//   color: Colors.black,
//   fontSize: 20
// );

// const TextStyle dialogContentTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w500,
//   color: Colors.black,
//   fontSize: 16
// );

// const TextStyle dialogButtonTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w600,
//   color: Colors.blue,
//   fontSize: 16
// );

// TextStyle sampleTextStyle(Color hex) => TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w500,
//   color: hex,
//   fontSize: 30
// );

// const TextStyle headerLibrarySongTextStyle2 = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
//   fontSize: 16
// );

// const TextStyle songCountTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w600,
//   fontSize: 16,
//   color: Colors.white
// );

// const TextStyle cardTitleTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.bold,
//   color: Colors.black
// );

// const TextStyle cardSubtitleTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w500,
//   color: Colors.black,
//   fontSize: 12
// );

// const TextStyle searchSuggestionTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w500,
//   color: Colors.black
// );

// const TextStyle searchSongTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w500,
//   color: Colors.white,
//   // fontSize: 18
// );

// const TextStyle timerHeaderTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w600,
//   color: Colors.black,
//   fontSize: 25
// );

// const TextStyle timerTextStyle = TextStyle(
//   fontFamily: defaultFont,
//   fontWeight: FontWeight.w500,
//   color: Colors.black,
//   fontSize: 22
// );