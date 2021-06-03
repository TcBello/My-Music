import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/albums/albums.dart';
import 'package:my_music/ui/artists/artists.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/search.dart';
import 'package:my_music/ui/playlists/playlists.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/ui/songs/songs.dart';
import 'package:my_music/ui/main_screen/components/my_drawer.dart';
import 'package:provider/provider.dart';

class MainUI extends StatefulWidget {
  const MainUI({this.globalKey});

  final GlobalKey<InnerDrawerState> globalKey;
  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> with SingleTickerProviderStateMixin {
  final List<Widget> _myTabs = [Songs(), Artists(), Albums(), Playlists()];

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);

    return Scaffold(
      drawerEnableOpenDragGesture: songPlayerProvider.isPlayerExpand,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool isScreenScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                forceElevated: true,
                title: Text("Music"),
                leading: IconButton(
                  onPressed: () {
                    // Scaffold.of(context).openDrawer();
                    widget.globalKey.currentState.toggle(direction: InnerDrawerDirection.start);
                  },
                  icon: Icon(Icons.menu),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      print(AudioService.connected);
                      songQueryProvider.initSongSearch();
                      showSearch(context: context, delegate: Search());
                    },
                  ),
                ],
                bottom: TabBar(
                  controller: tabController,
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
          body: TabBarView(controller: tabController, children: _myTabs)),
      // drawer: MyDrawer(),
    );
  }
}
