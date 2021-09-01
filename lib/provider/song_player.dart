import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/audio_player_task/audio_player_task.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/model/audio_queue_data.dart';
import 'package:my_music/utils/utils.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/song_entity.dart';
import 'package:rxdart/rxdart.dart';

class SongPlayerProvider extends ChangeNotifier{
  List<MediaItem> songList = [];
  final String _defaultAlbum = "/data/user/0/com.tcbello.my_music/app_flutter/defalbum.png";
  String songArtwork(int id) => "/data/user/0/com.tcbello.my_music/cache/$id";
  int _minuteTimer = 0;

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

  Stream<MediaItem?> get audioItemStream => AudioService.currentMediaItemStream;
  Stream<bool> get backgroundRunningStream => AudioService.runningStream;
  Stream get indexStream => AudioService.customEventStream;

  bool _isPlayOnce = false;
  bool get isPlayOnce => _isPlayOnce;

  Stream<Duration> get positionStream => AudioService.positionStream;

  bool get isBackgroundRunning => AudioService.running;
  AudioProcessingState get processingState => AudioService.playbackState.processingState;
  Stream<PlaybackState> get playbackStateStream => AudioService.playbackStateStream;

  void playSong(List<SongModel> songInfoList, int index) async{
    _convertToMediaItemList(songInfoList);

    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      if(!AudioService.running){
        _repeatIndex = 0;
        _shuffleIndex = 0;
        await AudioService.start(
          backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
          androidStopForegroundOnPause: true
        );
      }

      AudioService.customAction("setIndex", index);
      AudioService.customAction("setAudioSourceMode", 0);
      AudioService.updateQueue(songList);

      AudioService.play();

      if(!_isPlayOnce){
        _isPlayOnce = true;
        notifyListeners();
      }
    });
  }

  void playPlaylistSong(List<SongEntity> songEntityList, int index) async{
    _convertEntityToMediaItemList(songEntityList);

    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      if(!AudioService.running){
        _repeatIndex = 0;
        _shuffleIndex = 0;
        await AudioService.start(
          backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
          androidStopForegroundOnPause: true
        );
      }

      AudioService.customAction("setIndex", index);
      AudioService.customAction("setAudioSourceMode", 0);
      AudioService.updateQueue(songList);

      AudioService.play();

      if(!_isPlayOnce){
        _isPlayOnce = true;
        notifyListeners();
      }
    });
  }

  void playQueueSong(int index, List<MediaItem> queue){
    AudioService.customAction("setIndex", index);
    AudioService.customAction("setAudioSourceMode", 0);
    AudioService.updateQueue(queue);
    AudioService.play();
  }

  void stopSong() => AudioService.stop();

  void skipNext() => AudioService.skipToNext();

  void skipPrevious() => AudioService.skipToPrevious();

  void seek(Duration position) async => AudioService.seekTo(position);

  void pauseResume() async{
    if(await AudioService.customAction("isPlaying")){
      AudioService.pause();
    }
    else{
      AudioService.play();
    }

    notifyListeners();
  }

  void _convertToMediaItemList(List<SongModel> songInfoList){
    songList = songInfoList.map((e){
      bool hasArtWork = File(songArtwork(e.id)).existsSync();
      // final songArtwork1 = e.albumArtwork;
      final songArtwork2 = songArtwork(e.id);

      return MediaItem(
        id: e.data,
        title: e.title,
        artist: e.artist,
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
          : File(_defaultAlbum).uri,
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

      return MediaItem(
        id: e.lastData,
        title: e.title,
        artist: e.artist,
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
          : File(_defaultAlbum).uri,
        duration: Duration(milliseconds: e.duration!),
      );
    }).toList();

    notifyListeners();
  }

  void dismissMiniPlayer(){
    _isPlayOnce = false;
    AudioService.customAction("connectUI", AudioService.connected);
    AudioService.stop();
    notifyListeners();
  }

  void openEqualizer() async{
    if(AudioService.running){
      int id = await AudioService.customAction("getAudioSessionId");
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
        AudioService.setRepeatMode(AudioServiceRepeatMode.none);
        showShortToast("Repeat off");
        break;
      case 1:
        AudioService.setRepeatMode(AudioServiceRepeatMode.all);
        showShortToast("Repeat on");
        break;
      case 2:
        AudioService.setRepeatMode(AudioServiceRepeatMode.one);
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
        AudioService.setShuffleMode(AudioServiceShuffleMode.none);
        showShortToast("Shuffle off");
        break;
      case 1:
        AudioService.setShuffleMode(AudioServiceShuffleMode.all);
        showShortToast("Shuffle on");
        break;
    }
  }

  Future<int> getCurrentIndex() async{
    AudioService.customAction("initIndex");
    int index = (await AudioService.customAction("getCurrentIndex")) - 1;
    return index;
  }

  int getQueueLength(){
    return AudioService.queue!.length;
  }

  void setTimer(){
    if(AudioService.running){
      AudioService.customAction("setTimer", _minuteTimer);
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

  Stream<AudioQueueData> nowPlayingStream(){
    return Rx.combineLatest2<List<MediaItem>?, dynamic, AudioQueueData>(
      AudioService.queueStream,
      AudioService.customEventStream,
      (queue, index) => AudioQueueData(
        queue: queue,
        index: index
      )
    );
  }
}