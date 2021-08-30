import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/ui/main_screen/components/my_drawer.dart';
import 'package:my_music/ui/mini_player/mini_player.dart';
import 'package:my_music/ui/main_screen/components/background_wallpaper.dart';
import 'package:my_music/ui/main_screen/components/main_ui.dart';
import 'package:my_music/ui/search_song/search_song.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _innerDrawerKey = GlobalKey<InnerDrawerState>();
  
  @override
  void initState() {
    scrollController = ScrollController();
    miniPlayerController = MiniplayerController();
    playlistController = TextEditingController();
    init();
    super.initState();
  }

  void init(){
    final themeProvider = context.read<CustomThemeProvider>();
    final songQueryProvider = context.read<SongQueryProvider>();
    songQueryProvider.init();
    // songQueryProvider.setDefaultAlbumArt();
    themeProvider.getCurrentBackground();
    // songQueryProvider.getSongs();
    themeProvider.initFont();
    themeProvider.getCurrentTextColor();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    scrollController = null;
    miniPlayerController?.dispose();
    miniPlayerController = null;
    playlistController?.dispose();
    playlistController = null;
    tabController?.dispose();
    tabController = null;
    OnAudioRoom().closeRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
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
                      MainUI(globalKey: _innerDrawerKey,),
                      Consumer<SongPlayerProvider>(
                        builder: (context, songPlayer, child) {
                          return StreamBuilder<bool>(
                            stream: songPlayer.backgroundRunningStream,
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
    );
  }
}