import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/singleton/music_player_service.dart';
import 'package:my_music/ui/albums/albums.dart';
import 'package:my_music/ui/artists/artists.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/ui/playlists/playlists.dart';
import 'package:my_music/ui/search_bar/search_bar.dart';
import 'package:my_music/ui/songs/songs.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class MainUI extends StatefulWidget {
  const MainUI({
    required this.globalKey
  });

  final GlobalKey<InnerDrawerState> globalKey;
  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> with SingleTickerProviderStateMixin {
  final List<Widget> _myTabs = [Songs(), Artists(), Albums(), Playlists()];
  MusicPlayerService _musicPlayerService = MusicPlayerService();

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Provider.of<CustomThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text("My Music", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle?.copyWith(
          color: Color(customTheme.textHexColor)
        ),),
        leading: IconButton(
          onPressed: () {
            // TODO: TEMP COMMENT SHOW AD
            // showAd();
            widget.globalKey.currentState?.toggle(direction: InnerDrawerDirection.start);
          },
            icon: Icon(Icons.menu, color: Color(customTheme.textHexColor),),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Color(customTheme.textHexColor),),
            onPressed: () {
              // songQueryProvider.initSongSearch();
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBar()));
            },
          ),
        ],
        bottom: TabBar(
          unselectedLabelColor: Colors.grey[350],
          labelStyle: ThemeProvider.themeOf(context).data.tabBarTheme.labelStyle,
          unselectedLabelStyle: ThemeProvider.themeOf(context).data.tabBarTheme.unselectedLabelStyle,
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
      ),
      body: StreamBuilder<bool>(
        initialData: false,
        stream: _musicPlayerService.audioBackgroundRunningStream,
        builder: (context, snapshot) {
          return Container(
            margin: snapshot.data!
              ? const EdgeInsets.only(bottom: kMiniplayerMinHeight)
              : EdgeInsets.zero,
            child: TabBarView(controller: tabController, children: _myTabs),
          );
        }
      ),
      // body: NestedScrollView(
      //     controller: scrollController,
      //     headerSliverBuilder: (BuildContext context, bool isScreenScrolled) {
      //       return <Widget>[
      //         SliverAppBar(
      //           elevation: 0,
      //           backgroundColor: Colors.grey[900]?.withOpacity(0.5),
      //           forceElevated: true,
      //           snap: true,
      //           pinned: true,
      //           floating: true,
      //           title: Text("My Music", style: ThemeProvider.themeOf(context).data.appBarTheme.titleTextStyle,),
      //           leading: IconButton(
      //             onPressed: () {
      //               widget.globalKey.currentState?.toggle(direction: InnerDrawerDirection.start);
      //             },
      //             icon: Icon(Icons.menu),
      //           ),
      //           actions: <Widget>[
      //             IconButton(
      //               icon: Icon(Icons.search),
      //               onPressed: () {
      //                 print(AudioService.connected);
      //                 songQueryProvider.initSongSearch();
      //                 // showSearch(context: context, delegate: Search());
      //                 Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBar()));
      //               },
      //             ),
      //           ],
      //           bottom: TabBar(
      //             labelStyle: ThemeProvider.themeOf(context).data.tabBarTheme.labelStyle,
      //             unselectedLabelStyle: ThemeProvider.themeOf(context).data.tabBarTheme.unselectedLabelStyle,
      //             controller: tabController,
      //             indicatorColor: Colors.pinkAccent,
      //             tabs: <Widget>[
      //               Tab(
      //                 text: "Songs",
      //               ),
      //               Tab(
      //                 text: "Artists",
      //               ),
      //               Tab(
      //                 text: "Albums",
      //               ),
      //               Tab(
      //                 text: "Playlists",
      //               )
      //             ],
      //           ),
      //         )
      //       ];
      //     },
          // body: StreamBuilder<bool>(
          //   initialData: false,
          //   stream: songPlayer.backgroundRunningStream,
          //   builder: (context, snapshot) {
          //     return Container(
          //       margin: snapshot.data!
          //         ? const EdgeInsets.only(bottom: kMiniplayerMinHeight)
          //         : EdgeInsets.zero,
          //       child: TabBarView(controller: tabController, children: _myTabs),
          //     );
          //   }
          // )
      // ),
    );
  }
}
