import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/song_bottom_sheet_options.dart';
import 'package:my_music/ui/playlists/components/playlist_bottom_sheet_options.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/playlists/playlist_entity.dart';

void showSongBottomSheet(BuildContext context, SongModel songInfo) {
  showModalBottomSheet(
    useRootNavigator: true,
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

void showArtistBottomSheet(BuildContext context, ArtistModel artistInfo) {
  showModalBottomSheet(
    useRootNavigator: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        topLeft: Radius.circular(30.0)
      )
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
       return ArtistBottomSheetOptions(artistInfo: artistInfo,);
    }
  );
}

void showAlbumBottomSheet(BuildContext context, AlbumModel albumInfo) {
  showModalBottomSheet(
    useRootNavigator: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        topLeft: Radius.circular(30.0)
      )
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
       return AlbumBottomSheetOptions(albumInfo: albumInfo);
    }
  );
}

void showQueueBottomSheet(BuildContext context, SongModel songInfo, MediaItem mediaItem, int index){
  showModalBottomSheet(
    useRootNavigator: true,
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

void showPlaylistBottomSheet(BuildContext context, PlaylistEntity playlistInfo, index){
  showModalBottomSheet(
    useRootNavigator: true,
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