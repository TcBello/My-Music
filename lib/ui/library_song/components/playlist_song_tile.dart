import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class PlaylistSongTile extends StatefulWidget {
  const PlaylistSongTile({this.songInfo, this.onTap, this.index});

  final SongInfo songInfo;
  final Function onTap;
  final int index;

  @override
  _PlaylistSongTileState createState() => _PlaylistSongTileState();
}

class _PlaylistSongTileState extends State<PlaylistSongTile> {
  @override
  Widget build(BuildContext context) {
    final songQueryProvider = Provider.of<SongQueryProvider>(context);
    final songTitle = widget.songInfo.title;
    
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
      title: Container(
        padding: EdgeInsets.only(right: 8.0),
        child: Text(
          songTitle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert, color: Colors.black),
        onPressed: () {
          // showSongBottomSheet(context, widget.songInfo);
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
                                              songTitle,
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
                                        songQueryProvider.playNextSong(widget.songInfo);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Add to Queue"),
                                      onTap: (){
                                        songQueryProvider.addToQueueSong(widget.songInfo);
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
                                              content: Text("Are you sure you want to remove $songTitle from this playlist?"),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Cancel", style: TextStyle(color: Colors.blue),),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                                FlatButton(
                                                  child: Text("Remove", style: TextStyle(color: Colors.blue),),
                                                  onPressed: () async {
                                                    await songQueryProvider.removeSongFromPlaylist(widget.songInfo, widget.index);
                                                    await songQueryProvider.getSongFromPlaylist(widget.index);
                                                    songQueryProvider.getSongs().whenComplete(() => Navigator.pop(context));
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
      onTap: widget.onTap
    );
  }
}