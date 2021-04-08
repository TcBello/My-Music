

import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/song_info.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends SearchDelegate<SongInfo>{
  final recent = [];
  TextEditingController _getText = TextEditingController();

  @override
  buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.mic, color: Colors.grey[700],),
        onPressed: (){},
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.grey[700],),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var _songModel = Provider.of<SongModel>(context);
    final _song = context.select((SongModel s) => s.songInfo);
    final _songSearchList = _song.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
    print(_songSearchList);
    // TODO: FIX ALL FUNCTIONALITIES
    void showPlaylistDialog(int index){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                    await _songModel.addSongToPlaylist(_songSearchList[index], playlistIndex);
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
        )
    );
  }
    Widget _backgroundWidget(){
      return Consumer<SongModel>(
        builder: (context, x, snapshot) {
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
                    )
          );
        }
      );
    }

    Widget _songListBuilder(){
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 40,
                    left: 20,
                    bottom: 10
                ),
                child: Text("Songs", style: headerSearchResult,),
              ),
              Consumer<SongModel>(
                builder: (context, song, child){
                  return ListBody(
                    children: List.generate(_songSearchList.length, (index) => ListTile(
                      contentPadding: EdgeInsets.only(
                          right: 0.5,
                          left: 10.0
                      ),
                      title: Text(
                        _songSearchList[index].title,
                        style: musicTextStyle(song.textHexColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _songSearchList[index].artist == "<unknown>"
                            ? "Unknown Artist"
                            : _songSearchList[index].artist,
                        style: artistMusicTextStyle(song.textHexColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert, color: Color(song.textHexColor)),
                        onPressed: (){
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(30.0)
                                  )
                              ),
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context){
                                return Container(
                                  height: 260,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              AutoSizeText(
                                                _songSearchList[index].title,
                                                style: headerBottomSheetTextStyle,
                                                maxLines: 1,
                                              ),
                                              SizedBox(height: 10),
                                              Divider(thickness: 1.0, color: Colors.grey,)
                                            ],
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text("Play Next"),
                                        onTap: (){
                                          _songModel.playNextSong(_songSearchList[index]);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text("Add to Queue"),
                                        onTap: (){
                                          _songModel.addToQueueSong(_songSearchList[index]);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Consumer<SongModel>(
                                        builder: (context, _songModel, child) {
                                          return ListTile(
                                            title: Text("Add to playlist"),
                                            onTap: (){
                                              Navigator.pop(context);
                                              showPlaylistDialog(index);
                                              },
                                          );
                                        }
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                      ),
                      onTap: () async {
                        song.setIndex(index);
                        await song.playSong(_songSearchList);
                        print("PLAY STARTED!");
                      },
                    )),
                  );
                },
              )
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
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
        _songListBuilder()
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _model = context.select((SongModel s) => s.stringSongs);
    final _suggestionList = query.isEmpty ? recent : _model.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: _suggestionList.length,
      itemBuilder: (context, index){
        return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.music_note, color: Colors.white,),
            ),
            onTap: (){
              query = _suggestionList[index];
              showResults(context);
            },
            title: Text(_suggestionList[index])
        );
      },
    );
  }
}