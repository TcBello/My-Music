import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:my_music/main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

class SongQueryProvider extends ChangeNotifier{
  final FlutterAudioQuery flutterAudioQuery = FlutterAudioQuery();
  final String _defaultAlbum = "/data/user/0/com.tcbello.my_music/app_flutter/defalbum.png";
  bool isConvertToStringOnce = false;

  List<SongInfo> _songinfo;
  List<SongInfo> get songInfo => _songinfo;

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

  Future<void> getSongs() async {
    _songinfo = await flutterAudioQuery.getSongs();
    _artistInfo = await flutterAudioQuery.getArtists();
    _albumInfo = await flutterAudioQuery.getAlbums();
    _playlistInfo = await flutterAudioQuery.getPlaylists();
    print("GET DATA SONGS FROM FILES COMPLETED!");

    notifyListeners();
  }

  Future<void> createPlaylist(String name, SongInfo songInfo) async {
    await FlutterAudioQuery.createPlaylist(playlistName: name);
    await getSongs();

    _playlistInfo.forEach((element) {
      if(element.name == name){
        element.addSong(song: songInfo);
      }
    });
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
    return songInfoList.map((e) => MediaItem(
      id: e.filePath,
      title: e.title,
      artist: e.artist != "<unknown>"
        ? e.artist
        : "Unknown Artist",
      album: e.album,
      artUri: e.albumArtwork != null
        ? File(e.albumArtwork).uri
        : File(_defaultAlbum).uri,
      duration: Duration(milliseconds: int.parse(e.duration))
    )).toList();
  }

  MediaItem _convertToMediaItem(SongInfo newSongInfo){
    return MediaItem(
      id: newSongInfo.filePath,
      title: newSongInfo.title,
      artist: newSongInfo.artist != "<unknown>"
        ? newSongInfo.artist
        : "Unknown Artist",
      album: newSongInfo.album,
      artUri: newSongInfo.albumArtwork != null
        ? File(newSongInfo.albumArtwork).uri
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

  void setQueue(List<SongInfo> songList){
    _currentQueue = songList;

    notifyListeners();
  }
}