import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/singleton/music_player_service.dart';
import 'package:my_music/ui/main_screen/components/my_drawer.dart';
import 'package:my_music/ui/mini_player/mini_player.dart';
import 'package:my_music/ui/main_screen/components/background_wallpaper.dart';
import 'package:my_music/ui/main_screen/components/main_ui.dart';
import 'package:my_music/ui/search_song/search_song.dart';
import 'package:my_music/utils/utils.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:theme_provider/theme_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  final _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  RateMyApp? _rateMyApp;
  MusicPlayerService _musicPlayerService = MusicPlayerService();
  
  @override
  void initState() {
    scrollController = ScrollController();
    songScrollController = ScrollController();
    artistScrollController = ScrollController();
    albumScrollController = ScrollController();
    playlistScrollController = ScrollController();
    miniPlayerController = MiniplayerController();
    playlistController = TextEditingController();
    interstitialAd = InterstitialAd();
    interstitialAd?.load();
    _rateMyApp = RateMyApp(
      minDays: 2,
      minLaunches: 5,
      remindLaunches: 3,
      remindDays: 3,
      googlePlayIdentifier: kAppId
    );

    _rateMyApp?.init().then((_){
      if(_rateMyApp!.shouldOpenDialog){
        Future.delayed(Duration(seconds: 1), (){
          _rateMyApp?.showStarRateDialog(
              context,
              title: "",
              message: "Please write a review",
              onDismissed: () => _rateMyApp?.callEvent(RateMyAppEventType.laterButtonPressed),
              dialogStyle: DialogStyle(
                dialogShape: ThemeProvider.themeOf(context).data.dialogTheme.shape,
                messageStyle: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                  color: Colors.black
                ),
                messagePadding: const EdgeInsets.symmetric(vertical: 10),
                titlePadding: EdgeInsets.zero
              ),
              contentBuilder: (context , child){
                return Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset("assets/imgs/icon.png"),
                        ),
                      ),
                      Text("Enjoying My Music?", style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                        color: Colors.black
                      ),),
                      child
                    ],
                  ),
                );
              },
              actionsBuilder: (context, value){
                return [
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          child: Text("RATE", style: ThemeProvider.themeOf(context).data.textTheme.button?.copyWith(
                            color: Colors.white
                          )),
                          onPressed: () async{
                            await _rateMyApp?.callEvent(RateMyAppEventType.rateButtonPressed);

                            if(value! <= 3){
                              sendEmail();
                            }
                            else{ 
                              var result = await _rateMyApp?.launchStore();
                              if (result == LaunchStoreResult.errorOccurred){
                                showShortToast(kLaunchStoreError);
                              }
                            }

                            Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(color3),
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 15
                            )),
                            textStyle: MaterialStateProperty.all(ThemeProvider.themeOf(context).data.textTheme.button?.copyWith(
                              color: Colors.white
                            ))
                          ),
                        ),
                        SizedBox(height: 5,),
                        TextButton(
                          child: Text("NOT NOW", style: ThemeProvider.themeOf(context).data.textTheme.button?.copyWith(
                            color: Colors.black
                          )),
                          onPressed: () async{
                            await _rateMyApp?.callEvent(RateMyAppEventType.laterButtonPressed);
                            Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.later);
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15
                            )),
                          ),
                        ),
                      ],
                    ),
                  )
                ];
              },
            );
        });
      }
    });

    init();
    super.initState();
  }

  void init(){
    final theme = context.read<CustomThemeProvider>();
    final songQuery = context.read<SongQueryProvider>();
    final songPlayer = context.read<SongPlayerProvider>();
    songQuery.init();
    songPlayer.init();
    theme.getCurrentBackground();
    theme.getCurrentTextColor();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    scrollController = null;

    songScrollController?.dispose();
    songScrollController = null;

    artistScrollController?.dispose();
    artistScrollController = null;

    albumScrollController?.dispose();
    albumScrollController = null;

    playlistScrollController?.dispose();
    playlistScrollController = null;

    miniPlayerController?.dispose();
    miniPlayerController = null;

    playlistController?.dispose();
    playlistController = null;

    tabController?.dispose();
    tabController = null;

    interstitialAd?.dispose();
    interstitialAd = null;

    _musicPlayerService.dispose();
    
    OnAudioRoom().closeRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        NavigatorState navigator = _navigatorKey.currentState!;
        if (!navigator.canPop()) return true;
        navigator.pop();

        return false;
      },
      child: Consumer<SongQueryProvider>(
        builder: (context, songQuery, child){
          return FutureBuilder<File>(
            future: songQuery.validatorFile(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return snapshot.data!.existsSync()
                  ? InnerDrawer(
                    key: _innerDrawerKey,
                    swipe: true,
                    swipeChild: true,
                    onTapClose: true,
                    scaffold: Stack(
                      children: <Widget>[
                        BackgroundWallpaper(),                        
                        Navigator(
                          key: _navigatorKey,
                          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                            settings: settings,
                            builder: (BuildContext context) => MainUI(globalKey: _innerDrawerKey,),
                          ),
                        ),
                        Consumer<SongPlayerProvider>(
                          builder: (context, songPlayer, child) {
                            return StreamBuilder<bool>(
                              stream: _musicPlayerService.audioBackgroundRunningStream,
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  print(snapshot.data);
                                  if(snapshot.data!){
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: MiniPlayer(),
                                    );
                                  }

                                  return Container();
                                }

                                return Container();
                              },
                            );
                          },
                        )
                      ],
                    ),
                    leftChild: MyDrawer()
                  )
                  : SearchSongUI();
              }

              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: color1,
              );
            },
          );
        },
      ),
    );
  }
}