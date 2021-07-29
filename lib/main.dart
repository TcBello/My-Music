import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music/components/audio_player_task/audio_player_task.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/theme.dart';
import 'package:my_music/ui/main_screen/main_screen.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:theme_provider/theme_provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SongQueryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SongPlayerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomThemeProvider(),
        ),
      ],
      child: Consumer<CustomThemeProvider>(
        builder: (context, theme, child) {
          return ThemeProvider(
            loadThemeOnInit: true,
            saveThemesOnChange: true,
            defaultThemeId: "default_theme",
            themes: [
              AppTheme(
                id: "default_theme",
                description: "Default Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: kAppBarTheme,
                  textTheme: textTheme,
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                ),
              ),
              AppTheme(
                id: "montserrat_theme",
                description: "Montserrat Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: kAppBarTheme,
                  textTheme: textTheme,
                  fontFamily: "Montserrat",
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                ),
              ),
              AppTheme(
                id: "comfortaa_theme",
                description: "Comfortaa Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: kAppBarTheme,
                  textTheme: textTheme,
                  fontFamily: "Comfortaa",
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                ),
              ),
              AppTheme(
                id: "hkgrotesk_theme",
                description: "HK Grotesk Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: kAppBarTheme,
                  textTheme: textTheme,
                  fontFamily: "HK Grotesk",
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                ),
              ),
              AppTheme(
                id: "chivo_theme",
                description: "Chivo Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: kAppBarTheme,
                  textTheme: textTheme,
                  fontFamily: "Chivo",
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                ),
              )
            ],
            child: Builder(
              builder: (context) => ThemeConsumer(
                child: MaterialApp(
                  // showPerformanceOverlay: true,
                  theme: ThemeProvider.themeOf(context).data,
                  home: Splash(),
                ),
              ),
            ),
          );
        }
      )
    )
  );
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return SplashScreen(
      seconds: 2,
      backgroundColor: Colors.white,
      loaderColor: Colors.white,
      loadingText: Text("TCBELLO", style: TextStyle(fontSize: 20, letterSpacing: 2),),
      // navigateAfterSeconds: Main(),
      navigateAfterSeconds: AudioServiceWidget(
        child: Material(
          child: MainScreen(),
        ),
      ),
      title: Text("My Music\n(Test Phase)", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    // return MaterialApp(
    //     theme: ThemeData(
    //       tabBarTheme: tabBarStyle,
    //       appBarTheme: appBarStyle,
    //       textTheme: textStyle,
    //       fontFamily: "Montserrat",
    //     ),
    //     home: AudioServiceWidget(child: Material(child: MainScreen()),)
    // );
  }
}

