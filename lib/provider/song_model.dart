// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_audio_query/flutter_audio_query.dart';
// // import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SongModel extends ChangeNotifier {
//   final FlutterAudioQuery flutterAudioQuery = FlutterAudioQuery();

//   // FlutterSoundHelper _flutterSoundHelper = FlutterSoundHelper();
//   // FlutterSoundHelper get flutterSoundHelper => _flutterSoundHelper;

//   // FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
//   // FlutterSoundPlayer get audioPlayer => _audioPlayer;

//   // StreamController _streamController = StreamController.broadcast();
//   // StreamController get streamController => _streamController;

//   // List<SongInfo> _songinfo;
//   // List<SongInfo> get songInfo => _songinfo;

//   // List<SongInfo> _songInfoFromAlbum;
//   // List<SongInfo> get songInfoFromAlbum => _songInfoFromAlbum;

//   // List<SongInfo> _songInfoFromArtist;
//   // List<SongInfo> get songInfoFromArtist => _songInfoFromArtist;

//   // List<SongInfo> _songInfoFromPlaylist;
//   // List<SongInfo> get songInfoFromPlaylist => _songInfoFromPlaylist;

//   // List<ArtistInfo> _artistInfo;
//   // List<ArtistInfo> get artistInfo => _artistInfo;

//   // List<AlbumInfo> _albumInfo;
//   // List<AlbumInfo> get albumInfo => _albumInfo;

//   // List<AlbumInfo> _albumFromArtist;
//   // List<AlbumInfo> get albumFromArtist => _albumFromArtist;

//   // List<PlaylistInfo> _playlistInfo;
//   // List<PlaylistInfo> get playlistInfo => _playlistInfo;

//   // List<SongInfo> _nowPlayingSongs;
//   // List<SongInfo> get nowPlayingSongs => _nowPlayingSongs;

//   // final List stringSongs = [];

//   // StreamSubscription<PlaybackDisposition> _playerStream;
//   String currentPosition = "00:00";
//   String songDuration = "00:00";
//   double maxDuration = 1.0;
//   double minDuration = 0.0;
//   double sliderValue;

//   // StreamController<String> _bgStreamController = StreamController<String>();
//   // Stream<String> get _bgStream => _streamController.stream;
//   String backgroundFilePath = "";
//   String defaultBgPath = "assets/imgs/starry.jpg";
//   String defAlbum = "/data/user/0/com.tcbello.my_music/app_flutter/defalbum.png";
//   String repeatModeMessage = "";
//   int textHexColor = 4294967295;
//   int textHexColor2 = 4294967295;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//   double blurValue = 0.0;

//   int index = 0;
//   int currentRepeatMode = 0;
//   double dragSliderValue = 0.0;
//   // SongInfo get audioItem => _nowPlayingSongs[index];
//   // bool get hasNext => index + 1 < _nowPlayingSongs.length;
//   bool get hasPrev => index > 0;
//   bool isPlayOnce = false;
//   bool isPlaying = false;
//   // bool isPlayerExpand = false;
//   // bool isConvertToStringOnce = true;
//   bool isRepeatAll = true;
//   bool isRepeatOne = false;
//   bool isShuffle = false;
//   bool isDrag = false;


//   Icon playPauseMiniPlayer = Icon(Icons.pause, color: Colors.pinkAccent,);
//   Icon playPausePlayer = Icon(Icons.pause, color: Colors.white, size: 60,);

//   List<Icon> repeatIcons = [
//     Icon(
//       Icons.repeat,
//       color: Colors.white,
//       size: 40,
//     ),
//     Icon(
//       Icons.repeat_one,
//       color: Colors.white,
//       size: 40,
//     ),
//     Icon(
//       Icons.shuffle,
//       color: Colors.white,
//       size: 40,
//     ),
//   ];
  

//   // Track get track => Track(
//   //   trackPath: audioItem.filePath,
//   //   trackTitle: audioItem.title,
//   //   trackAuthor: audioItem.artist == '<unknown>' ? "Unknown Artist" : audioItem.artist,
//   //   albumArtFile: audioItem.albumArtwork != null ? audioItem.albumArtwork : defAlbum,
//   // );

//   Stream<String> backgroundStream() async*{
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     final _currentBg = _prefs.getString('currentbg');
//     if(_currentBg == null){
//       yield* Stream.value(defaultBgPath);
//     }
//     else{
//       backgroundFilePath = _currentBg;
//     }

//     yield* Stream.value(backgroundFilePath);
//   }

//   Future<void> updateBG(String bgPath, double blurValue) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     await _prefs.setString('currentbg', bgPath);
//     await _prefs.setDouble('currentblur', blurValue);
//   }

//   Future<void> getCurrentBackground() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     final _currentBG = _prefs.getString('currentbg');
//     final _currentBlur = _prefs.getDouble('currentblur');

//     if(_currentBG == null){
//       backgroundFilePath = defaultBgPath;
//       blurValue = 0.0;
//     }
//     else{
//       backgroundFilePath = _currentBG;
//       blurValue = _currentBlur;
//     }

//     if(_currentBlur == null){
//       blurValue = 0.0;
//     }
//     else{
//       blurValue = _currentBlur;
//     }
//   }

//   void setDefaultAlbumArt() async {
//     final Directory dir = await getApplicationDocumentsDirectory();
//     String dirPath = dir.path;
//     String filePath = "$dirPath/defalbum.png";
//     File file = File(filePath);
//     bool isExist = await file.exists();

//     if(!isExist){
//       ByteData byteData = await rootBundle.load('assets/imgs/defalbum.png');
//       file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//       notifyListeners();
//     }
//   }

//   // Future<void> getDataSong() async {
//   //   _songinfo = await flutterAudioQuery.getSongs();
//   //   _artistInfo = await flutterAudioQuery.getArtists();
//   //   _albumInfo = await flutterAudioQuery.getAlbums();
//   //   _playlistInfo = await flutterAudioQuery.getPlaylists();
//   //   print("GET DATA SONGS FROM FILES COMPLETED!");

//   //   notifyListeners();
//   // }

//   // Future<void> createPlaylist(String name, SongInfo songInfo) async {
//   //   await FlutterAudioQuery.createPlaylist(playlistName: name);
//   //   await getDataSong();

//   //   _playlistInfo.forEach((element) {
//   //     if(element.name == name){
//   //       element.addSong(song: songInfo);
//   //     }
//   //   });
//   // }

//   // Future<void> addSongToPlaylist(SongInfo song, int index) async {
//   //   await _playlistInfo[index].addSong(song: song);
//   // }

//   // Future<void> removeSongPlaylist(SongInfo song, int index) async {
//   //   await _playlistInfo[index].removeSong(song: song);
//   // }

//   // Future<void> updatePlaylist() async {
//   //   _playlistInfo = await flutterAudioQuery.getPlaylists();
//   // }

//   // Future<void> deletePlaylist(int index) async {
//   //   await FlutterAudioQuery.removePlaylist(playlist: _playlistInfo[index]);
//   // }

//   // Future<void> removeSongFromPlaylist(SongInfo song, int index) async {
//   //   await _playlistInfo[index].removeSong(song: song);
//   // }

//   // Future<void> getSongFromAlbum(String id) async {
//   //   _songInfoFromAlbum = await flutterAudioQuery.getSongsFromAlbum(albumId: id);
//   //   print("GET SONGS FROM ALBUM COMPLETED!");

//   //   notifyListeners();
//   // }

//   // Future<void> getSongFromArtist(String artist, String id) async{
//   //   _songInfoFromArtist = await flutterAudioQuery.getSongsFromArtistAlbum(artist: artist, albumId: id);
//   //   print("GET SONGS FROM ARTIST ALBUM COMPLETED!");
//   // }

//   // Future<void> getAlbumFromArtist(String name) async {
//   //   _albumFromArtist = await flutterAudioQuery.getAlbumsFromArtist(artist: name);
//   //   print("GET ALBUM FROM ARTIST COMPLETED!");

//   //   notifyListeners();
//   // }

//   // Future<void> getSongFromPlaylist(int index) async {
//   //   _songInfoFromPlaylist = await flutterAudioQuery.getSongsFromPlaylist(playlist: _playlistInfo[index]);
//   // }

//   // void setIndex(int i) {
//   //   index = i;

//   //   notifyListeners();
//   // }

//   // Future<void> myPlayer() async {
//   //   print("START PLAYER");
//   //   await _audioPlayer.closeAudioSession();
//   //   await _audioPlayer.openAudioSession(
//   //     focus: AudioFocus.requestFocusAndStopOthers,
//   //     mode: SessionMode.modeDefault,
//   //     device: AudioDevice.speaker,
//   //     category: SessionCategory.playback,
//   //     withUI: true
//   //   );
//   //   await _audioPlayer.setSubscriptionDuration(Duration(milliseconds: 10));

//   //   notifyListeners();
//   // }

//   // Future<void> playSong() async {
//   //   if(isPlayOnce && isPlaying == false){
//   //     _playerStream.resume();
//   //   }
//   //   print("SONG PLAY");
//   //   isPlaying = true;
//   //   isPlayOnce = true;
//   //   isPlayAllSongs = true;
//   //   isSpecificSongs = false;
//   //   playPause = Icon(Icons.pause, color: Colors.pinkAccent,);
//   //   playPause2 = Icon(Icons.pause, color: Colors.white, size: 60,);
//   //   await  _audioPlayer.startPlayerFromTrack(
//   //     track,
//   //     whenFinished: _whenFinished,
//   //     onPaused: (bool pause) async {
//   //       if(pause){
//   //         await _audioPlayer.pausePlayer();
//   //         isPlaying = false;
//   //       }
//   //       else{
//   //         await _audioPlayer.resumePlayer();
//   //         isPlaying = true;
//   //       }
//   //     },
//   //     onSkipBackward: onSkipPrev,
//   //     onSkipForward: onSkipNext,
//   //     duration: null,
//   //   );

//   //   notifyListeners();
//   // }

//   // Future<void> playSong(List<SongInfo> songList) async {
//   //   _nowPlayingSongs = List.from(songList);

//   //   if(isPlayOnce && isPlaying == false){
//   //     _playerStream.resume();
//   //   }
//   //   print("SONG PLAY");
//   //   isPlaying = true;
//   //   isPlayOnce = true;
//   //   playPause = Icon(Icons.pause, color: Colors.pinkAccent,);
//   //   playPause2 = Icon(Icons.pause, color: Colors.white, size: 60,);
//   //   await  _audioPlayer.startPlayerFromTrack(
//   //     track,
//   //     whenFinished: _whenFinished,
//   //     onPaused: (bool pause) async {
//   //       if(pause){
//   //         await _audioPlayer.pausePlayer();
//   //         isPlaying = false;
//   //       }
//   //       else{
//   //         await _audioPlayer.resumePlayer();
//   //         isPlaying = true;
//   //       }
//   //     },
//   //     onSkipBackward: onSkipPrev,
//   //     onSkipForward: onSkipNext,
//   //     duration: null,
//   //   );

//   //   notifyListeners();
//   // }

//   // onStreamDuration(){
//   //   if(_playerStream != null){
//   //     _playerStream.cancel();
//   //     _playerStream = null;
//   //   }

//   //   _playerStream = _audioPlayer.onProgress.listen((event) {
//   //     if(event != null){
//   //       _streamController.add(maxDuration = event.duration.inMilliseconds.toDouble());
//   //       _streamController.add(minDuration = event.position.inMilliseconds.toDouble());
//   //       _streamController.add(currentPosition = event.position.toString().substring(0, 7));
//   //       _streamController.add(songDuration = event.duration.toString().substring(0, 7));

//   //       if(maxDuration <= 0){
//   //         maxDuration = 0;
//   //       }
//   //     }
//   //   });
//   // }
//   // onStreamDuration(){
//   //   _playerStream = _audioPlayer.onProgress.listen((event) { 
//   //     if(event != null){
//   //       duration = event.duration;
//   //       position = event.position;
//   //       maxDuration = event.duration.inMilliseconds.toDouble();
//   //       minDuration = event.position.inMilliseconds.toDouble();
//   //     }
//   //   });
//   // }

//   // onStreamDurationCancel(){
//   //   _playerStream.cancel();
//   // }

//   // Future<void> disposeMyPlayer() async {
//   //   print("DISPOSE PLAYER");
//   //   isPlayOnce = false;
//   //   // _streamController.close();
//   //   if(_playerStream != null){
//   //     _playerStream.cancel();
//   //     _playerStream = null;
//   //   }
//   //   try{
//   //     await _audioPlayer.closeAudioSession();
//   //   }catch(e){
//   //     print(e);
//   //     print("DISPOSE FAILED!");
//   //   }

//   //   notifyListeners();
//   // }

//   // Future<void> _whenFinished() async {
//   //   // if(hasNext){
//   //   //   print("NEXT SONG!");
//   //   //   index += 1;
//   //   //   playSong();
//   //   // }
//   //   // else{
//   //   //   isPlaying = false;
//   //   //   await _audioPlayer.stopPlayer();
//   //   //   playPause = Icon(Icons.pause, color: Colors.pinkAccent,);
//   //   //   playPause2 = Icon(Icons.pause, color: Colors.white, size: 60,);
//   //   //   print("NO NEXT SONG!!!!");
//   //   // }
//   //   switch(currentRepeatMode){
//   //     case 0:
//   //       if(!hasNext){
//   //         index = 0;
//   //         playSong(_nowPlayingSongs);
//   //       }
//   //       else{
//   //         index += 1;
//   //         playSong(_nowPlayingSongs);
//   //       }
//   //       break;
//   //     case 1:
//   //       playSong(_nowPlayingSongs);
//   //       break;
//   //     case 2:
//   //       index = Random().nextInt(_songinfo.length);
//   //       playSong(_nowPlayingSongs);
//   //       break;
//   //   }
//   //   notifyListeners();
//   // }

//   // Future<void> onSkipPrev() async {
//   //   if(hasPrev){
//   //     print("SKIP PREV!!!");
//   //     index -= 1;
//   //     //stopPlayer();
//   //     playSong(_nowPlayingSongs);
//   //   }
//   //   else{
//   //     print("SKIP PREV FAILED!!!!");
//   //     return;
//   //   }
//   // }

//   // Future<void> onSkipNext() async {
//   //   if(hasNext){
//   //     print("SKIP NEXT!!!!!!");
//   //     index += 1;
//   //     //stopPlayer();
//   //     playSong(_nowPlayingSongs);
//   //   }
//   //   else{
//   //     print("SKIP NEXT FAILED!!");
//   //     return;
//   //   }
//   // }

//   // Future<void> stopPlayer() async {
//   //   try{
//   //     await _audioPlayer.stopPlayer();
//   //     if(_playerStream != null){
//   //       _playerStream.cancel();
//   //       _playerStream = null;
//   //     }
//   //   }catch(e){
//   //     print("ERROR\n$e");
//   //   }
//   // }

//   // Future<void> onPauseResume() async {
//   //   if(isPlaying){
//   //     isPlaying = false;
//   //     await _audioPlayer.pausePlayer();
//   //     playPause = Icon(Icons.play_arrow, color: Colors.pinkAccent,);
//   //     playPause2 = Icon(Icons.play_arrow, color: Colors.white, size: 60,);
//   //     // _playerStream.pause();
//   //   }
//   //   else{
//   //     isPlaying = true;
//   //     await _audioPlayer.resumePlayer();
//   //     playPause = Icon(Icons.pause, color: Colors.pinkAccent,);
//   //     playPause2 = Icon(Icons.pause, color: Colors.white, size: 60,);
//   //     // _playerStream.resume();
//   //   }


//   //   notifyListeners();
//   // }

//   // Future<void> onResume() async {
//   //   isPlaying = true;
//   //   await _audioPlayer.resumePlayer();
//   //   playPause = Icon(Icons.pause);

//   //   notifyListeners();
//   // }

//   // Future<void> seekPlayer(double duration) async {
//   //   int x = duration.toInt();
//   //   // if(isPlaying == false){
//   //   //   //._playerStream.resume();
//   //   //   onPauseResume();
//   //   // }
//   //   // if(isPlaying == true){
//   //   //   playPause = Icon(Icons.pause, color: Colors.pinkAccent,);
//   //   //   playPause2 = Icon(Icons.pause, color: Colors.white, size: 60,);
//   //   //   _audioPlayer.pausePlayer();
//   //   //   isPlaying = false;
//   //   // }
//   //   // await _audioPlayer.seekToPlayer(Duration(milliseconds: x));

//   //   if(_audioPlayer.isPaused){
//   //     playPause = Icon(Icons.play_arrow, color: Colors.pinkAccent,);
//   //     playPause2 = Icon(Icons.play_arrow, color: Colors.white, size: 60,);
//   //   }

//   //   if(_audioPlayer.isPlaying){
//   //     await _audioPlayer.seekToPlayer(Duration(milliseconds: x));
//   //   }
//   //   // await _audioPlayer.seekToPlayer(Duration(milliseconds: x));
    
//   //   // await _audioPlayer.pausePlayer();
//   //   // try{
//   //   //   if(_audioPlayer.isPlaying){
//   //   //     await _audioPlayer.seekToPlayer(Duration(milliseconds: x)).then((value) async {
//   //   //       await _audioPlayer.pausePlayer();
//   //   //     });
//   //   //     playPause = Icon(Icons.pause, color: Colors.pinkAccent,);
//   //   //     playPause2 = Icon(Icons.pause, color: Colors.white, size: 60,);
//   //   //   }
//   //   //   if(_audioPlayer.isPaused){
//   //   //     await _audioPlayer.seekToPlayer(Duration(milliseconds: x)).then((value) async {
//   //   //       await _audioPlayer.pausePlayer();
//   //   //     });
//   //       // playPause = Icon(Icons.play_arrow, color: Colors.pinkAccent,);
//   //       // playPause2 = Icon(Icons.play_arrow, color: Colors.white, size: 60,);
//   //   //   }
//   //   // }catch(e){
//   //   //   print(e);
//   //   // }
//   //   notifyListeners();
//   // }

//   // void setSpecificTrack(List<SongInfo> list){
//   //   _specificSongInfo = List.from(list);
//   //   notifyListeners();
//   // }

//   Future<void> changeTextColor(int hex) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     await _prefs.setInt('textcolor', hex);
//   }

//   Future<void> getCurrentTextColor() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     int color = _prefs.getInt('textcolor');
//     if(color == null){
//       textHexColor = 4294967295;
//     }
//     else{
//       textHexColor = color;
//     }
//   }

//   Future<void> changeTextColor2(int hex) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     await _prefs.setInt('textcolor2', hex);
//   }

//   Future<void> getCurrentTextColor2() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     int color = _prefs.getInt('textcolor2');
//     if(color == null){
//       textHexColor2 = 4294967295;
//     }
//     else{
//       textHexColor2 = color;
//     }
//   }

//   void changeRepeatMode(){
//     // if(currentRepeatMode <= 1){
//     //   currentRepeatMode += 1;
//     // }
//     // else{
//     //   currentRepeatMode = 0;
//     // }
//     currentRepeatMode += 1;

//     if(currentRepeatMode > 2){
//       currentRepeatMode = 0;
//     }

//     switch(currentRepeatMode){
//       case 0:
//         isRepeatAll = true;
//         isRepeatOne = false;
//         isShuffle = false;
//         repeatModeMessage = "Current playlist is looped";
//         break;
//       case 1:
//         isRepeatAll = false;
//         isRepeatOne = true;
//         isShuffle = false;
//         repeatModeMessage = "Current song is looped";
//         break;
//       case 2:
//         isRepeatAll = false;
//         isRepeatOne = false;
//         isShuffle = true;
//         repeatModeMessage = "Playlist is shuffled";
//         break;
//       // case 3:
//       //   currentRepeatMode = 0;
//       //   break;
//       // default:
//       //   currentRepeatMode = 0;
//     }

//     notifyListeners();
//   }

//   Future<void> resetTheme() async {
//     await updateBG('assets/imgs/starry.jpg', 0.0);
//     await changeTextColor(4294967295);
//     await getCurrentBackground();
//     await getCurrentTextColor();
//   }

//   // void playNextSong(SongInfo song){
//   //   int nextIndex = index + 1;
//   //   _nowPlayingSongs.insert(nextIndex, song);
//   //   notifyListeners();
//   // }

//   // void addToQueueSong(SongInfo song){
//   //   int lastIndex = _nowPlayingSongs.length;
//   //   _nowPlayingSongs.insert(lastIndex, song);
//   //   notifyListeners(); 
//   // }

//   // void playNextPlaylist(List<SongInfo> playlistSong){
//   //   int nextIndex = index + 1;
//   //   _nowPlayingSongs.insertAll(nextIndex, playlistSong);
//   //   notifyListeners();
//   // }

//   // void addToQueuePlaylist(List<SongInfo> playlistSong){
//   //   int lastIndex = _nowPlayingSongs.length;
//   //   _nowPlayingSongs.insertAll(lastIndex, playlistSong);
//   //   notifyListeners();
//   // }

//   void dismissMiniPlayer(){
//     isPlayOnce = false;
//     notifyListeners();
//   }

//   void setDragBool(bool value){
//     isDrag = value;
//     notifyListeners();
//   }

//   void setDragSliderValue(double value){
//     dragSliderValue = value;
//     notifyListeners();
//   }

//   // void setPlayerExpandBool(bool value){
//   //   isPlayerExpand = value;
//   //   notifyListeners();
//   // }

//   // void initSongSearch(){
//   //   if (isConvertToStringOnce) {
//   //     songInfo.forEach((element) {
//   //       stringSongs.add(element.title);
//   //     });
//   //     isConvertToStringOnce = false;

//   //     notifyListeners();
//   //   }
//   // }
// }
