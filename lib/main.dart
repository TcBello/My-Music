import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music/components/audio_player_task/audio_player_task.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/theme.dart';
import 'package:my_music/ui/main_screen/main_screen.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
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
      loadingText: Text("Temporary SplashScreen"),
      navigateAfterSeconds: Main(),
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
        theme: ThemeData(
          tabBarTheme: tabBarStyle,
          appBarTheme: appBarStyle,
          textTheme: textStyle,
          fontFamily: "Montserrat",
        ),
        home: AudioServiceWidget(child: Material(child: Inits()),)
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
    super.initState();
    _themeProvider = context.read<ThemeProvider>();
    songQueryProvider = context.read<SongQueryProvider>();
    _themeProvider.getCurrentBackground();
    songQueryProvider.getSongs();
    songQueryProvider.setDefaultAlbumArt();
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

