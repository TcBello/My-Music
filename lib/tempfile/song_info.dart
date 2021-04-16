import 'package:flutter/material.dart';
import 'package:my_music/tempfile/image_album_edit.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/components/style.dart';
import 'package:provider/provider.dart';

class SongInfoEdit extends StatefulWidget {
  final String title;
  final int index;
  final bool isSong;
  final bool fromArtist;
  SongInfoEdit({Key key, this.title, this.index, this.isSong, this.fromArtist}) : super(key: key);

  @override
  _SongInfoEditState createState() => _SongInfoEditState();
}

class _SongInfoEditState extends State<SongInfoEdit> {

  bool checkBoxVal = false;

  Widget songInfoWidget(){
    return Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Consumer<SongModel>(
          builder: (context, song, child){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("    Song"),
                      SizedBox(width: 21.5,),
                      SizedBox(height: 30, width: 1, child: VerticalDivider(thickness: 1.0, color: Colors.grey[700],),),
                      SizedBox(width: 5,),
                      TextFormField(
                        initialValue:  widget.isSong ? song.songInfo[widget.index].title : !widget.fromArtist ? song.songInfoFromAlbum[widget.index].title : song.songInfoFromArtist[widget.index].title,
                      )
                    ],
                  ),
                ),
                Divider(color: Colors.grey[700], thickness: 1.0,),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("    Artist"),
                      SizedBox(width: 21,),
                      SizedBox(height: 30, width: 1, child: VerticalDivider(thickness: 1.0, color: Colors.grey[700],),),
                      SizedBox(width: 5,),
                      TextFormField(
                          initialValue: widget.isSong ? song.songInfo[widget.index].artist == "<unknown>" ? "Unknown Artist" : !widget.fromArtist ? song.songInfo[widget.index].artist :
                          song.songInfoFromAlbum[widget.index].artist ==  "<unknown>" ? "Unknown Artist" : song.songInfoFromAlbum[widget.index].artist
                              : song.songInfoFromArtist[widget.index].artist == "<unknown>" ? "Unknown Artist" : song.songInfoFromArtist[widget.index].artist
                      )
                    ],
                  ),
                ),
                Divider(thickness: 1.0, color: Colors.grey[700],),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("   Album"),
                      SizedBox(width: 15,),
                      SizedBox(height: 30, width: 1, child: VerticalDivider(thickness: 1.0, color: Colors.grey[700],),),
                      SizedBox(width: 5,),
                      TextFormField(
                        initialValue: widget.isSong ? song.songInfo[widget.index].album : !widget.fromArtist ? song.songInfoFromAlbum[widget.index].album : song.songInfoFromArtist[widget.index].album,
                      )
                    ],
                  ),
                ),
                Divider(thickness: 1.0, color: Colors.grey[700],)
              ],
            );
          },
        )
    );
  }

  Widget roundCheckBoxWidget(){
    return checkBoxVal ? Icon(
      Icons.check_circle,
      color: Colors.blue,
    ) : Icon(
      Icons.radio_button_unchecked,
      color: Colors.blue,
    );
  }

  Widget albumCoverWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text("Album Covers", style: TextStyle(color: Colors.black),),
          trailing: IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.grey[700],),
            onPressed: (){},
          ),
        ),
        Container(
          height: 100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<SongModel>(
                builder: (context, song, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10,),
                      Stack(
                        children: [
                          ImageAlbumEdit(widget.isSong ? song.songInfo[widget.index].albumArtwork : !widget.fromArtist ? song.songInfoFromAlbum[widget.index].albumArtwork : song.songInfoFromArtist[widget.index].albumArtwork), //TODO: NOT FINAL USE LIST OF WIDGET THEN MAP TO CUSTOMIZE ART
                          Positioned(
                            bottom: 1.0,
                            left: 12.0,
                            child: Text("CURRENT\nALBUM COVER", style: currentAlbumTextStyle, textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              checkBoxVal = !checkBoxVal;
                            });
                          },
                          child: Stack(
                            children: [
                              ImageAlbumEdit(widget.isSong ? song.songInfo[widget.index].albumArtwork : !widget.fromArtist ? song.songInfoFromAlbum[widget.index].albumArtwork : song.songInfoFromArtist[widget.index].albumArtwork,), //NOT FINAL USE LIST OF WIDGET THEN MAP TO CUSTOMIZE ART
                              Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child: roundCheckBoxWidget()
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
//    final _song = Provider.of<SongModel>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              tooltip: "Confirm changes",
              onPressed: (){},
            )
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              songInfoWidget(),
              albumCoverWidget(),
            ],
          ),
        )
    );
  }
}

