import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:device_info/device_info.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_music/components/audio_player_task/audio_player_task.dart';
import 'package:my_music/main.dart';

class SongPlayerProvider extends ChangeNotifier{
  List<MediaItem> songList = [];
  int _currentAudioSessionID = 0;
  final String _defaultAlbum = "/data/user/0/com.tcbello.my_music/app_flutter/defalbum.png";
  String artWork(String id) => "/data/user/0/com.tcbello.my_music/cache/$id.png";
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

  int _initPlayerIndex = 0;
  int get initPlayerIndex => _initPlayerIndex;

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

  Icon shuffleIcon(AudioServiceShuffleMode mode){
    switch(mode){  
      case AudioServiceShuffleMode.none:
        return Icon(
          Icons.shuffle,
          color: Colors.grey,
          size: 40,
        );
        break;
      case AudioServiceShuffleMode.all:
        return Icon(
          Icons.shuffle,
          color: Colors.white,
          size: 40,
        );
        break;
      case AudioServiceShuffleMode.group:
        return Icon(
          Icons.shuffle,
          color: Colors.white,
          size: 40,
        );
        break;
    }
  }

  Stream<MediaItem> get audioItemStream => AudioService.currentMediaItemStream;
  Stream<bool> get backgroundRunningStream => AudioService.runningStream;
  Stream get indexStream => AudioService.customEventStream;

  bool _isPlayOnce = false;
  bool get isPlayOnce => _isPlayOnce;

  bool _isPlayerExpand = false;
  bool get isPlayerExpand => _isPlayerExpand;

  Stream<Duration> get positionStream => AudioService.positionStream;
  Stream<bool> get isPlayingStream => AudioPlayerTask().audioPlayer.playingStream;

  bool get isBackgroundRunning => AudioService.running;
  AudioProcessingState get processingState => AudioService.playbackState.processingState;
  Stream<PlaybackState> get playbackStateStream => AudioService.playbackStateStream;

  void playSong(List<SongInfo> songInfoList, int index, int sdkInt) async{
    _convertToMediaItemList(songInfoList, sdkInt);

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

    await AudioService.play();

    int id = await AudioService.customAction("getAudioSessionId");
    if(_currentAudioSessionID != id){
      _currentAudioSessionID = id;
      notifyListeners();
      print("EQUALIZER AUD ID: $id");
      Equalizer.setAudioSessionId(id);
    }

    if(!_isPlayOnce){
      _isPlayOnce = true;
      notifyListeners();
    }

    // playPauseMiniPlayerIcon = Icon(Icons.pause, color: Colors.pinkAccent,);
    // playPausePlayerIcon = Icon(Icons.pause, color: Colors.white, size: 60,);

    // notifyListeners();
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
    }
    else{
      AudioService.play();
    }

    notifyListeners();
  }

  void _convertToMediaItemList(List<SongInfo> songInfoList, int sdkInt){
    final isSdk28Below = sdkInt < 29;

    songList = songInfoList.map((e){
      bool hasArtWork = File(artWork(e.albumId)).existsSync();
      final songArtwork = e.albumArtwork;

      return MediaItem(
        id: e.filePath,
        title: e.title,
        artist: e.artist != "<unknown>"
          ? e.artist
          : "Unknown Artist",
        album: e.album,
        artUri: isSdk28Below
          ? songArtwork != null
            ? File(songArtwork).uri
            : File(_defaultAlbum).uri
          : hasArtWork
            ? File(artWork(e.albumId)).uri
            : File(_defaultAlbum).uri,
        duration: Duration(milliseconds: int.parse(e.duration)),
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
    // AudioService.customAction("setShuffle");

    switch(_shuffleIndex){
      case 0:
        AudioService.setShuffleMode(AudioServiceShuffleMode.none);
        // _shuffleIndex = 0;
        break;
      case 1:
        AudioService.setShuffleMode(AudioServiceShuffleMode.all);
        // _shuffleIndex = 1;
        break;
    }

    // notifyListeners();
  }

  void setPlayerExpandBool(bool value){
    _isPlayerExpand = value;
    notifyListeners();
  }

  Future<void> defaultModes() async{
    _repeatIndex = 0;
    _shuffleIndex = 0;
    // bool isPlaying = await AudioService.customAction("isPlaying");
    // print("ISPLAYING: $isPlaying");

    // if(isPlaying){
    //   int id = await AudioService.customAction("getAudioSessionId");
    //   Equalizer.init(id);
    //   Equalizer.setEnabled(true);
    //   Equalizer.setAudioSessionId(id);
    //   print("ISPLAYING: $isPlaying\nID: $id");
    // }

    // Future.delayed(Duration(seconds: 1), () async {
    //   bool isPlaying = await AudioService.customAction("isPlaying");
    //   print("ISPLAYING: $isPlaying");

    //   if(isPlaying){
    //     int id = await AudioService.customAction("getAudioSessionId");
    //     Equalizer.init(id);
    //     Equalizer.setEnabled(true);
    //     Equalizer.setAudioSessionId(id);
    //     print("ISPLAYING: $isPlaying\nID: $id");
    //   }
    // });

    // notifyListeners();
  }

  Future<void> initIndex() async{
    AudioService.customAction("initIndex");
    _initPlayerIndex = (await AudioService.customAction("getCurrentIndex")) - 1;
    notifyListeners();
  }

  void setTimer(){
    if(AudioService.running){
      AudioService.customAction("setTimer", _minuteTimer);
      Fluttertoast.showToast(
        msg: "Music will stop at $_minuteTimer minutes",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  void selectTimerItem(int minute){
    _minuteTimer = minute;
  }
}