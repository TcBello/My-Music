import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongQueryProvider extends ChangeNotifier{
  final FlutterAudioQuery flutterAudioQuery = FlutterAudioQuery();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String songArtwork(String id) => "/data/user/0/com.tcbello.my_music/cache/$id";
  String albumArtwork(String id) => "/data/user/0/com.tcbello.my_music/cache/al$id";
  String artistArtwork(String id) => "/data/user/0/com.tcbello.my_music/cache/ar$id";

  String _searchHeader = "Searching Songs...";
  String get searchHeader => _searchHeader;

  bool _isIgnoreSongDuration30s = true;
  bool get isIgnoreSongDuration30s => _isIgnoreSongDuration30s;

  bool _isIgnoreSongDuration45s = true;
  bool get isIgnoreSongDuration45s => _isIgnoreSongDuration45s;

  bool isConvertToStringOnce = false;

  AndroidDeviceInfo _androidDeviceInfo;
  AndroidDeviceInfo get androidDeviceInfo => _androidDeviceInfo;

  final String _defaultAlbum = "/data/user/0/com.tcbello.my_music/app_flutter/defalbum.png";
  String get defaultAlbum => _defaultAlbum;

  List<SongInfo> _songInfo = [];
  List<SongInfo> get songInfo => _songInfo;

  List<SongInfo> _songInfoFromAlbum;
  List<SongInfo> get songInfoFromAlbum => _songInfoFromAlbum;

  List<SongInfo> _songInfoFromArtist;
  List<SongInfo> get songInfoFromArtist => _songInfoFromArtist;

  List<SongInfo> _songInfoFromPlaylist;
  List<SongInfo> get songInfoFromPlaylist => _songInfoFromPlaylist;

  List<ArtistInfo> _artistInfo = [];
  List<ArtistInfo> get artistInfo => _artistInfo;

  List<AlbumInfo> _albumInfo = [];
  List<AlbumInfo> get albumInfo => _albumInfo;

  List<AlbumInfo> _albumFromArtist;
  List<AlbumInfo> get albumFromArtist => _albumFromArtist;

  List<PlaylistInfo> _playlistInfo = [];
  List<PlaylistInfo> get playlistInfo => _playlistInfo;

  List<SongInfo> _currentQueue = [];
  List<SongInfo> get currentQueue => _currentQueue;

  final List stringSongs = [];

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
    
    var songData = await flutterAudioQuery.getSongs();
    var artistData = await flutterAudioQuery.getArtists();
    var albumData = await flutterAudioQuery.getAlbums();
    _playlistInfo = await flutterAudioQuery.getPlaylists();

    _filterData(songData, artistData, albumData);

    print("GET DATA SONGS FROM FILES COMPLETED!");
    
    getAlbumArts();
    notifyListeners();
  }

  void _filterData(List<SongInfo> songData, List<ArtistInfo> artistData, List<AlbumInfo> albumData) async{
    var prefs = await SharedPreferences.getInstance();
    bool isIgnore30 = prefs.getBool('isIgnoreSongDuration30s') ?? true;
    bool isIgnore45 = prefs.getBool('isIgnoreSongDuration45s') ?? true;

    _isIgnoreSongDuration45s = isIgnore45;
    _isIgnoreSongDuration30s = isIgnore30;

    if(isIgnore45){
      songData.forEach((song) {
        if(int.parse(song.duration) > 45000){
          _songInfo.add(song);
        }
      });
    }
    else if(isIgnore30){
      songData.forEach((song) {
        if(int.parse(song.duration) > 30000){
          _songInfo.add(song);
        }
      });
    }
    else{
      songData.forEach((song) {
        _songInfo.add(song);
      });
    }

    artistData.forEach((artist) {
      if(artist.name != "Unknown Artist"){
        _artistInfo.add(artist);
      }
    });

    albumData.forEach((album) {
      if(album.title != "raw" && album.title.toLowerCase() != _androidDeviceInfo.manufacturer.toLowerCase()){
        _albumInfo.add(album);
      }
    });
  }

  Future<void> createPlaylist(String name, SongInfo songInfo, String playlistName) async {
    var newPlaylist = await FlutterAudioQuery.createPlaylist(playlistName: name);
    newPlaylist.addSong(song: songInfo);
    await getSongs();
    showShortToast("1 song added to $playlistName");
  }

  void addSongToPlaylist(SongInfo song, int index, String playlistName) async {
    await _playlistInfo[index].addSong(song: song);
    showShortToast("1 song added to $playlistName");
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
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      if(AudioService.running){
        MediaItem mediaItem = _convertToMediaItem(nextSongInfo);
        int nextIndex = await AudioService.customAction("getCurrentIndex");
        AudioService.addQueueItemAt(mediaItem, nextIndex);
        showShortToast("Song will play next");
      }
    });
  }

  void addToQueueSong(SongInfo addToQueueSongInfo) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(AudioService.running){
        MediaItem mediaItem = _convertToMediaItem(addToQueueSongInfo);
        AudioService.addQueueItem(mediaItem);
        showShortToast("Song added to queue");
      }
    });
  }

  void playNextPlaylist(List<SongInfo> songInfoList) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(AudioService.running){
        List<MediaItem> mediaList = _convertToMediaItemList(songInfoList);
        AudioService.customAction("setAudioSourceMode", 1);
        AudioService.updateQueue(mediaList);
        showShortToast("Playlist will play next");
      }
    });
  }

  void addToQueuePlaylist(List<SongInfo> songInfoList) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(AudioService.running){
        List<MediaItem> mediaList = _convertToMediaItemList(songInfoList);
        AudioService.customAction("setAudioSourceMode", 2);
        AudioService.updateQueue(mediaList);
        showShortToast("Playlist added to queue");
      }
    });
  }

  List<MediaItem> _convertToMediaItemList(List<SongInfo> songInfoList){
    return songInfoList.map((e){
      bool hasArtWork = File(songArtwork(e.id)).existsSync();
      String artwork = songArtwork(e.id);

      return MediaItem(
        id: e.filePath,
        title: e.title,
        artist: e.artist ,
        album: e.album,
        artUri: _androidDeviceInfo.version.sdkInt < 29
          ? e.albumArtwork != null
            ? File(e.albumArtwork).uri
            : File(_defaultAlbum).uri
          : hasArtWork
            ? File(artwork).uri
            : File(_defaultAlbum).uri,
        duration: Duration(milliseconds: int.parse(e.duration)),
      );
    }).toList();
  }

  MediaItem _convertToMediaItem(SongInfo newSongInfo){
    bool hasArtWork = File(songArtwork(newSongInfo.id)).existsSync();
    String artwork = songArtwork(newSongInfo.id);

    return MediaItem(
      id: newSongInfo.filePath,
      title: newSongInfo.title,
      artist: newSongInfo.artist,
      album: newSongInfo.album,
      artUri: _androidDeviceInfo.version.sdkInt < 29
        ? newSongInfo.albumArtwork != null
          ? File(newSongInfo.albumArtwork).uri
          : File(_defaultAlbum).uri
        : hasArtWork
          ? File(artwork).uri
          : File(_defaultAlbum).uri,
      duration: Duration(milliseconds: int.parse(newSongInfo.duration)),
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

    if(!file.existsSync()){
      ByteData byteData = await rootBundle.load('assets/imgs/defalbum.png');
      file.writeAsBytesSync(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      notifyListeners();
    }
  }

  Future<void> getAlbumArts() async {
    final Directory dir = await getTemporaryDirectory();
    final valFile = await validatorFile();
    String dirPath = dir.path;
    _searchProgress = 0.0;
    _searchHeader = "Searching Songs...";
    int totalItems = songInfo.length + artistInfo.length + albumInfo.length;
    notifyListeners();

    if(_androidDeviceInfo.version.sdkInt >= 29){
      if(!valFile.existsSync()){
        int currentSearch = 0;
        _locationSongSearch = "";
        // _songInfo.forEach((element) async {
        //   String filePath = "$dirPath/${element.id}";
        //   File file = File(filePath);

        //   if(!file.existsSync()){
        //     Uint8List artWork = await flutterAudioQuery.getArtwork(
        //       type: ResourceType.SONG,
        //       id: element.id,
        //       size: Size(500, 500)
        //     );

        //     _locationSongSearch = element.filePath;
        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();

        //     try{
        //       if(artWork.isNotEmpty){
        //         file.writeAsBytesSync(artWork);
        //         print("FilePath: ${file.path}\nSong Name: ${element.title}");
        //       }
              
        //       // if(_searchProgress == 1.0){
        //       //   valFile.writeAsString("validate");
        //       //   notifyListeners();
        //       // }
        //     }
        //     catch(e){
        //       print(e);
        //     }
        //   }
        //   else{
        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();
        //   }
        // });

        var resultSong = await Future.forEach(_songInfo, (element) async {
          String filePath = "$dirPath/${element.id}";
          File file = File(filePath);

          if(!file.existsSync()){
            Uint8List artWork = await flutterAudioQuery.getArtwork(
              type: ResourceType.SONG,
              id: element.id,
              size: Size(500, 500)
            );

            _locationSongSearch = element.filePath;
            currentSearch += 1;
            _searchProgress = currentSearch / totalItems;
            notifyListeners();

            try{
              if(artWork.isNotEmpty){
                file.writeAsBytesSync(artWork);
                print("FilePath: ${file.path}\nSong Name: ${element.title}");
              }
              
              // if(_searchProgress == 1.0){
              //   valFile.writeAsString("validate");
              //   notifyListeners();
              // }
            }
            catch(e){
              print(e);
            }
          }
          else{
            currentSearch += 1;
            _searchProgress = currentSearch / totalItems;
            notifyListeners();
          }
        });

        if(resultSong == null){
          _searchHeader = "Preparing...";
          notifyListeners();

          var resultArtist = await Future.forEach(_artistInfo, (element) async {
            String filePath = "$dirPath/ar${element.id}";
            File file = File(filePath);

            if(!file.existsSync()){
              Uint8List artwork = await flutterAudioQuery.getArtwork(
                id: element.id,
                type: ResourceType.ARTIST,
                size: Size(500, 500)
              );

              _locationSongSearch = "Please wait...";
              currentSearch += 1;
              _searchProgress = currentSearch / totalItems;
              notifyListeners();

              try{
                if(artwork.isNotEmpty){
                  file.writeAsBytesSync(artwork);
                  print("Artist Name: ${element.name}");
                }
              }
              catch(e){
                print(e);
              }
            }
            else{
              currentSearch += 1;
              _searchProgress = currentSearch / totalItems;
              notifyListeners();
            }
          });

          if(resultArtist == null){
            
            Future.forEach(_albumInfo, (element) async {
              String filePath = "$dirPath/al${element.id}";
              File file = File(filePath);

              if(!file.existsSync()){
                Uint8List artwork = await flutterAudioQuery.getArtwork(
                  id: element.id,
                  type: ResourceType.ALBUM,
                  size: Size(500, 500)
                );

                currentSearch += 1;
                _searchProgress = currentSearch / totalItems;
                notifyListeners();

                try{
                  if(artwork.isNotEmpty){
                    file.writeAsBytesSync(artwork);
                    print("Album Name: ${element.title}");
                  }
                  print(_searchProgress);

                  if(_searchProgress == 1.0){
                    valFile.writeAsString("validate");
                    notifyListeners();
                    print("YEEEEY");
                  }
                }
                catch(e){
                  print(e);
                }
              }
              else{
                currentSearch += 1;
                _searchProgress = currentSearch / totalItems;
                notifyListeners();
                print(_searchProgress);

                if(_searchProgress == 1.0){
                  valFile.writeAsString("validate");
                  notifyListeners();
                  print("YEEEEY");
                }
              }
            });
          }
        }

        // _artistInfo.forEach((element) async {
        //   String filePath = "$dirPath/ar${element.id}";
        //   File file = File(filePath);
        //   _searchHeader = "Preparing...";

        //   if(!file.existsSync()){
        //     Uint8List artwork = await flutterAudioQuery.getArtwork(
        //       id: element.id,
        //       type: ResourceType.ARTIST,
        //       size: Size(500, 500)
        //     );

        //     _locationSongSearch = "Please wait...";
        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();

        //     try{
        //       if(artwork.isNotEmpty){
        //         file.writeAsBytesSync(artwork);
        //         print("Artist Name: ${element.name}");
        //       }
        //     }
        //     catch(e){
        //       print(e);
        //     }
        //   }
        //   else{
        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();
        //   }
        // });

        // _searchHeader = "Preparing...";

        // await Future.forEach(_artistInfo, (element) async {
        //   String filePath = "$dirPath/ar${element.id}";
        //   File file = File(filePath);

        //   if(!file.existsSync()){
        //     Uint8List artwork = await flutterAudioQuery.getArtwork(
        //       id: element.id,
        //       type: ResourceType.ARTIST,
        //       size: Size(500, 500)
        //     );

        //     _locationSongSearch = "Please wait...";
        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();

        //     try{
        //       if(artwork.isNotEmpty){
        //         file.writeAsBytesSync(artwork);
        //         print("Artist Name: ${element.name}");
        //       }
        //     }
        //     catch(e){
        //       print(e);
        //     }
        //   }
        //   else{
        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();
        //   }
        // });

        // _albumInfo.forEach((element) async {
        //   String filePath = "$dirPath/al${element.id}";
        //   File file = File(filePath);

        //   if(!file.existsSync()){
        //     Uint8List artwork = await flutterAudioQuery.getArtwork(
        //       id: element.id,
        //       type: ResourceType.ALBUM,
        //       size: Size(500, 500)
        //     );

        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();

        //     try{
        //       if(artwork.isNotEmpty){
        //         file.writeAsBytesSync(artwork);
        //         print("Album Name: ${element.title}");
        //       }

        //       if(_searchProgress == 1.0){
        //         valFile.writeAsString("validate");
        //         notifyListeners();
        //       }
        //     }
        //     catch(e){
        //       print(e);
        //     }
        //   }
        //   else{
        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();
        //   }
        // });

        // Future.forEach(_albumInfo, (element) async {
        //   String filePath = "$dirPath/al${element.id}";
        //   File file = File(filePath);

        //   if(!file.existsSync()){
        //     Uint8List artwork = await flutterAudioQuery.getArtwork(
        //       id: element.id,
        //       type: ResourceType.ALBUM,
        //       size: Size(500, 500)
        //     );

        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();

        //     try{
        //       if(artwork.isNotEmpty){
        //         file.writeAsBytesSync(artwork);
        //         print("Album Name: ${element.title}");
        //       }

        //       if(_searchProgress == 1.0){
        //         valFile.writeAsString("validate");
        //         notifyListeners();
        //       }
        //     }
        //     catch(e){
        //       print(e);
        //     }
        //   }
        //   else{
        //     currentSearch += 1;
        //     _searchProgress = currentSearch / totalItems;
        //     notifyListeners();
        //   }
        // });
      }
    }

    if(_androidDeviceInfo.version.sdkInt < 29 && !valFile.existsSync()){
      int currentSearch = 0;

      _songInfo.forEach((element) {
        _locationSongSearch = element.filePath;
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
    _currentQueue = List.from(songList);
    notifyListeners();
  }

  void reorderSong(int oldIndex, int newIndex){
    if(oldIndex < newIndex){
      newIndex--;
    }
    AudioService.customAction("reorderSong", [oldIndex, newIndex]);
  }

  void removeQueueSong(MediaItem mediaItem, int index){
    AudioService.customAction("removeFromQueue", index);
    print("REMOVE ${mediaItem.title} AT INDEX $index");
    AudioService.removeQueueItem(mediaItem);
  }

  Future<void> resetCache() async {
    var tempDir = await getTemporaryDirectory();

    if(tempDir.existsSync()){
      try{
        if(AudioService.running) AudioService.stop();
        tempDir.deleteSync(recursive: true);
      }
      catch(e){
        print(e);
      }
    }
  }

  SongInfo getSongInfoByPath(String path){
    SongInfo resultSongInfo;

    _songInfo.forEach((element) {
      if(element.filePath == path){
        resultSongInfo = element;
      }
    });

    return resultSongInfo;
  }

  void setIgnoreSongDuration30(bool value) async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIgnoreSongDuration30s', value);
    _isIgnoreSongDuration30s = value;
    notifyListeners();
  }

  void setIgnoreSongDuration45(bool value) async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIgnoreSongDuration45s', value);
    _isIgnoreSongDuration45s = value;
    notifyListeners();
  }
}