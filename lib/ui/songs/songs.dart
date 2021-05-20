import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/provider/theme.dart';
import 'package:my_music/tempfile/song_info.dart';
import 'package:my_music/provider/song_model.dart';
import 'package:my_music/ui/songs/components/song_builder.dart';
import 'package:provider/provider.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> with TickerProviderStateMixin {
  ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = context.read<ThemeProvider>();
    _themeProvider.getCurrentTextColor();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongQueryProvider>(
      builder: (context, song, child) {
        return song.songInfo != null
            ? SongBuilder()
            : Container();
      },
    );
  }
}

// class PopupMenuLobby extends StatefulWidget {
//   final int index;
//   PopupMenuLobby({Key key, this.index}) : super(key: key);

//   @override
//   _PopupMenuLobbyState createState() => _PopupMenuLobbyState();
// }

// class _PopupMenuLobbyState extends State<PopupMenuLobby> {
//   final List<String> menu = ["Add to Playlist", "Edit", "Delete"];
//   SongModel _model;

//   @override
//   void initState() {
//     super.initState();
//     _model = context.read<SongModel>();
//   }

//   @override
//   void dispose(){
//     super.dispose();
//     _model.dispose();
//   }

//   Future<void> selectPopupMenu(String select) async {
//     if(select == menu[0]){
//       print("DO SOMETHING!");
//     }
//     // if(select == menu[1]){
//     //   Navigator.push(context, MaterialPageRoute(builder: (context) => SongInfoEdit(title: menu[1], index: widget.index,)));
//     // }
//     if(select == menu[2]){
//       return showDialog(
//           context: context,
//           builder: (BuildContext context){
//             return AlertDialog(
//               title: Text("Delete File"),
//               content: Text("Do you really want to delete this file?"),
//               actions: [
//                 FlatButton(
//                   child: Text("YES"),
//                   onPressed: () async {
//                     try{
//                       final file = File(_model.songInfo[widget.index].filePath);
//                       final exist = await file.exists();
//                       if(exist){
//                         await file.delete(recursive: true);
//                       }
//                       Navigator.pop(context);
//                       print("Delete Successful");
//                     }catch(e){
//                       print(e);
//                       print("Delete Failed");
//                     }
//                   },
//                 ),
//                 FlatButton(
//                   child: Text("NO"),
//                   onPressed: (){Navigator.pop(context);},
//                 )
//               ],
//             );
//           }
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       icon: Icon(Icons.more_vert, color: Colors.white,),
//       onSelected: selectPopupMenu,
//       itemBuilder: (context){
//         return menu.map((menu) => PopupMenuItem(
//           value: menu,
//           child: Center(child: Text(menu)),
//         )).toList();
//       },
//     );
//   }
// }
