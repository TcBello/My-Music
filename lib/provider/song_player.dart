import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/audio_player_task/audio_player_task.dart';
import 'package:my_music/main.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongPlayerProvider extends ChangeNotifier{
  List<MediaItem> songList = [];
  final String _defaultAlbum = "/data/user/0/com.tcbello.my_music/app_flutter/defalbum.png";

  Icon playPauseMiniPlayerIcon = Icon(Icons.pause, color: Colors.pinkAccent,);
  Icon playPausePlayerIcon = Icon(Icons.pause, color: Colors.white, size: 60,);

  int _repeatIndex = 0;
  int _shuffleIndex = 0;

  List<Icon> _repeatIcons = [
    // OFF
    Icon(
      Icons.repeat,
      color: Colors.grey,
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
      color: Colors.grey,
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

  Stream<MediaItem> get audioItemStream => AudioService.currentMediaItemStream;
  Stream<bool> get backgroundRunningStream => AudioService.runningStream;

  bool _isPlayOnce = false;
  bool get isPlayOnce => _isPlayOnce;

  bool _isPlayerExpand = false;
  bool get isPlayerExpand => _isPlayerExpand;

  Stream<Duration> get positionStream => AudioService.positionStream;
  Stream<bool> get isPlayingStream => AudioPlayerTask().audioPlayer.playingStream;

  bool get isBackgroundRunning => AudioService.running;
  AudioProcessingState get processingState => AudioService.playbackState.processingState;

  void playSong(List<SongInfo> songInfoList, int index) async{
    _convertToMediaItemList(songInfoList);

    if(!AudioService.running){
      await AudioService.start(backgroundTaskEntrypoint: audioPlayerTaskEntrypoint);
    }

    AudioService.customAction("setIndex", index);
    AudioService.customAction("setAudioSourceMode", 0);
    AudioService.updateQueue(songList);

    AudioService.play();

    if(!_isPlayOnce){
      _isPlayOnce = true;
    }

    notifyListeners();
  }

  void stopSong(){
    AudioService.stop();
  }

  void skipNext(){
    AudioService.skipToNext();
  }

  void skipPrevious(){
    AudioService.skipToPrevious();
  }

  void seek(Duration position) async{
    AudioService.seekTo(position);
  }

  void pauseResume() async{
    if(await AudioService.customAction("isPlaying")){
      AudioService.pause();
      playPauseMiniPlayerIcon = Icon(Icons.play_arrow, color: Colors.pinkAccent,);
      playPausePlayerIcon = Icon(Icons.play_arrow, color: Colors.white, size: 60,);
    }
    else{
      AudioService.play();
      playPauseMiniPlayerIcon = Icon(Icons.pause, color: Colors.pinkAccent,);
      playPausePlayerIcon = Icon(Icons.pause, color: Colors.white, size: 60,);
    }

    notifyListeners();
  }

  void _convertToMediaItemList(List<SongInfo> songInfoList){
    songList = songInfoList.map((e) => MediaItem(
      id: e.filePath,
      title: e.title,
      artist: e.artist != "<unknown>"
        ? e.artist
        : "Unknown Artist",
      album: e.album,
      artUri: e.albumArtwork != null
        ? File(e.albumArtwork).uri
        : File(_defaultAlbum).uri,
      duration: Duration(milliseconds: int.parse(e.duration)),
    )).toList();

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

    notifyListeners();
  }

  void setShuffleMode(){
    _shuffleIndex += 1;

    if(_shuffleIndex >= 2){
      _shuffleIndex = 0;
    }

    switch(_shuffleIndex){
      case 0:
        AudioService.setShuffleMode(AudioServiceShuffleMode.none);
        break;
      case 1:
        AudioService.setShuffleMode(AudioServiceShuffleMode.all);
        break;
    }

    notifyListeners();
  }

  void setPlayerExpandBool(bool value){
    _isPlayerExpand = value;
    notifyListeners();
  }
}