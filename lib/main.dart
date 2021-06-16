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
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MaterialApp(home: Splash(),),
    )
  );
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      backgroundColor: Colors.white,
      loaderColor: Colors.white,
      loadingText: Text("TCBELLO", style: TextStyle(fontSize: 20, letterSpacing: 2),),
      navigateAfterSeconds: Main(),
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    return MaterialApp(
      // showPerformanceOverlay: true,
        theme: ThemeData(
          tabBarTheme: tabBarStyle,
          appBarTheme: appBarStyle,
          textTheme: textStyle,
          fontFamily: "Montserrat",
        ),
        home: AudioServiceWidget(child: Material(child: MainScreen()),)
    );
  }
}

class Inits extends StatefulWidget {
  @override
  _InitsState createState() => _InitsState();
}

class _InitsState extends State<Inits> {

  ThemeProvider _themeProvider;
  SongQueryProvider songQueryProvider;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async{
    _themeProvider = context.read<ThemeProvider>();
    songQueryProvider = context.read<SongQueryProvider>();
    songQueryProvider.setDefaultAlbumArt();
    await songQueryProvider.getSongs();
    await _themeProvider.getCurrentBackground();
    print("HAKDOG");
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

