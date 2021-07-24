import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/song_bottom_sheet_options.dart';
import 'package:my_music/ui/playlists/components/playlist_bottom_sheet_options.dart';

void showSongBottomSheet(BuildContext context, SongInfo songInfo) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        topLeft: Radius.circular(30.0)
      )
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
       return SongBottomSheetOptions(songInfo: songInfo,);
    }
  );
}

void showQueueBottomSheet(BuildContext context, SongInfo songInfo, MediaItem mediaItem, int index){
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        topLeft: Radius.circular(30.0)
      )
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
       return QueueBottomSheetOptions(songInfo: songInfo, mediaItem: mediaItem, index: index,);
    }
  );
}

void showPlaylistBottomSheet(BuildContext context, PlaylistInfo playlistInfo, index){
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        topLeft: Radius.circular(30.0)
      )
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
       return PlaylistBottomSheetOptions(
         playlistInfo: playlistInfo,
         index: index,
       );
    }
  );
}