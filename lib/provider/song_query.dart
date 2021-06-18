import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:my_music/components/audio_player_task/audio_player_task.dart';
import 'package:my_music/main.dart';
import 'package:path_provider/path_provider.dart';

class SongQueryProvider extends ChangeNotifier{
  final FlutterAudioQuery flutterAudioQuery = FlutterAudioQuery();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String artWork(String id) => "/data/user/0/com.tcbello.my_music/cache/$id.png";

  Future<String> artistArtwork(String name) async {
    final albumInfo = await flutterAudioQuery.getAlbumsFromArtist(artist: name);
    if(albumInfo.length != null || albumInfo.length != 0){
      try{
        return "/data/user/0/com.tcbello.my_music/cache/${albumInfo[0].id}.png";
      }
      catch(e){
        return "/data/user/0/com.tcbello.my_music/cache/no_artwork";
      }
    }
    return "/data/user/0/com.tcbello.my_music/cache/no_artwork";
  }

  bool isConvertToStringOnce = false;

  AndroidDeviceInfo _androidDeviceInfo;
  AndroidDeviceInfo get androidDeviceInfo => _androidDeviceInfo;

  final String _defaultAlbum = "/data/user/0/com.tcbello.my_music/app_flutter/defalbum.png";
  String get defaultAlbum => _defaultAlbum;

  List<SongInfo> _songInfo;
  List<SongInfo> get songInfo => _songInfo;

  List<SongInfo> _songInfoFromAlbum;
  List<SongInfo> get songInfoFromAlbum => _songInfoFromAlbum;

  List<SongInfo> _songInfoFromArtist;
  List<SongInfo> get songInfoFromArtist => _songInfoFromArtist;

  List<SongInfo> _songInfoFromPlaylist;
  List<SongInfo> get songInfoFromPlaylist => _songInfoFromPlaylist;

  List<ArtistInfo> _artistInfo;
  List<ArtistInfo> get artistInfo => _artistInfo;

  List<AlbumInfo> _albumInfo;
  List<AlbumInfo> get albumInfo => _albumInfo;

  List<AlbumInfo> _albumFromArtist;
  List<AlbumInfo> get albumFromArtist => _albumFromArtist;

  List<PlaylistInfo> _playlistInfo;
  List<PlaylistInfo> get playlistInfo => _playlistInfo;

  List<SongInfo> _currentQueue = [];
  List<SongInfo> get currentQueue => _currentQueue;

  final List stringSongs = [];
  
  List<String> _artistArtWorkList = [];
  List<String> get artistArtworkList => _artistArtWorkList;

  double _searchProgress = 0.0;
  double get searchProgress => _searchProgress;

  String _locationSongSearch = "";
  String get locationSongSearch => _locationSongSearch;

  Future<File> validatorFile() async {
    Directory dir = await getTemporaryDirectory();
    return File("${dir.path}/validate");
  }

  Future<void> getSongs() async {
    _androidDeviceInfo = await deviceInfo.androidInfo;
    
    _songInfo = await flutterAudioQuery.getSongs();
    _artistInfo = await flutterAudioQuery.getArtists();
    _albumInfo = await flutterAudioQuery.getAlbums();
    _playlistInfo = await flutterAudioQuery.getPlaylists();

    _artistInfo.forEach((element) async {
      final artWorkPath = await artistArtwork(element.name);
      _artistArtWorkList.add(artWorkPath);
    });
    print("GET DATA SONGS FROM FILES COMPLETED!");
    
    getAlbumArts();
    notifyListeners();
  }

  Future<void> createPlaylist(String name, SongInfo songInfo) async {
    var newPlaylist = await FlutterAudioQuery.createPlaylist(playlistName: name);
    newPlaylist.addSong(song: songInfo);
    await getSongs();

    // _playlistInfo.forEach((element) {
    //   if(element.name == name){
    //     element.addSong(song: songInfo);
    //   }
    // });
  }

  Future<void> addSongToPlaylist(SongInfo song, int index) async {
    await _playlistInfo[index].addSong(song: song);
  }

  Future<void> removeSongPlaylist(SongInfo song, int index) async {
    await _playlistInfo[index].removeSong(song: song);
  }

  Future<void> updatePlaylist() async {
    _playlistInfo = await flutterAudioQuery.getPlaylists();
  }

  Future<void> deletePlaylist(int index) async {
    await FlutterAudioQuery.removePlaylist(playlist: _playlistInfo[index]);
  }

  Future<void> removeSongFromPlaylist(SongInfo song, int index) async {
    await _playlistInfo[index].removeSong(song: song);
  }

  Future<void> getSongFromAlbum(String id) async {
    _songInfoFromAlbum = await flutterAudioQuery.getSongsFromAlbum(albumId: id);
    print("GET SONGS FROM ALBUM COMPLETED!");

    notifyListeners();
  }

  Future<void> getSongFromArtist(String artist, String id) async{
    _songInfoFromArtist = await flutterAudioQuery.getSongsFromArtistAlbum(artist: artist, albumId: id);
    print("GET SONGS FROM ARTIST ALBUM COMPLETED!");
  }

  Future<void> getAlbumFromArtist(String name) async {
    _albumFromArtist = await flutterAudioQuery.getAlbumsFromArtist(artist: name);
    print("GET ALBUM FROM ARTIST COMPLETED!");

    notifyListeners();
  }

  Future<void> getSongFromPlaylist(int index) async {
    _songInfoFromPlaylist = await flutterAudioQuery.getSongsFromPlaylist(playlist: _playlistInfo[index]);
    notifyListeners();
  }

  void playNextSong(SongInfo nextSongInfo) async{
    MediaItem mediaItem = _convertToMediaItem(nextSongInfo);
    int nextIndex = await AudioService.customAction("getCurrentIndex");
    AudioService.addQueueItemAt(mediaItem, nextIndex);

    _currentQueue.insert(nextIndex, nextSongInfo);

    notifyListeners();
  }

  void addToQueueSong(SongInfo addToQueueSongInfo){
    MediaItem mediaItem = _convertToMediaItem(addToQueueSongInfo);
    AudioService.addQueueItem(mediaItem);

    _currentQueue.add(addToQueueSongInfo);

    notifyListeners();
  }

  void playNextPlaylist(List<SongInfo> songInfoList) async{
    List<MediaItem> mediaList = _convertToMediaItemList(songInfoList);

    AudioService.customAction("setAudioSourceMode", 1);
    AudioService.updateQueue(mediaList);

    int nextIndex = await AudioService.customAction("getCurrentIndex");
    _currentQueue.insertAll(nextIndex, songInfoList);

    notifyListeners();
  }

  void addToQueuePlaylist(List<SongInfo> songInfoList){
    List<MediaItem> mediaList = _convertToMediaItemList(songInfoList);

    AudioService.customAction("setAudioSourceMode", 2);
    AudioService.updateQueue(mediaList);

    _currentQueue.addAll(songInfoList);

    notifyListeners();
  }

  List<MediaItem> _convertToMediaItemList(List<SongInfo> songInfoList){
    return songInfoList.map((e){
      bool hasArtWork = File(artWork(e.albumId)).existsSync();

      return MediaItem(
        id: e.filePath,
        title: e.title,
        artist: e.artist != "<unknown>"
          ? e.artist
          : "Unknown Artist",
        album: e.album,
        // artUri: e.albumArtwork != null
        //   ? File(e.albumArtwork).uri
        //   : File(_defaultAlbum).uri,
        // artUri: File(artWork(e.albumId)).uri,
        artUri: hasArtWork
          ? File(artWork(e.albumId)).uri
          : File(_defaultAlbum).uri,
        duration: Duration(milliseconds: int.parse(e.duration))
      );
    }).toList();
  }

  MediaItem _convertToMediaItem(SongInfo newSongInfo){
    bool hasArtWork = File(artWork(newSongInfo.albumId)).existsSync();

    return MediaItem(
      id: newSongInfo.filePath,
      title: newSongInfo.title,
      artist: newSongInfo.artist != "<unknown>"
        ? newSongInfo.artist
        : "Unknown Artist",
      album: newSongInfo.album,
      // artUri: newSongInfo.albumArtwork != null
      //   ? File(newSongInfo.albumArtwork).uri
      //   : File(_defaultAlbum).uri,
      artUri: hasArtWork
        ? File(artWork(newSongInfo.albumId)).uri
        : File(_defaultAlbum).uri,
      duration: Duration(milliseconds: int.parse(newSongInfo.duration))
    );
  }

  void initSongSearch(){
    if (!isConvertToStringOnce) {
      songInfo.forEach((element) {
        stringSongs.add(element.title);
      });
      isConvertToStringOnce = true;

      notifyListeners();
    }
  }

  void setDefaultAlbumArt() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    String dirPath = dir.path;
    String filePath = "$dirPath/defalbum.png";
    File file = File(filePath);
    bool isExist = await file.exists();

    if(!isExist){
      ByteData byteData = await rootBundle.load('assets/imgs/defalbum.png');
      file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      notifyListeners();
    }
  }

  Future<void> getAlbumArts() async {
    final Directory dir = await getTemporaryDirectory();
    final valFile = await validatorFile();
    String dirPath = dir.path;
    _searchProgress = 0.0;
    notifyListeners();

    // _songInfo.forEach((element) async {
    //   String filePath = "$dirPath/${element.albumId}.png";
    //   print(filePath);
    //   File file = File(filePath);
    //   // bool isExists = await file.exists();
    //   bool isExists = file.existsSync();
    //   Uint8List artWork = await flutterAudioQuery.getArtwork(
    //     type: ResourceType.ALBUM,
    //     id: element.albumId,
    //     size: Size(500, 500)
    //   );

    //   if(!isExists){
    //     try{
    //       if(artWork.isNotEmpty && artWork != null){
    //         file.writeAsBytes(artWork);
    //         print("FilePath: ${file.path}\nSong Name: ${element.title}");
    //       }
    //     }
    //     catch(e){
    //       print(e);
    //     }
    //   }
    // });

    if(_androidDeviceInfo.version.sdkInt >= 29){
      if(!valFile.existsSync()){
        int currentSearch = 0;
        _songInfo.forEach((element) async {
          String filePath = "$dirPath/${element.albumId}.png";
          File file = File(filePath);
          bool isFileExist = await file.exists();
          // Uint8List artWork = await flutterAudioQuery.getArtwork(
          //   type: ResourceType.ALBUM,
          //   id: element.albumId,
          //   size: Size(500, 500)
          // );

          if(!isFileExist){
            Uint8List artWork = await flutterAudioQuery.getArtwork(
              type: ResourceType.ALBUM,
              id: element.albumId,
              size: Size(500, 500)
            );
            _locationSongSearch = element.filePath;
            currentSearch += 1;
            _searchProgress = currentSearch / songInfo.length;
            notifyListeners();
            try{
              if(artWork.isNotEmpty && artWork != null){
                file.writeAsBytes(artWork);
                print("FilePath: ${file.path}\nSong Name: ${element.title}");
              }
              
              if(_searchProgress == 1.0){
                valFile.writeAsString("validate");
                notifyListeners();
              }
            }
            catch(e){
              print(e);
            }
          }
          else{
            currentSearch += 1;
            _searchProgress = currentSearch / songInfo.length;
            notifyListeners();
          }
        });
      }
    }

    if(_androidDeviceInfo.version.sdkInt < 29 && !valFile.existsSync()){
      int currentSearch = 0;

      _songInfo.forEach((element) {
        currentSearch += 1;
        _searchProgress = currentSearch / songInfo.length;

        if(_searchProgress == 1.0){
          valFile.writeAsString("validate");
        }

        notifyListeners();
      });
    }
  }

  void setQueue(List<SongInfo> songList){
    _currentQueue = songList;

    notifyListeners();
  }
}