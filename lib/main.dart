import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/ui/main_screen/main_screen.dart'; 
import 'package:my_music/components/style.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:theme_provider/theme_provider.dart';

void main() async {
  WidgetsBinding.instance;
  // debugRepaintTextRainbowEnabled = true;
  // debugRepaintRainbowEnabled = true;
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
                  appBarTheme: appBarTheme,
                  textTheme: textTheme,
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                  splashColor: color4,
                  highlightColor: color4
                ),
              ),
              AppTheme(
                id: "montserrat_theme",
                description: "Montserrat Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: appBarTheme,
                  textTheme: textTheme,
                  fontFamily: "Montserrat",
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                  splashColor: color4,
                  highlightColor: color4
                ),
              ),
              AppTheme(
                id: "comfortaa_theme",
                description: "Comfortaa Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: appBarTheme,
                  textTheme: textTheme,
                  fontFamily: "Comfortaa",
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                  splashColor: color4,
                  highlightColor: color4
                ),
              ),
              AppTheme(
                id: "hkgrotesk_theme",
                description: "HK Grotesk Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: appBarTheme,
                  textTheme: textTheme,
                  fontFamily: "HK Grotesk",
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                  splashColor: color4,
                  highlightColor: color4
                ),
              ),
              AppTheme(
                id: "chivo_theme",
                description: "Chivo Text Theme",
                data: ThemeData(
                  tabBarTheme: kTabBarTheme,
                  appBarTheme: appBarTheme,
                  textTheme: textTheme,
                  fontFamily: "Chivo",
                  dialogTheme: dialogTheme,
                  cardTheme: cardTheme,
                  unselectedWidgetColor: color5,
                  splashColor: color4,
                  highlightColor: color4
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

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: color2,
    systemNavigationBarDividerColor: color2
  ));
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return SplashScreen(
      loadingTextPadding: const EdgeInsets.all(0),
      useLoader: true,
      seconds: 2,
      backgroundColor: Colors.white,
      loaderColor: Colors.white,
      loadingText: Text("TCBELLO", style: TextStyle(fontSize: 20, letterSpacing: 2, color: Colors.black),),
      styleTextUnderTheLoader: TextStyle(fontSize: 20, letterSpacing: 2, color: Colors.black),
      navigateAfterSeconds: AudioServiceWidget(
        child: Material(
          child: MainScreen(),
        ),
      ),
      title: Text("My Music\n(Test Phase)", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black),),
    );
  }
}

