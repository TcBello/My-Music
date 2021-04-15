import 'package:flutter/material.dart';
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
    final provider = Provider.of<SongModel>(context);

    return Scaffold(
      drawerEnableOpenDragGesture: provider.isPlayerExpand,
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
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      provider.initSongSearch();
                      showSearch(context: context, delegate: Search());
                    },
                  )
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
      drawer: MyDrawer(),
    );
  }
}
