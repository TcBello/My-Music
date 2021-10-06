import 'dart:io';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/bottom_sheet.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/data_placeholder.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/custom_theme.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/ui/library_song/library_song_playlist.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class Playlists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customTheme = Provider.of<CustomThemeProvider>(context);

    return Consumer<SongQueryProvider>(
      builder: (context, notifier, child){
        return notifier.playlistInfo!.length > 0
          ? DraggableScrollbar.semicircle(
            controller: playlistScrollController!,
            backgroundColor: color3,
            child: ListView.builder(
              controller: playlistScrollController,
              padding: EdgeInsets.zero,
              itemCount: notifier.playlistInfo!.length,
              itemBuilder: (context, index){
                final playlistName = notifier.playlistInfo![index].playlistName;
                final songNumber = notifier.playlistInfo![index].playlistSongs.length;
          
                return ListTile(
                  contentPadding: const EdgeInsets.only(right: 0.5, left: 10.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(File(notifier.defaultAlbum), fit: BoxFit.cover,),
                  ),
                  title: Text(
                    playlistName,
                    style: ThemeProvider.themeOf(context).data.textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(customTheme.textHexColor)
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "$songNumber song",
                    style: ThemeProvider.themeOf(context).data.textTheme.subtitle2?.copyWith(
                      color: Color(customTheme.textHexColor)
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    color: Color(customTheme.textHexColor),
                    onPressed: (){
                      showPlaylistBottomSheet(context, notifier.playlistInfo![index], index);
                    },
                  ),
                  onTap: () async{
                    var playlistEntity = await notifier.getSongFromPlaylist(notifier.playlistInfo![index].key);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LibrarySongPlaylist(
                      indexFromOutside: index,
                      playlistEntity: playlistEntity!,
                    )));
                  }
                );
              },
            ),
          )
        : DataPlaceholder(
          text: "Playlist is empty",
        );
      },
    );
  }
}

