import 'package:flutter/material.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:provider/provider.dart';

class NowPlayingBuilder extends StatefulWidget {
  const NowPlayingBuilder({
    Key key,
  }) : super(key: key);

  @override
  _NowPlayingBuilderState createState() => _NowPlayingBuilderState();
}

class _NowPlayingBuilderState extends State<NowPlayingBuilder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<SongModel>(context);
    // print(provider.nowPlayingSongs.length);

    return Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: provider.nowPlayingSongs.length,
          itemBuilder: (context, index) => NowPlayingSongTile(
            songInfo: provider.nowPlayingSongs[index],
            onTap: () {
              provider.setIndex(index);
              provider.playSong(provider.nowPlayingSongs);
            },
          ),
          // itemBuilder: (context, index) => ListTile(
          //     tileColor: nowPlayingSong[index].title == songModel.audioItem.title
          // ? Colors.pinkAccent
          // : Colors.white,
          // onTap: () async {
          //   // songModel.setIndex(index);
          //   // songModel.playSong(songModel.nowPlayingSongs);
          //   print("PLAY STARTED!");
          //     },
          //     contentPadding: EdgeInsets.only(right: 0.5, left: 10.0),
          //     title: Text(
          //       nowPlayingSong[index].title,
          //       overflow: TextOverflow.ellipsis,
          //       style: nowPlayingSong[index].title == songModel.audioItem.title
          //           ? nowPlayingStyle(true)
          //           : nowPlayingStyle(false),
          //     ),
          //     subtitle: Text(
          //       nowPlayingSong[index].artist == "<unknown>"
          //           ? "Unknown Artist"
          //           : nowPlayingSong[index].artist,
          //       overflow: TextOverflow.ellipsis,
          //       style: nowPlayingSong[index].title == songModel.audioItem.title
          //           ? nowPlayingStyle(true)
          //           : nowPlayingStyle(false),
          //     ),
          //     trailing: IconButton(
          //       icon: Icon(
          //         Icons.more_vert,
          //         color: nowPlayingSong[index].title == songModel.audioItem.title
          // ? Colors.white
          // : Colors.black
          //       ),
          //       onPressed: () {
          //         showModalBottomSheet(
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.only(
          //                     topRight: Radius.circular(30.0),
          //                     topLeft: Radius.circular(30.0))),
          //             backgroundColor: Colors.white,
          //             context: context,
          //             builder: (context) {
          //               return Container(
          //                 height: 260,
          //                 child: Column(
          //                   mainAxisAlignment:
          //                       MainAxisAlignment.spaceEvenly,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Center(
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Column(
          //                           children: [
          //                             AutoSizeText(
          //                               nowPlayingSong[index].title,
          //                               style: headerBottomSheetTextStyle,
          //                               maxLines: 1,
          //                             ),
          //                             SizedBox(height: 5),
          //                             Divider(thickness: 1.0, color: Colors.grey)
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                     ListTile(
          //                       title: Text("Play Next"),
          //                       onTap: (){
          //                         songModel.playNextSong(songModel.nowPlayingSongs[index]);
          //                         Navigator.pop(context);
          //                       },
          //                     ),
          //                     ListTile(
          //                       title: Text("Add to Queue"),
          //                       onTap: (){
          //                         songModel.addToQueueSong(songModel.nowPlayingSongs[index]);
          //                         Navigator.pop(context);
          //                       },
          //                     ),
          //                     Consumer<SongModel>(
          //                       builder: (context, _songModel, child) {
          //                         return ListTile(
          //                           title: Text("Add to playlist"),
          //                           onTap: (){
          //                             Navigator.pop(context);
          //                             showPlaylistDialog(index);
          //                             },
          //                         );
          //                       }
          //                     ),
          //                   ],
          //                 ),
          //               );
          //             });
          //       },
          //     ),
          //   ),
        ));
  }
}
