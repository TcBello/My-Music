import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_music/search.dart';
import 'package:my_music/song_info.dart';
import 'package:my_music/song_model.dart';
import 'package:my_music/style.dart';
import 'package:provider/provider.dart';

class LibrarySongPlaylist extends StatelessWidget {
  final int indexFromOutside;
  LibrarySongPlaylist(this.indexFromOutside);

  Widget _librarySongWidget() {
    return Consumer<SongModel>(
      builder: (context, song, child) {
        return ListBody(
          children: List.generate(
              song.songInfoFromPlaylist.length,
              (index) => ListTile(
                    onTap: () async {
                      song.setIndex(index);
                      song.playSong(song.songInfoFromPlaylist);
                    },
                    contentPadding: EdgeInsets.only(right: 0.5, left: 10.0),
                    title: Text(
                      song.songInfoFromPlaylist[index].title,
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
                                height: 260, //250 orig height
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
                                              song.songInfoFromPlaylist[index]
                                                  .title,
                                              style: headerBottomSheetTextStyle,
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 10),
                                            Divider(thickness: 1.0, color: Colors.grey)
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text("Play Next"),
                                      onTap: (){
                                        song.playNextSong(song.songInfoFromPlaylist[index]);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Add to Queue"),
                                      onTap: (){
                                        song.addToQueueSong(song.songInfoFromPlaylist[index]);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Remove from playlist"),
                                      onTap: () async {
                                        Navigator.pop(context);

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              title: Text("Remove from playlist"),
                                              content: Text("Are you sure you want to remove ${song.songInfoFromPlaylist[index].title} from this playlist?"),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Cancel", style: TextStyle(color: Colors.blue),),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                                FlatButton(
                                                  child: Text("Remove", style: TextStyle(color: Colors.blue),),
                                                  onPressed: () async {
                                                    await song.removeSongFromPlaylist(song.songInfoFromPlaylist[index], indexFromOutside);
                                                    await song.getSongFromPlaylist(indexFromOutside);
                                                    song.getDataSong().whenComplete(() => Navigator.pop(context));
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    // ListTile(
                                    //   title: Text("Edit"),
                                    //   onTap: (){
                                    //     Navigator.pop(context);
                                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => SongInfoEdit(title: song.songInfoFromPlaylist[index].title, index: index, isSong: false, fromArtist: true,)));
                                    //   },
                                    // )
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
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: AutoSizeText(
            song.playlistInfo[indexFromOutside].name,
            maxLines: 2,
            style: headerLibrarySongListTextStyle,
          ),
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
                // return song.albumInfo[indexFromOutside].albumArt != null
                //         ? Image.file(
                //             File(song.albumInfo[indexFromOutside].albumArt),
                //             fit: BoxFit.cover,
                //           )
                //         : Image.asset(
                //             "assets/imgs/defalbum.png",
                //             fit: BoxFit.cover,
                //           );
                return song.songInfoFromPlaylist.isNotEmpty
                    ? song.songInfoFromPlaylist[0].albumArtwork != null
                        ? Image.file(
                            File(song.songInfoFromPlaylist[0].albumArtwork),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/imgs/defalbum.png",
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
