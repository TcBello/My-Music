import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/albums.dart';
import 'package:my_music/artists.dart';
import 'package:my_music/mini_player.dart';
import 'package:my_music/now_playing.dart';
import 'package:my_music/playlists.dart';
import 'package:my_music/search.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/songs.dart';
import 'package:my_music/style.dart';
import 'package:my_music/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  SongModel _songModel;

  TabController _tabController;
  ScrollController _scrollController;
  RubberAnimationController _controller;
  bool _isPlayerExpand = false;
  bool _isPlayerAnimating = false;
  int currentIndex = 1;
  double dragValue = 0.0;
  bool isDrag = false;

  final List<Widget> _myTabs = [Songs(), Artists(), Albums(), Playlists()];

  @override
  Future<void> initState() {
    super.initState();
    _songModel = context.read<SongModel>();
    _tabController = TabController(vsync: this, length: 4);
    _scrollController = ScrollController();
    // _songModel.getCurrentBackground();
    // _songModel.getDataSong();
    // _songModel.myPlayer();
    // _songModel.getImageFileFromAssets();

    _controller = RubberAnimationController(
        vsync: this,
        lowerBoundValue: AnimationControllerValue(pixel: 70),
        upperBoundValue: AnimationControllerValue(percentage: 1),
        duration: Duration(milliseconds: 400));
    _controller.addStatusListener(_statusListener);
    _controller.animationState.addListener(_stateListener);

    if (_songModel.isPlayOnce) {
      print("PLAYED ONCE");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _songModel.disposeMyPlayer();
    _tabController.dispose();
    _scrollController.dispose();
    _controller.addStatusListener(_statusListener);
    _controller.animationState.addListener(_stateListener);
  }

  void _stateListener() {
    print("state changed ${_controller.animationState.value}");

    if(_controller.animationState.value == AnimationState.animating){
      setState(() {
        _isPlayerAnimating = true;
      });
    }

    if (_controller.animationState.value == AnimationState.expanded) {
      _songModel.isPlayerExpand = true;
      setState(() {
        _isPlayerExpand = true;
        _isPlayerAnimating = false;
      });
    }
    if (_controller.animationState.value == AnimationState.collapsed) {
      _songModel.isPlayerExpand = false;
      setState(() {
        _isPlayerExpand = false;
        _isPlayerAnimating = false;
      });
    }
  }

  void _statusListener(AnimationStatus status) {
    print("changed status ${_controller.status}");
    if(status == AnimationStatus.forward || status == AnimationStatus.completed){
      setState(() {
        _isPlayerAnimating = true;
      });
    }
  }

  void showQueueSongs() {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => NowPlaying(),
        ));
  }

  Future<bool> onWillScope(){
    if(_isPlayerExpand){
      _controller.collapse();
    }
    return Future.value(false);
  }

  String toMinSecFormat(Duration duration){
    if(duration.inMinutes < 60){
      String minutes = (duration.inSeconds / 60).truncate().toString();
      String seconds = (duration.inSeconds % 60).truncate().toString().padLeft(2, '0');

      return "$minutes:$seconds";
    }
    else{
      String hours = (duration.inMinutes / 60).truncate().toString();
      String minutes = (duration.inMinutes % 60).truncate().toString().padLeft(2, '0');
      String seconds = (duration.inSeconds % 60).truncate().toString().padLeft(2, '0');

      return "$hours:$minutes:$seconds";
    }
  }

  String toMinSecFormatWhileDragging(double dragPosition, Duration duration){

    if((Duration(milliseconds: dragPosition.toInt()).inMinutes) < 60){

      if(duration.inSeconds.toDouble() > dragPosition){
        double newDouble = duration.inSeconds.toDouble() - dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String minutes = (newDuration.inSeconds/ 60).truncate().toString();
        String seconds = (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$minutes:$seconds";
      }
      else{
        double newDouble = duration.inSeconds.toDouble() + dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String minutes = (newDuration.inSeconds / 60).truncate().toString();
        String seconds = (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');
        
        return "$minutes:$seconds";
      }      
    }
    else{

      if(duration.inSeconds.toDouble() > dragPosition){
        double newDouble = duration.inSeconds.toDouble() - dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String hours = (newDuration.inMinutes / 60).truncate().toString();
        String minutes = (newDuration.inMinutes % 60).truncate().toString().padLeft(2, '0');
        String seconds = (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$hours:$minutes:$seconds";
      }
      else{
        double newDouble = duration.inSeconds.toDouble() + dragPosition;
        Duration newDuration = Duration(milliseconds: newDouble.toInt());
        String hours = (newDuration.inMinutes / 60).truncate().toString();
        String minutes = (newDuration.inMinutes % 60).truncate().toString().padLeft(2, '0');
        String seconds = (newDuration.inSeconds % 60).truncate().toString().padLeft(2, '0');

        return "$hours:$minutes:$seconds";
      }
    }
  }

  Widget _carouselBuilder() {
    // return CarouselSlider.builder(
    //   height: 300.0,
    //   viewportFraction: 0.89,
    //   initialPage: _songModel.index,
    //   onPageChanged: (i) {
    //     _songModel.setIndex(i);

    //     if (_songModel.isPlayAllSongs) {
    //       _songModel.playSong();
    //     } else {
    //       _songModel.playSpecificSong();
    //     }
    //   },
    //   itemCount: _songModel.isPlayAllSongs
    //       ? _songModel.songInfo.length
    //       : _songModel.specificSongInfo.length,
    //   itemBuilder: (context, index) {
    //     return _songModel.isPlayAllSongs
    //         ? _songModel.audioItem.albumArtwork != null
    //             ? Container(
    //                 width: 300,
    //                 child: Image.file(
    //                   File(_songModel.audioItem.albumArtwork),
    //                   fit: BoxFit.cover,
    //                 ),
    //               )
    //             : Container(
    //                 width: 300,
    //                 child: Image.asset(
    //                   "assets/imgs/defalbum.png",
    //                   fit: BoxFit.cover,
    //                 ),
    //               )
    //         : _songModel.audioItem2.albumArtwork != null
    //             ? Container(
    //                 width: 300,
    //                 child: Image.file(
    //                   File(_songModel.audioItem2.albumArtwork),
    //                   fit: BoxFit.cover,
    //                 ),
    //               )
    //             : Container(
    //                 width: 300,
    //                 child: Image.asset(
    //                   "assets/imgs/defalbum.png",
    //                   fit: BoxFit.cover,
    //                 ),
    //               );
    //   },
    // );
    final List<Widget> carouselItems = [
      InkWell(
        onLongPress: () {
          // TODO: navigate to edit screen
        },
        child: Container(
            width: 300,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_box,
                  color: Colors.pinkAccent,
                  size: 40,
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Tap to add album cover",
                    style: TextStyle(color: Colors.pinkAccent, fontSize: 20))
              ],
            )),
      ),
      Container(
          width: 300,
          child: _songModel.audioItem.albumArtwork != null
                  ? Image.file(
                      File(_songModel.audioItem.albumArtwork),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/imgs/defalbum.png',
                      fit: BoxFit.cover,
                    )
      ),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider(
          items: carouselItems,
          height: 300.0,
          viewportFraction: 1.0,
          initialPage: 1,
          enableInfiniteScroll: false,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 20,
          height: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: carouselItems.map((e) {
              int index = carouselItems.indexOf(e);

              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? Colors.pinkAccent
                        : Colors.white),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _backgroundWidget() {
    return Consumer<SongModel>(builder: (context, x, child) {
      // TODO: WRAP WITH PARENT FUTURE BUILDER AND CHILD STACK TOGETHER WITH BLUR TO IMPROVE PERFORMANCE
      return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: x.backgroundFilePath == x.defaultBgPath ||
                  x.backgroundFilePath == "" || !File(x.backgroundFilePath).existsSync()
              ? Image.asset(
                  "assets/imgs/starry.jpg",
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(x.backgroundFilePath),
                  fit: BoxFit.cover,
                ));
    });
  }

  Widget screen(){
    return Scaffold(
          drawerEnableOpenDragGesture: !_songModel.isPlayerExpand,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool isScreenScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    forceElevated: true,
                    title: Text("Music"),
                    leading: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(Icons.menu),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (_songModel.isConvertToStringOnce) {
                            _songModel.songInfo.forEach((element) {
                              _songModel.stringSongs.add(element.title);
                            });
                            print(_songModel.stringSongs);
                            _songModel.isConvertToStringOnce = false;
                          }
                          showSearch(context: context, delegate: Search());
                        },
                      )
                    ],
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.pinkAccent,
                      tabs: <Widget>[
                        Tab(
                          text: "Songs",
                        ),
                        Tab(
                          text: "Artists",
                        ),
                        Tab(
                          text: "Albums",
                        ),
                        Tab(
                          text: "Playlists",
                        )
                      ],
                    ),
                  )
                ];
              },
              body: TabBarView(controller: _tabController, children: _myTabs)),
          drawer: MyDrawer(),
        );
  }

  Widget _rubberWidget() {
    return RubberBottomSheet(
        animationController: _controller,
        lowerLayer: Scaffold(
          drawerEnableOpenDragGesture: !_songModel.isPlayerExpand,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool isScreenScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    forceElevated: true,
                    title: Text("Music"),
                    leading: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(Icons.menu),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (_songModel.isConvertToStringOnce) {
                            _songModel.songInfo.forEach((element) {
                              _songModel.stringSongs.add(element.title);
                            });
                            print(_songModel.stringSongs);
                            _songModel.isConvertToStringOnce = false;
                          }
                          showSearch(context: context, delegate: Search());
                        },
                      )
                    ],
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.pinkAccent,
                      tabs: <Widget>[
                        Tab(
                          text: "Songs",
                        ),
                        Tab(
                          text: "Artists",
                        ),
                        Tab(
                          text: "Albums",
                        ),
                        Tab(
                          text: "Playlists",
                        )
                      ],
                    ),
                  )
                ];
              },
              body: TabBarView(controller: _tabController, children: _myTabs)),
          drawer: MyDrawer(),
        ),
        upperLayer: Consumer<SongModel>(
          builder: (context, _songModel, child) {
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _songModel.isPlayOnce
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        // constraints: BoxConstraints.expand(),
                        color: Colors.black, //bluegrey[800]
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            !_isPlayerAnimating
                             ? !_isPlayerExpand
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.music_note,
                                          color: Colors.pinkAccent,
                                        ),
                                      ),
                                      Expanded(
                                        //asdasdadadadasddas
                                        child: InkWell(
                                          onTap: () {
                                            _controller.expand();
                                          },
                                          child: Container(
                                            height: 70,
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            //  color: Colors.yellow,
                                            child: Center(
                                                child: Text(
                                                        _songModel
                                                            .audioItem.title,
                                                        style: rubberTextStyle,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 50,
                                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        child: ClipOval(
                                          child: FlatButton(
                                            onPressed: () {
                                              _songModel.onPauseResume();
                                            },
                                            child: _songModel.playPause,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.pinkAccent,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          _controller.collapse();
                                        },
                                      ),
                                      Expanded(
                                          child: Container(
                                              height: 70,
                                              child: Center(
                                                  child: Text(
                                                "Now Playing",
                                                style: rubberTextStyle,
                                              )))),
                                      IconButton(
                                        icon: Icon(
                                          Icons.equalizer,
                                          color: Colors.pinkAccent,
                                        ),
                                        onPressed: () => Equalizer.open(0),
                                      ),
                                      // PopupMenu(_songModel.index)
                                    ],
                                  )
                            : Container(height: 70,),
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   // height: 450.0,
                            //   child: _carouselBuilder(),
                            // ),
                            Container(
                              height: 300,
                              width: 300,
                              child: _songModel.audioItem.albumArtwork != null
                                      ? Image.file(
                                          File(_songModel.audioItem.albumArtwork),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/imgs/defalbum.png',
                                          fit: BoxFit.cover,
                                        )
                            ),
                            Container(
                              height: 50,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Text(
                                            _songModel.audioItem.title,
                                            style: rubberTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                  Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Text(
                                            _songModel.audioItem.artist ==
                                                    "<unknown>"
                                                ? "Unknown Artist"
                                                : _songModel.audioItem.artist,
                                            style: defTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                ],
                              ),
                            ),
                            StreamBuilder<PlaybackDisposition>(
                              initialData: PlaybackDisposition.zero(),
                              stream: _songModel.audioPlayer.onProgress
                                  .asBroadcastStream(
                                      onListen: _songModel.onStreamDuration(),
                                      onCancel:
                                          _songModel.onStreamDurationCancel()),
                              builder: (context, snapshot) {
                                // String position = snapshot.data.position
                                //     .toString()
                                //     .split('.')
                                //     .first;
                                // String duration = snapshot.data.duration
                                //     .toString()
                                //     .split('.')
                                //     .first;
                                String position = isDrag ? toMinSecFormatWhileDragging(dragValue, snapshot.data.position) :  toMinSecFormat(snapshot.data.position);
                                String duration = toMinSecFormat(snapshot.data.duration);

                                double durationMin = snapshot
                                    .data.position.inMilliseconds
                                    .toDouble();
                                double durationMax = snapshot
                                    .data.duration.inMilliseconds
                                    .toDouble();

                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Container(
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Slider(
                                                activeColor: Colors.pinkAccent,
                                                inactiveColor: Colors.pink[100],
                                                value: isDrag ? dragValue : durationMin,
                                                min: 0.0,
                                                max: durationMax,
                                                onChanged:
                                                    (double duration) async {
                                                      if(isDrag){
                                                        setState(() {
                                                          dragValue = duration;
                                                        });
                                                      }
                                                },
                                                onChangeStart: (value) {
                                                  setState(() {
                                                    isDrag = true;
                                                  });
                                                },
                                                onChangeEnd: (double finalDuration) async {
                                                  setState(() {
                                                    isDrag = false;
                                                  });
                                                  
                                                  if(!isDrag){
                                                    await _songModel.seekPlayer(finalDuration);
                                                  }
                                                },
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 0, 0, 0),
                                                    child: Text(
                                                      // _songModel.currentPosition,
                                                      position,
                                                      style: defTextStyle,
                                                    )),
                                                Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 20, 0),
                                                    child: Text(
                                                      // _songModel.songDuration,
                                                      duration,
                                                      style: defTextStyle,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: _songModel.repeatIcons[
                                        _songModel.currentRepeatMode],
                                    onPressed: () {
                                      _songModel.changeRepeatMode();
                                      Fluttertoast.showToast(
                                          msg: _songModel.repeatModeMessage,
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_SHORT);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(
                                      Icons.skip_previous,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () {
                                      _songModel.onSkipPrev();
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  ClipOval(
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.pinkAccent,
                                                  width: 6)),
                                        ),
                                        Positioned.fill(
                                          child: IconButton(
                                            icon: _songModel.playPause2,
                                            onPressed: _songModel.onPauseResume,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(
                                      Icons.skip_next,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () {
                                      _songModel.onSkipNext();
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(
                                      Icons.queue_music,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: showQueueSongs,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Container());
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //     child: Stack(
    //       children: <Widget>[_backgroundWidget(), _rubberWidget()],
    //     ));
    return WillPopScope(
      onWillPop: onWillScope,
      child: Stack(
        children: <Widget>[
          _backgroundWidget(),
          Positioned.fill(
            child: FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                var pref = snapshot.data;
                double blurValue = pref.getDouble('currentblur');

                if(snapshot.hasData){
                  if(blurValue == null){
                    blurValue = 0.0;
                  }
                  
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurValue,
                      sigmaY: blurValue,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  );
                }
                else{
                  return Container();
                }
              }
            ),
          ),
          screen(),
          Selector<SongModel, bool>(
            selector: (context, notifier) => notifier.isPlayOnce,
            builder: (context, data, child) {
              if(data){
                return MiniPlayer();
              }

              return Container();
            },
          )
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  SongModel songModel = SongModel();

  Widget drawerWidget(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
            //width: MediaQuery.of(context).size.height,
            height: 100,
            child: Center(child: Text("Music", style: headerDrawerTextStyle)),
          ),
          // ListTile(
          //   onTap: () {},
          //   leading: Icon(
          //     Icons.music_note,
          //     color: Colors.white,
          //   ),
          //   title: Text("Music"),
          // ),
          // ListTile(
          //   onTap: () {},
          //   leading: Icon(
          //     Icons.folder_open,
          //     color: Colors.white,
          //   ),
          //   title: Text("Directories"),
          // ),
          // Divider(
          //   color: Colors.white,
          //   thickness: 1.0,
          // ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => Themes()));
            },
            leading: Icon(
              Icons.wallpaper,
              color: Colors.white,
            ),
            title: Text("Themes"),
          ),
          ListTile(
            // onTap: () {Navigator.push(context, CupertinoPageRoute(builder: (context) => EqualizerScreen()));},
            onTap: () {
              Equalizer.open(0);
            },
            leading: Icon(
              Icons.equalizer,
              color: Colors.white,
            ),
            title: Text("Equalizer"),
          ),
          ListTile(
            onTap: () async {
              await songModel
                  .getDataSong()
                  .then((value) => Navigator.pop(context));
            },
            leading: Icon(
              Icons.search,
              color: Colors.white,
            ),
            title: Text("Scan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
          textTheme: drawerTextStyle,
        ),
        child: drawerWidget(context));
  }
}

class PopupMenu extends StatefulWidget {
  final int index;
  PopupMenu(this.index);

  @override
  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  final List<String> menu = ["Add to Playlist"];
  TextEditingController _getText = TextEditingController();

  void showPlaylistDialog(index){
    showDialog(
        context: context,
        builder: (context) => Consumer<SongModel>(
          builder: (context, _songModel, snapshot) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text("Add to playlist"),
              content: Container(
                height: 150,
                width: 150,
                child: ListView.builder(
                  itemCount: _songModel.playlistInfo.length,
                  itemBuilder: (context, playlistIndex){
                    return ListTile(
                      title: Text(_songModel.playlistInfo[playlistIndex].name),
                      onTap: () async {
                        await _songModel.addSongToPlaylist(_songModel.songInfo[index], playlistIndex);
                        Fluttertoast.showToast(
                            msg: "1 song added to ${_songModel.playlistInfo[playlistIndex].name}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[800],
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        Navigator.pop(context);
                        _songModel.getDataSong();
                      },
                    );
                  },
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: (){Navigator.pop(context);},
                  child: Text("Cancel"),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: Text("Create Playlist"),
                        content: TextField(
                          controller: _getText,
                          decoration: InputDecoration(
                              labelText: "Name"
                          ),
                        ),
                        actions: [
                          FlatButton(
                            onPressed: (){Navigator.pop(context);},
                            child: Text("Cancel"),
                          ),
                          FlatButton(
                            onPressed: () async {
                              // await _songModel.addSongAndCreatePlaylist(_songModel.songInfo[index], _getText.text);
                              await _songModel.createPlaylist(_getText.text);
                              await _songModel.getDataSong();
                              Fluttertoast.showToast(
                                  msg: "${_getText.text} created successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.grey[800],
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                              _getText.text = "";
                              Navigator.pop(context);
                              showPlaylistDialog(index);
                            },
                            child: Text("Create"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text("New"),
                )
              ],
            );
          }
        )
    );
  }

  void selectPopupMenu(String select) {
    if (select == menu[0]) {
      showPlaylistDialog(widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      icon: Icon(
        Icons.more_vert,
        color: Colors.pinkAccent,
      ),
      onSelected: selectPopupMenu,
      itemBuilder: (context) {
        return menu
            .map((menu) => PopupMenuItem(
                  value: menu,
                  child: Center(child: Text(menu)),
                ))
            .toList();
      },
    );
  }
}
