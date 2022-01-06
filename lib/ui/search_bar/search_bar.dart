import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/singleton/music_player_service.dart';
import 'package:my_music/ui/main_screen/components/background_wallpaper.dart';
import 'package:my_music/ui/search_bar/component/result.dart';
import 'package:my_music/utils/utils.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  MusicPlayerService _musicPlayerService = MusicPlayerService();
  FocusNode? _focusNode;
  ValueNotifier<List<SongModel>> _suggestionSong = ValueNotifier([]);
  ValueNotifier<List<SongModel>> _suggestionArtist = ValueNotifier([]);
  ValueNotifier<String> _keyword = ValueNotifier("");

  @override
  void initState() {
    _focusNode = FocusNode();
    Future.delayed(Duration(milliseconds: 500), (){
      _focusNode?.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _focusNode = null;
    super.dispose();
  }

  Widget _header(String text){
    return Container(
      alignment: Alignment.center,
      height: 30,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: color4,
        borderRadius: BorderRadius.circular(15.0)
      ),
      margin: const EdgeInsets.only(
        top: 20,
        left: 20,
        bottom: 10
      ),
      child: Text(
        text,
        style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
          fontWeight: FontWeight.w900
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final songQuery = Provider.of<SongQueryProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: color2,
        title: TextField(
          cursorColor: Colors.white,
          focusNode: _focusNode,
          style: ThemeProvider.themeOf(context).data.textTheme.headline6,
          decoration: InputDecoration(
            hintText: "Search Song",
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintStyle: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
              color: Colors.grey[400]
            ),
          ),
          onChanged: (value){
            _suggestionSong.value = songQuery.songInfo
              .where((element) => element.title.toLowerCase().contains(value.toLowerCase())).toList();
            _suggestionArtist.value = songQuery.songInfo
              .where((element) => element.artist!.toLowerCase().contains(value.toLowerCase())).toList();
            _keyword.value = value;
          },
        ),
      ),
      body: Stack(
        children: <Widget> [
          BackgroundWallpaper(),
          Material(
            color: Colors.transparent,
            child: StreamBuilder<bool>(
              initialData: false,
              stream: _musicPlayerService.audioBackgroundRunningStream,
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  child: Container(
                    margin: snapshot.data!
                      ? const EdgeInsets.only(bottom: kMiniplayerMinHeight)
                      : EdgeInsets.zero,
                    child: ValueListenableBuilder<String>(
                      valueListenable: _keyword,
                      builder: (context, keyword, child) {
                        return Visibility(
                          visible: keyword.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              myAdBanner(context, "unitId"),
                              _header("Song"),
                              ResultSong(
                                suggestionNotifier: _suggestionSong,
                                focusNode: _focusNode!,
                              ),
                              _header("Artist"),
                              ResultArtist(
                                suggestionNotifier: _suggestionArtist,
                                focusNode: _focusNode!
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      )
    );
  }
}