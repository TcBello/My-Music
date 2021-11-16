import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/main.dart';
import 'package:my_music/model/audio_queue_data.dart';
import 'package:my_music/singleton/music_player_service.dart';
import 'package:my_music/utils/utils.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/song_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class SongPlayerProvider extends ChangeNotifier{
  MusicPlayerService _musicPlayerService = MusicPlayerService();
  List<MediaItem> songList = [];
  String _tempDir = "";
  String _appDir = "";
  String _defaultAlbum() => "$_appDir/defalbum.png";
  String songArtwork(int id) => "$_tempDir/$id";
  int _minuteTimer = 0;

  void init() async{
    var tempDir = await getTemporaryDirectory();
    var appDir = await getApplicationDocumentsDirectory();
    _tempDir = tempDir.path;
    _appDir = appDir.path;
  }

  Icon playPauseMiniPlayerIcon(bool isPlaying){
    return isPlaying
      ? Icon(Icons.pause, color: Colors.white,)
      : Icon(Icons.play_arrow, color: Colors.white,);
  }

  Icon playPausePlayerIcon(bool isPlaying){
    return isPlaying
      ? Icon(Icons.pause, color: Colors.white, size: 60,)
      : Icon(Icons.play_arrow, color: Colors.white, size: 60,);
  }

  int _repeatIndex = 0;
  int _shuffleIndex = 0;

  List<Icon> _repeatIcons(Color bodyColor) => [
    // OFF
    Icon(
      Icons.repeat,
      color: Colors.grey[300],
      size: 40,
    ),
    // ON
    Icon(
      Icons.repeat_on_rounded,
      color: bodyColor,
      size: 40,
    ),
    Icon(
      Icons.repeat_one_on_rounded,
      color: bodyColor,
      size: 40,
    ),
  ];

  List<Icon> _shuffleIcons(Color bodyColor) => [
    // OFF
    Icon(
      Icons.shuffle,
      color: Colors.grey[300],
      size: 40,
    ),
    // ON
    Icon(
      Icons.shuffle_on_rounded,
      color: bodyColor,
      size: 40,
    ),
  ];
  
  Icon currentRepeatIcon(Color bodyColor) => _repeatIcons(bodyColor)[_repeatIndex];
  Icon currentShuffleIcon(Color bodyColor) => _shuffleIcons(bodyColor)[_shuffleIndex];

  Icon shuffleIcon(AudioServiceShuffleMode mode){
    switch(mode){  
      case AudioServiceShuffleMode.none:
        return Icon(
          Icons.shuffle,
          color: Colors.grey[300],
          size: 40,
        );
      case AudioServiceShuffleMode.all:
        return Icon(
          Icons.shuffle,
          color: Colors.white,
          size: 40,
        );
      case AudioServiceShuffleMode.group:
        return Icon(
          Icons.shuffle,
          color: Colors.white,
          size: 40,
        );
      default:
        return Icon(
          Icons.shuffle,
          color: Colors.grey[300],
          size: 40,
        );
    }
  }

  Icon repeatIcon(AudioServiceRepeatMode repeatMode, Color bodyColor){
    switch(repeatMode){
      case AudioServiceRepeatMode.none:
        return Icon(
          Icons.repeat,
          color: Colors.grey[300],
          size: 40,
        );
      case AudioServiceRepeatMode.one:
        return Icon(
          Icons.repeat_one_on_rounded,
          color: bodyColor,
          size: 40,
        );
      case AudioServiceRepeatMode.all:
        return Icon(
          Icons.repeat_on_rounded,
          color: bodyColor,
          size: 40,
        );
      case AudioServiceRepeatMode.group:
        return Icon(
          Icons.repeat_on_rounded,
          color: bodyColor,
          size: 40,
        );
    }
  }

  Stream<MediaItem?> get audioItemStream => audioHandler.mediaItem;
  // Stream<PlaybackState> get playbackStream => audioHandler.playbackState;
  Stream get indexStream => audioHandler.customEvent;

  // bool _isPlayOnce = false;
  // bool get isPlayOnce => _isPlayOnce;

  ValueNotifier<bool> _isPlayOnce = ValueNotifier(false);
  ValueNotifier<bool> get isPlayOnce => _isPlayOnce;

  Stream<Duration> get positionStream => AudioService.position;

  bool get _isBackgroundRunning => _musicPlayerService.isAudioBackgroundRunning;
  AudioProcessingState get processingState => audioHandler.playbackState.value.processingState;
  Stream<PlaybackState> get playbackStateStream => audioHandler.playbackState;

  void playSong(List<SongModel> songInfoList, int index) async{
    _convertToMediaItemList(songInfoList);

    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      audioHandler.customAction("setIndex", {'index': index});
      audioHandler.customAction("setAudioSourceMode", {'audioSourceMode': 0});
      audioHandler.updateQueue(songList);

      audioHandler.play();

      if(!_isPlayOnce.value){
        _isPlayOnce.value = true;
        notifyListeners();
      }
    });
  }

  void playPlaylistSong(List<SongEntity> songEntityList, int index) async{
    _convertEntityToMediaItemList(songEntityList);

    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      audioHandler.customAction("setIndex", {'index': index});
      audioHandler.customAction("setAudioSourceMode", {'audioSourceMode': 0});
      audioHandler.updateQueue(songList);

      audioHandler.play();

      if(!_isPlayOnce.value){
        _isPlayOnce.value = true;
        notifyListeners();
      }
    });
  }

  void playQueueSong(int index, List<MediaItem> queue){
    audioHandler.customAction("setIndex", {'index': index});
    audioHandler.customAction("setAudioSourceMode", {'audioSourceMode': 0});
    audioHandler.updateQueue(queue);
    audioHandler.play();
  }

  void stopSong() => audioHandler.stop();

  void skipNext() => audioHandler.skipToNext();

  void skipPrevious() => audioHandler.skipToPrevious();

  void seek(Duration position) async => audioHandler.seek(position);

  void pauseResume() async{
    if(await audioHandler.customAction("isPlaying")){
      audioHandler.pause();
    }
    else{
      audioHandler.play();
    }

    notifyListeners();
  }

  void _convertToMediaItemList(List<SongModel> songInfoList){
    songList = songInfoList.map((e){
      bool hasArtWork = File(songArtwork(e.id)).existsSync();
      // final songArtwork1 = e.albumArtwork;
      final songArtwork2 = songArtwork(e.id);
      String artist = e.artist! != kDefaultArtistName
        ? e.artist!
        : "Unknown Artist";

      return MediaItem(
        id: e.data,
        title: e.title,
        artist: artist,
        album: e.album!,
        // artUri: isSdk28Below
        //   ? songArtwork1 != null
        //     ? File(songArtwork1).uri
        //     : File(_defaultAlbum).uri
        //   : hasArtWork
        //     ? File(songArtwork2).uri
        //     : File(_defaultAlbum).uri,
        artUri: hasArtWork
          ? File(songArtwork2).uri
          : File(_defaultAlbum()).uri,
        duration: Duration(milliseconds: e.duration!),
      );
    }).toList();

    notifyListeners();
  }

  void _convertEntityToMediaItemList(List<SongEntity> songEntityList){
    songList = songEntityList.map((e){
      bool hasArtWork = File(songArtwork(e.id)).existsSync();
      // final songArtwork1 = e.albumArtwork;
      final songArtwork2 = songArtwork(e.id);
      String artist = e.artist! != kDefaultArtistName
        ? e.artist!
        : "Unknown Artist";

      return MediaItem(
        id: e.lastData,
        title: e.title,
        artist: artist,
        album: e.album!,
        // artUri: isSdk28Below
        //   ? songArtwork1 != null
        //     ? File(songArtwork1).uri
        //     : File(_defaultAlbum).uri
        //   : hasArtWork
        //     ? File(songArtwork2).uri
        //     : File(_defaultAlbum).uri,
        artUri: hasArtWork
          ? File(songArtwork2).uri
          : File(_defaultAlbum()).uri,
        duration: Duration(milliseconds: e.duration!),
      );
    }).toList();

    notifyListeners();
  }

  void dismissMiniPlayer(){
    // _isPlayOnce = false;
    _isPlayOnce.value = false;
    // notifyListeners();
    audioHandler.stop();
  }

  void openEqualizer() async{
    if(_isBackgroundRunning){
      int id = await audioHandler.customAction("getAudioSessionId");
      Equalizer.open(id);
    }
    else{
      Equalizer.open(0);
    }
  }

  void setRepeatMode(){
    _repeatIndex += 1;

    if(_repeatIndex >= 3){
      _repeatIndex = 0;
    }
    notifyListeners();

    switch(_repeatIndex){
      case 0:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        showShortToast("Repeat off");
        break;
      case 1:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        showShortToast("Repeat on");
        break;
      case 2:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        showShortToast("Repeat single song");
        break;
    }
  }

  void setShuffleMode() async{
    _shuffleIndex += 1;

    if(_shuffleIndex >= 2){
      _shuffleIndex = 0;
    }

    notifyListeners();

    switch(_shuffleIndex){
      case 0:
        audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
        showShortToast("Shuffle off");
        break;
      case 1:
        audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
        showShortToast("Shuffle on");
        break;
    }
  }

  Future<int> getCurrentIndex() async{
    audioHandler.customAction("initIndex");
    int index = (await audioHandler.customAction("getCurrentIndex")) - 1;
    return index;
  }

  int getQueueLength(){
    return audioHandler.queue.value.length;
  }

  void setTimer(){
    if(_isBackgroundRunning){
      audioHandler.customAction("setTimer", {'value': _minuteTimer});
      if(_minuteTimer != 0){
        showShortToast("Music will stop at $_minuteTimer minutes");
      }
      else if(_minuteTimer == 1){
        showShortToast("Music will stop at $_minuteTimer minutes");
      }
      else{
        showShortToast("Music will not stop");
      }
    }
    else{
      showShortToast("Playing queue not found");
    }
  }

  void selectTimerItem(int minute){
    _minuteTimer = minute;
  }

  void resetTimer(){
    _minuteTimer = 0;
  }

  // Stream<AudioQueueData> nowPlayingStream(){
  //   return Rx.combineLatest2<List<MediaItem>?, dynamic, AudioQueueData>(
  //     audioHandler.queue,
  //     audioHandler.customEvent,
  //     (queue, index) => AudioQueueData(
  //       queue: queue,
  //       index: index
  //     )
  //   );
  // }

  Stream<AudioQueueData> nowPlayingStream(){
    return Rx.combineLatest2<List<MediaItem>?, PlaybackState, AudioQueueData>(
      audioHandler.queue,
      audioHandler.playbackState,
      (queue, playbackState) => AudioQueueData(
        queue: queue,
        index: playbackState.queueIndex!
      )
    );
  }
}