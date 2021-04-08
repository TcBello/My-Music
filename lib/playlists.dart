import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/image_gridview.dart';
import 'package:my_music/library_song_playlist.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/style.dart';
import 'package:provider/provider.dart';

import 'library_song_album.dart';

class Playlists extends StatefulWidget {

  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  Widget _playlistBuilderWidget(){
    return Consumer<SongModel>(
      builder: (context, song, child){
        return Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 60),
              children: List.generate(song.playlistInfo.length, (index) => InkWell(
                onTap: () async{
                  await song.getSongFromPlaylist(index);
                  // Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySongList(indexFromOutside: index, isFromArtist: false, isFromPlaylist: true,)));
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => LibrarySongPlaylist(index)));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageGridAsset("defalbum.png"),
                      Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Container(child: Text(song.playlistInfo[index].name), width: MediaQuery.of(context).size.width, height: 20,)
                              ),
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text("${song.playlistInfo[index].memberIds.length} songs")
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 6, top: 7),
                                child: InkWell(
                                  onTap: (){
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
                                            height: 305,
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
                                                          song.playlistInfo[index].name,
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
                                                  title: Text("Play Playlist"),
                                                  onTap: () async {
                                                    await song.getSongFromPlaylist(index);
                                                    song.setIndex(0);
                                                    await song.playSong(song.songInfoFromPlaylist).whenComplete(() => Navigator.pop(context));
                                                  },
                                                ),
                                                ListTile(
                                                  title: Text("Play Next"),
                                                  onTap: () async {
                                                    song.getSongFromPlaylist(index).whenComplete((){
                                                      song.playNextPlaylist(song.songInfoFromPlaylist);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                ),
                                                ListTile(
                                                  title: Text("Add to Queue"),
                                                  onTap: (){
                                                    song.getSongFromPlaylist(index).whenComplete((){
                                                      song.addToQueuePlaylist(song.songInfoFromPlaylist);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                ),
                                                Consumer<SongModel>(
                                                    builder: (context, _songModel, child) {
                                                      return ListTile(
                                                        title: Text("Delete Playlist"),
                                                        onTap: () async {
                                                          Navigator.pop(context);
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                title: Text("Delete ${song.playlistInfo[index].name}"),
                                                                content: Text("Are you sure you want to delete this playlist?"),
                                                                actions: [
                                                                  FlatButton(
                                                                    child: Text("Cancel"),
                                                                    onPressed: () => Navigator.pop(context),
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text("Delete"),
                                                                    onPressed: () async {
                                                                      await song.deletePlaylist(index);
                                                                      await song.getDataSong().then((value){
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
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
                                  child: Icon(Icons.more_vert, color: Colors.grey[800],),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ))
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _playlistBuilderWidget();
  }
}

