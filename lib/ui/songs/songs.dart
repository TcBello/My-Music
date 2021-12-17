import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/controller.dart';
import 'package:my_music/components/data_placeholder.dart';
import 'package:my_music/components/song_tile.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_player.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:my_music/utils/utils.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class Songs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final songPlayerProvider = Provider.of<SongPlayerProvider>(context);
    final songQueryProvider = Provider.of<SongQueryProvider>(context);

    return songQueryProvider.songInfo.length > 0
      ? RepaintBoundary(
        child: DraggableScrollbar.semicircle(
          controller: songScrollController!,
          backgroundColor: color3,
          labelTextBuilder: (offset){
            final int currentItem = (offset - 60.0) ~/ 72;
        
            var letter = currentItem <= songQueryProvider.songInfo.length - 1
              ? songQueryProvider.songInfo[currentItem].title.substring(0, 1).toUpperCase()
              : songQueryProvider.songInfo.last.title.substring(0, 1).toUpperCase();
            return Text(
              letter,
              style: ThemeProvider.themeOf(context).data.textTheme.headline6?.copyWith(
                fontSize: 30
              ),
            );
          },
          labelConstraints: BoxConstraints(
            maxHeight: 80,
            maxWidth: 80
          ),
          child: ListView(
            controller: songScrollController,
            padding: EdgeInsets.zero,
            children: [
              Visibility(
                visible: MobileAds.isInitialized,
                child: myAdBanner(context, "unitId"),
              ),
              Column(
                children: List.generate(songQueryProvider.songInfo.length, (index) => SongTile(
                  songInfo: songQueryProvider.songInfo[index],
                  onTap: (){
                    songPlayerProvider.playSong(songQueryProvider.songInfo, index);
                  },
                )),
              )
            ],
          ),
        ),
      )
      : DataPlaceholder(
        text: "Song is empty",
      );
  }
}