import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/search.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/style.dart';
import 'package:provider/provider.dart';

class LibrarySongAlbum extends StatefulWidget {
  final int indexFromOutside;
  LibrarySongAlbum(this.indexFromOutside);

  @override
  _LibrarySongAlbumState createState() => _LibrarySongAlbumState();
}

class _LibrarySongAlbumState extends State<LibrarySongAlbum> {
  TextEditingController _getText = TextEditingController();
  SongModel _songModel;

  @override
  void initState(){
    super.initState();
    _songModel = context.read<SongModel>();
  }

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
                    await _songModel.addSongToPlaylist(_songModel.songInfoFromAlbum[index], playlistIndex);
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
  
  Widget _librarySongWidget() {
    return Consumer<SongModel>(
      builder: (context, song, child) {
        return ListBody(
          children: List.generate(
              song.songInfoFromAlbum.length,
              (index) => ListTile(
                    onTap: () async {
                      song.setIndex(index);
                      await song.playSong(song.songInfoFromAlbum);
                    },
                    contentPadding: EdgeInsets.only(right: 0.5, left: 10.0),
                    title: Text(
                      song.songInfoFromAlbum[index].title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    topLeft: Radius.circular(30.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 260,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            AutoSizeText(
                                              song.songInfoFromAlbum[index].title,
                                              style: headerBottomSheetTextStyle,
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 10,),
                                            Divider(thickness: 1.0, color: Colors.grey,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text("Play Next"),
                                      onTap: (){
                                        song.playNextSong(song.songInfoFromAlbum[index]);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Add to Queue"),
                                      onTap: (){
                                        song.addToQueueSong(song.songInfoFromAlbum[index]);
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
                            });
                      },
                    ),
                  )),
        );
      },
    );
  }

  Widget _headerWidget() {
    return Consumer<SongModel>(builder: (context, song, child) {
      return Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 65, left: 15, right: 15),
                child: AutoSizeText(
                  song.albumInfo[widget.indexFromOutside].title,
                  maxLines: 2,
                  style: headerLibrarySongListTextStyle,
                ),
              ),
            ),
            Positioned.fill(
              top: 40,
              child: ListTile(
                title: Text(
                  song.albumInfo[widget.indexFromOutside].artist != null
                      ? song.albumInfo[widget.indexFromOutside].artist
                      : "",
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                    "${song.albumInfo[widget.indexFromOutside].numberOfSongs} song"),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                ),
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, isBoxScreenScrolled) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            forceElevated: true,
            actions: [
              Consumer<SongModel>(builder: (context, song, child) {
                return IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (song.isConvertToStringOnce) {
                      song.songInfo.forEach((element) {
                        song.stringSongs.add(element.title);
                      });
                      print(song.stringSongs);
                      song.isConvertToStringOnce = false;
                    }
                    showSearch(context: context, delegate: Search());
                  },
                );
              })
            ],
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(background: Consumer<SongModel>(
              builder: (context, song, child) {
                // TODO: FIX ALBUM ART FROM PLAYLIST
                return song.albumInfo[widget.indexFromOutside].albumArt != null
                    ? Image.file(
                        File(song.albumInfo[widget.indexFromOutside].albumArt),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/imgs/defalbum.png",
                        fit: BoxFit.cover,
                      );
              },
            )),
          ),
        ];
      },
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_headerWidget(), _librarySongWidget()],
          )),
    ));
  }
}
