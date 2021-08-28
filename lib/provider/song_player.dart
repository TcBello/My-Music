import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/audio_player_task/audio_player_task.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/model/audio_queue_data.dart';
import 'package:my_music/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class SongPlayerProvider extends ChangeNotifier{
  List<MediaItem> songList = [];
  final String _defaultAlbum = "/data/user/0/com.tcbello.my_music/app_flutter/defalbum.png";
  String songArtwork(String id) => "/data/user/0/com.tcbello.my_music/cache/$id";
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

  List<Icon> _repeatIcons = [
    // OFF
    Icon(
      Icons.repeat,
      color: Colors.grey[300],
      size: 40,
    ),
    // ON
    Icon(
      Icons.repeat,
      color: Colors.white,
      size: 40,
    ),
    Icon(
      Icons.repeat_one,
      color: Colors.white,
      size: 40,
    ),
  ];

  List<Icon> _shuffleIcons = [
    // OFF
    Icon(
      Icons.shuffle,
      color: Colors.grey[300],
      size: 40,
    ),
    // ON
    Icon(
      Icons.shuffle,
      color: Colors.white,
      size: 40,
    ),
  ];
  
  Icon get currentRepeatIcon => _repeatIcons[_repeatIndex];
  Icon get currentShuffleIcon => _shuffleIcons[_shuffleIndex];

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

  Stream<MediaItem?> get audioItemStream => AudioService.currentMediaItemStream;
  Stream<bool> get backgroundRunningStream => AudioService.runningStream;
  Stream get indexStream => AudioService.customEventStream;

  bool _isPlayOnce = false;
  bool get isPlayOnce => _isPlayOnce;

  Stream<Duration> get positionStream => AudioService.positionStream;

  bool get isBackgroundRunning => AudioService.running;
  AudioProcessingState get processingState => AudioService.playbackState.processingState;
  Stream<PlaybackState> get playbackStateStream => AudioService.playbackStateStream;

  void playSong(List<SongInfo> songInfoList, int index, int sdkInt) async{
    _convertToMediaItemList(songInfoList, sdkInt);

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

  void _convertToMediaItemList(List<SongInfo> songInfoList, int sdkInt){
    final isSdk28Below = sdkInt < 29;

    songList = songInfoList.map((e){
      bool hasArtWork = File(songArtwork(e.id)).existsSync();
      final songArtwork1 = e.albumArtwork;
      final songArtwork2 = songArtwork(e.id);

      return MediaItem(
        id: e.filePath!,
        title: e.title!,
        artist: e.artist,
        album: e.album!,
        artUri: isSdk28Below
          ? songArtwork1 != null
            ? File(songArtwork1).uri
            : File(_defaultAlbum).uri
          : hasArtWork
            ? File(songArtwork2).uri
            : File(_defaultAlbum).uri,
        duration: Duration(milliseconds: int.parse(e.duration!)),
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
    int id = await AudioService.customAction("getAudioSessionId");
    Equalizer.open(id);
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
        break;
      case 1:
        AudioService.setRepeatMode(AudioServiceRepeatMode.all);
        break;
      case 2:
        AudioService.setRepeatMode(AudioServiceRepeatMode.one);
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
        break;
      case 1:
        AudioService.setShuffleMode(AudioServiceShuffleMode.all);
        break;
    }
  }

  Future<void> defaultModes() async{
    _repeatIndex = 0;
    _shuffleIndex = 0;
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