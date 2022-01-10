import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_music/components/constant.dart';
import 'package:my_music/singleton/music_player_service.dart';
import 'package:my_music/utils/utils.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongQueryProvider extends ChangeNotifier{
  AudioHandler? audioHandler;
  SongQueryProvider({this.audioHandler});

  final OnAudioQuery _onAudioQuery = OnAudioQuery();
  final OnAudioRoom _onAudioRoom = OnAudioRoom();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  MusicPlayerService _musicPlayerService = MusicPlayerService();

  String _tempDirPath = "";
  String _appDirPath = "";

  String songArtwork(int id) => "$_tempDirPath/$id";
  String albumArtwork(int id) => "$_tempDirPath/al$id";
  String artistArtwork(int id) => "$_tempDirPath/ar$id";

  String _initialSongId = "";

  PaletteGenerator? _currentPalette;
  PaletteGenerator? get currentPalette => _currentPalette;

  String _searchHeader = "Searching Songs...";
  String get searchHeader => _searchHeader;

  bool _isIgnoreSongDuration30s = true;
  bool get isIgnoreSongDuration30s => _isIgnoreSongDuration30s;

  bool _isIgnoreSongDuration45s = true;
  bool get isIgnoreSongDuration45s => _isIgnoreSongDuration45s;

  bool isConvertToStringOnce = false;

  AndroidDeviceInfo? _androidDeviceInfo;
  AndroidDeviceInfo? get androidDeviceInfo => _androidDeviceInfo;

  String get defaultAlbum => "$_appDirPath/defalbum.png";

  List<SongModel> _songInfo = [];
  List<SongModel> get songInfo => _songInfo;

  List<SongModel>? _songInfoFromAlbum = [];
  List<SongModel>? get songInfoFromAlbum => _songInfoFromAlbum;

  List<SongModel>? _songInfoFromArtist = [];
  List<SongModel>? get songInfoFromArtist => _songInfoFromArtist;

  List<SongModel>? _songInfoFromPlaylist = [];
  List<SongModel>? get songInfoFromPlaylist => _songInfoFromPlaylist;

  List<ArtistModel> _artistInfo = [];
  List<ArtistModel> get artistInfo => _artistInfo;

  List<AlbumModel> _albumInfo = [];
  List<AlbumModel> get albumInfo => _albumInfo;

  List<AlbumModel>? _albumFromArtist = [];
  List<AlbumModel>? get albumFromArtist => _albumFromArtist;

  List<PlaylistEntity>? _playlistInfo = [];
  List<PlaylistEntity>? get playlistInfo => _playlistInfo;

  final List stringSongs = [];

  double _searchProgress = 0.0;
  double get searchProgress => _searchProgress;

  String _locationSongSearch = "";
  String get locationSongSearch => _locationSongSearch;

  bool get _isBackgroundRunning => _musicPlayerService.isAudioBackgroundRunning;

  void init() async{
    setDefaultAlbumArt();
    var appDir = await getApplicationDocumentsDirectory();
    await _onAudioRoom.initRoom(RoomType.PLAYLIST, "$appDir/playlist");
    await getSongs();
  }

  void addPaletteData() async{
    var mediaItem = audioHandler!.mediaItem.value!;

    if(_initialSongId != mediaItem.id){
      var generator = await PaletteGenerator.fromImageProvider(
        ResizeImage(
          FileImage(File(mediaItem.artUri!.toFilePath())),
          height: 30,
          width: 30
        )
      );
      print("DOMINANT LUMINANCE: ${generator.dominantColor?.color.computeLuminance()}\nBODY COLOR LUMINANCE: ${generator.colors.last.computeLuminance()}");
      _currentPalette = generator;
      _initialSongId = mediaItem.id;
      Future.delayed(Duration(milliseconds: 200), () async {
        notifyListeners();
      });
    }
  }

  Future<File> validatorFile() async {
    Directory dir = await getTemporaryDirectory();
    return File("${dir.path}/validate");
  }

  Future<void> getSongs() async {
    var tempDir = await getTemporaryDirectory();
    _androidDeviceInfo = await deviceInfo.androidInfo;

    var result = await _onAudioQuery.permissionsRequest();

    if(result){
      var songData = await _onAudioQuery.querySongs();
      var artistData = await _onAudioQuery.queryArtists();
      var albumData = await _onAudioQuery.queryAlbums();
      _playlistInfo = await _onAudioRoom.queryPlaylists();

      _filterData(songData, artistData, albumData);

      _tempDirPath = tempDir.path;

      print("GET DATA SONGS FROM FILES COMPLETED!");
      
      getAlbumArts();
      notifyListeners();
    }
  }

  void _filterData(List<SongModel> songData, List<ArtistModel> artistData, List<AlbumModel> albumData) async{
    var prefs = await SharedPreferences.getInstance();
    bool isIgnore30 = prefs.getBool('isIgnoreSongDuration30s') ?? true;
    bool isIgnore45 = prefs.getBool('isIgnoreSongDuration45s') ?? true;

    _isIgnoreSongDuration45s = isIgnore45;
    _isIgnoreSongDuration30s = isIgnore30;

    if(isIgnore45){
      songData.forEach((song) {
        bool songExists = File(song.data).existsSync();

        if(song.duration! > 45000 && songExists){
          _songInfo.add(song);
        }
      });
    }
    else if(isIgnore30){
      songData.forEach((song) {
        bool songExists = File(song.data).existsSync();

        if(song.duration! > 30000 && songExists){
          _songInfo.add(song);
        }
      });
    }
    else{
      songData.forEach((song) {
        bool songExists = File(song.data).existsSync();

        if(songExists) _songInfo.add(song);
      });
    }

    artistData.forEach((artist) {
      if(artist.artist != "<unknown>"){
        if(artist.artist != "Unknown Artist") _artistInfo.add(artist);
      }
    });

    albumData.forEach((album) {
      if(album.album != "raw" && album.album.toLowerCase() != _androidDeviceInfo?.manufacturer.toLowerCase()){
        _albumInfo.add(album);
      }
    });
  }

  Future<void> getPlaylists() async {
    _playlistInfo = await _onAudioRoom.queryPlaylists();
    notifyListeners();
  }

  Future<void> createPlaylist(String name, SongModel songInfo, String playlistName) async {
    int? playlistKey = await _onAudioRoom.createPlaylist(playlistName);
    if(playlistKey != null){
      await _onAudioRoom.addTo(RoomType.PLAYLIST, songInfo.getMap.toSongEntity(), playlistKey: playlistKey);
      await getPlaylists();
      showShortToast("1 song added to $playlistName");
    }
    else{
      showShortToast("Error on creating playlist");
    }
  }

  Future<void> addSongToPlaylist(SongModel song, String playlistName, int key) async {
    var playlist = await _onAudioRoom.queryPlaylist(key);
    var filteredSong = playlist?.playlistSongs.where((element) => element.lastData == song.data);

    if(filteredSong!.isEmpty){
      _onAudioRoom.addTo(RoomType.PLAYLIST, song.getMap.toSongEntity(), playlistKey: key);
      showShortToast("1 song added to $playlistName");
    }
    else{
      showShortToast("Song is already on playlist");
    }
  }

  Future<void> deletePlaylist(int key) async {
    await _onAudioRoom.deletePlaylist(key);
  }

  Future<void> removeSongFromPlaylist(SongEntity song, int key) async {
    await _onAudioRoom.deleteFrom(RoomType.PLAYLIST, song.id, playlistKey: key);
  }

  Future<void> getSongFromAlbum(int id) async {
    _songInfoFromAlbum = await _onAudioQuery.queryAudiosFrom(AudiosFromType.ALBUM_ID, id);
    print("GET SONGS FROM ALBUM COMPLETED!");

    notifyListeners();
  }

  Future<void> getSongFromArtist(int id) async{
    _songInfoFromArtist = await _onAudioQuery.queryAudiosFrom(AudiosFromType.ARTIST_ID, id);
    print("GET SONGS FROM ARTIST ALBUM COMPLETED!");

    notifyListeners();
  }

  Future<void> getAlbumFromArtist(String name) async {
    var albums = await _onAudioQuery.queryWithFilters(name, WithFiltersType.ALBUMS, args: AlbumsArgs.ARTIST);
    _albumFromArtist = albums.map((e) => AlbumModel(e as Map<dynamic, dynamic>)).toList();

    print("GET ALBUM FROM ARTIST COMPLETED!");

    notifyListeners();
  }

  Future<PlaylistEntity?> getSongFromPlaylist(int key) async {
    return await _onAudioRoom.queryPlaylist(key);
  }

  void playNextSong(SongModel nextSongInfo) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      if(_isBackgroundRunning){
        MediaItem mediaItem = _convertToMediaItem(nextSongInfo);
        int nextIndex = await audioHandler?.customAction("getCurrentIndex") as int;
        audioHandler?.insertQueueItem(nextIndex, mediaItem);
        showShortToast("Song will play next");
      }
    });
  }

  void playNextArtist(List<SongModel> songInfoList, String artistName) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      if(_isBackgroundRunning){
        List<MediaItem> mediaList = _convertToMediaItemList(songInfoList);
        audioHandler?.customAction("setAudioSourceMode", {'audioSourceMode': 1});
        audioHandler?.updateQueue(mediaList);
        showShortToast("$artistName's songs will play next");
      }
    });
  }

  void playNextAlbum(List<SongModel> songInfoList, String albumName) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      if(_isBackgroundRunning){
        List<MediaItem> mediaList = _convertToMediaItemList(songInfoList);
        audioHandler?.customAction("setAudioSourceMode", {'audioSourceMode': 1});
        audioHandler?.updateQueue(mediaList);
        showShortToast("$albumName will play next");
      }
    });
  }

  void addToQueueArtistSong(List<SongModel> songInfoList, String artistName) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(_isBackgroundRunning){
        List<MediaItem> mediaItemList = _convertToMediaItemList(songInfoList);
        audioHandler?.customAction("setAudioSourceMode", {'audioSourceMode': 2});
        audioHandler?.updateQueue(mediaItemList);
        showShortToast("$artistName's songs added to queue");
      }
    });
  }

  void addToQueueAlbumSong(List<SongModel> songInfoList, String albumName) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(_isBackgroundRunning){
        List<MediaItem> mediaItemList = _convertToMediaItemList(songInfoList);
        audioHandler?.customAction("setAudioSourceMode", {'audioSourceMode': 2});
        audioHandler?.updateQueue(mediaItemList);
        showShortToast("$albumName added to queue");
      }
    });
  }

  void playNextPlaylistSong(SongEntity nextSongInfo) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), () async {
      if(_isBackgroundRunning){
        MediaItem mediaItem = _convertEntityToMediaItem(nextSongInfo);
        int nextIndex = await audioHandler?.customAction("getCurrentIndex") as int;
        audioHandler?.insertQueueItem(nextIndex, mediaItem);
        showShortToast("Song will play next");
      }
    });
  }

  void addToQueueSong(SongModel addToQueueSongInfo) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(_isBackgroundRunning){
        MediaItem mediaItem = _convertToMediaItem(addToQueueSongInfo);
        audioHandler?.addQueueItem(mediaItem);
        showShortToast("Song added to queue");
      }
    });
  }

  void addToQueuePlaylistSong(SongEntity addToQueueSongInfo) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(_isBackgroundRunning){
        MediaItem mediaItem = _convertEntityToMediaItem(addToQueueSongInfo);
        audioHandler?.addQueueItem(mediaItem);
        showShortToast("Song added to queue");
      }
    });
  }

  void playNextPlaylist(List<SongEntity> songInfoList) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(_isBackgroundRunning){
        List<MediaItem> mediaList = _convertEntityToMediaItemList(songInfoList);
        audioHandler?.customAction("setAudioSourceMode", {'audioSourceMode': 1});
        audioHandler?.updateQueue(mediaList);
        showShortToast("Playlist will play next");
      }
    });
  }

  void addToQueuePlaylist(List<SongEntity> songInfoList) async{
    Future.delayed(Duration(milliseconds: kDelayMilliseconds), (){
      if(_isBackgroundRunning){
        List<MediaItem> mediaList = _convertEntityToMediaItemList(songInfoList);
        audioHandler?.customAction("setAudioSourceMode", {'audioSourceMode': 2});
        audioHandler?.updateQueue(mediaList);
        showShortToast("Playlist added to queue");
      }
    });
  }

  List<MediaItem> _convertToMediaItemList(List<SongModel> songInfoList){
    return songInfoList.map((e){
      bool hasArtWork = File(songArtwork(e.id)).existsSync();
      String artwork = songArtwork(e.id);
      String artist = e.artist! != kDefaultArtistName
        ? e.artist!
        : "Unknown Artist";

      return MediaItem(
        id: e.data,
        title: e.title,
        artist: artist,
        album: e.album!,
        artUri: hasArtWork
          ? File(artwork).uri
          : File(defaultAlbum).uri,
        duration: Duration(milliseconds: e.duration!),
      );
    }).toList();
  }

  MediaItem _convertToMediaItem(SongModel newSongInfo){
    bool hasArtWork = File(songArtwork(newSongInfo.id)).existsSync();
    String artwork = songArtwork(newSongInfo.id);
    String artist = newSongInfo.artist! != kDefaultArtistName
      ? newSongInfo.artist!
      : "Unknown Artist";

    return MediaItem(
      id: newSongInfo.data,
      title: newSongInfo.title,
      artist: artist,
      album: newSongInfo.album!,
      artUri: hasArtWork
        ? File(artwork).uri
        : File(defaultAlbum).uri,
      duration: Duration(milliseconds: newSongInfo.duration!),
    );
  }

  List<MediaItem> _convertEntityToMediaItemList(List<SongEntity> songInfoList){
    return songInfoList.map((e){
      bool hasArtWork = File(songArtwork(e.id)).existsSync();
      String artwork = songArtwork(e.id);
      String artist = e.artist! != kDefaultArtistName
        ? e.artist!
        : "Unknown Artist";

      return MediaItem(
        id: e.lastData,
        title: e.title,
        artist: artist,
        album: e.album!,
        artUri: hasArtWork
          ? File(artwork).uri
          : File(defaultAlbum).uri,
        duration: Duration(milliseconds: e.duration!),
      );
    }).toList();
  }

  MediaItem _convertEntityToMediaItem(SongEntity newSongInfo){
    bool hasArtWork = File(songArtwork(newSongInfo.id)).existsSync();
    String artwork = songArtwork(newSongInfo.id);
    String artist = newSongInfo.artist! != kDefaultArtistName
      ? newSongInfo.artist!
      : "Unknown Artist";

    return MediaItem(
      id: newSongInfo.lastData,
      title: newSongInfo.title,
      artist: artist,
      album: newSongInfo.album!,
      artUri: hasArtWork
        ? File(artwork).uri
        : File(defaultAlbum).uri,
      duration: Duration(milliseconds: newSongInfo.duration!),
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
    _appDirPath = dirPath;

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
    int totalItems = _songInfo.length + _artistInfo.length + _albumInfo.length;
    notifyListeners();

    if(!valFile.existsSync()){
        int currentSearch = 0;
        _locationSongSearch = "";

        if(totalItems == 0){
          valFile.writeAsString("validate");
          notifyListeners();
        }

        var resultSong = await Future.forEach(_songInfo, (SongModel element) async {
          String filePath = "$dirPath/${element.id}";
          File file = File(filePath);

          if(!file.existsSync()){
            Uint8List? artWork = await _onAudioQuery.queryArtwork(
              element.id,
              ArtworkType.AUDIO,
              size: 500
            );

            _locationSongSearch = element.data;
            currentSearch += 1;
            _searchProgress = currentSearch / totalItems;
            notifyListeners();

            try{
              if(artWork != null){
                file.writeAsBytesSync(artWork);
                print("FilePath: ${file.path}\nSong Name: ${element.title}");
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

        if(resultSong == null){
          var resultArtist = await Future.forEach(_artistInfo, (ArtistModel element) async {
            String filePath = "$dirPath/ar${element.id}";
            File file = File(filePath);
            var albums = await _onAudioQuery.queryWithFilters(element.artist, WithFiltersType.ALBUMS, args: AlbumsArgs.ARTIST);
            List<AlbumModel> album = albums.map((e) => AlbumModel(e as Map<dynamic, dynamic>)).toList();

            if(!file.existsSync() && albums.length != 0){
              Uint8List? artwork = await _onAudioQuery.queryArtwork(
                album[0].id,
                ArtworkType.ALBUM,
                size: 500
                );

              _searchHeader = "Preparing...";
              _locationSongSearch = "Please wait...";
              currentSearch += 1;
              _searchProgress = currentSearch / totalItems;
              notifyListeners();

              try{
                if(artwork != null){
                  file.writeAsBytesSync(artwork);
                  print("Artist Name: ${element.artist}");
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
            
            Future.forEach(_albumInfo, (AlbumModel element) async {
              String filePath = "$dirPath/al${element.id}";
              File file = File(filePath);

              if(!file.existsSync()){
                Uint8List? artwork = await _onAudioQuery.queryArtwork(
                  element.id,
                  ArtworkType.ALBUM,
                  size: 500
                );

                currentSearch += 1;
                _searchProgress = currentSearch / totalItems;
                notifyListeners();

                try{
                  if(artwork!= null){
                    file.writeAsBytesSync(artwork);
                    print("Album Name: ${element.album}");
                  }
                  print(_searchProgress);

                  if(_searchProgress == 1.0){
                    valFile.writeAsString("validate");
                    _searchProgress = 0.0;
                    _searchHeader = "Searching Songs...";
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
                  _searchProgress = 0.0;
                  _searchHeader = "Searching Songs...";
                  notifyListeners();
                  print("YEEEEY");
                }
              }
            });
          }
        }
    }
  }

  void reorderSong(int oldIndex, int newIndex){
    if(oldIndex < newIndex){
      newIndex--;
    }
    audioHandler?.customAction(
      "reorderSong",
      {
        'oldIndex': oldIndex,
        'newIndex': newIndex
      }
    );
  }

  void removeQueueSong(MediaItem mediaItem, int index){
    audioHandler?.customAction("removeFromQueue", {'index': index});
    print("REMOVE ${mediaItem.title} AT INDEX $index");
    audioHandler?.removeQueueItem(mediaItem);
  }

  Future<void> reset() async {
    _songInfo = [];
    _artistInfo = [];
    _albumInfo = [];
    notifyListeners();
    
    var tempDir = await getTemporaryDirectory();

    if(tempDir.existsSync()){
      try{
        if(_isBackgroundRunning) audioHandler?.stop();
        tempDir.deleteSync(recursive: true);
      }
      catch(e){
        print(e);
      }
    }
  }

  SongModel? getSongInfoByPath(String path){
    SongModel? resultSongInfo;

    _songInfo.forEach((element) {
      if(element.data == path){
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