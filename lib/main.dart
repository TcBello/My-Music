import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart' as dpinjector;
import 'package:my_music/components/audio_player_handler/audio_player_handler.dart';
import 'package:my_music/dependency/audio_handler.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/ui/main_screen/main_screen.dart'; 
import 'package:my_music/components/style.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:theme_provider/theme_provider.dart';

// TODO: ADD REAL BANNER AND INTERSTITIAL VIDEO ID

void addFontLicense(String value){
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Chivo/SIL Open Font License.txt');
    yield LicenseEntryWithLineBreaks(['chivo'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Comfortaa/OFL.txt');
    yield LicenseEntryWithLineBreaks(['comfortaa'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/HK Grotesk/SIL Open Font License.txt');
    yield LicenseEntryWithLineBreaks(['hk_grotesk'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['montserrat'], license);
  });
}

void main() async {
  MusicHandler musicHandler = MusicHandler();

  final injector = dpinjector.Injector.appInstance;

  WidgetsFlutterBinding.ensureInitialized();
  
  compute(addFontLicense, "");

  musicHandler.audio = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: AudioServiceConfig(
      androidStopForegroundOnPause: true,
    )
  );

  injector.registerDependency<MusicHandler>(() => musicHandler);
  final dpMusicHandler = injector.get<MusicHandler>();

  MobileAds.initialize(
    nativeAdUnitId: MobileAds.nativeAdTestUnitId,
    interstitialAdUnitId: MobileAds.interstitialAdVideoTestUnitId
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SongQueryProvider(audioHandler: dpMusicHandler.audio),
        ),
        ChangeNotifierProvider(
          create: (context) => SongPlayerProvider(audioHandler: dpMusicHandler.audio),
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
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      image: Image.asset("assets/imgs/image_splash.png"),
      photoSize: 40.0,
      backgroundColor: Colors.white,
      useLoader: false,
      loadingTextPadding: const EdgeInsets.all(0),
      seconds: 2,
      loadingText: Text("TCBELLO", style: TextStyle(fontSize: 20, letterSpacing: 2, color: Colors.white),),
      styleTextUnderTheLoader: TextStyle(fontSize: 20, letterSpacing: 2, color: Colors.black),
      navigateAfterSeconds: Material(
        child: MainScreen(),
      ),
      title: Text("My Music", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF3673),
          Color(0xFFFFA1BD)
        ]
      ),
    );
  }
}

