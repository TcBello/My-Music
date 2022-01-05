import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:equalizer/equalizer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music/singleton/music_player_service.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler{
  AudioPlayer _audioPlayer = AudioPlayer();
  MusicPlayerService _musicPlayerService = MusicPlayerService();

  List<MediaItem> _queue = [];

  int _index = 0;
  int? _removeIndex;
  int _audioSourceMode = 0;
  
  Timer? _timer;

  ConcatenatingAudioSource _nowPlayingAudioSource = ConcatenatingAudioSource(
    children: []
  );

  AudioPlayerHandler(){
    _audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _audioPlayer.androidAudioSessionIdStream.listen((id) {
      if(id != null)  Equalizer.setAudioSessionId(id);
    });

    _audioPlayer.currentIndexStream.listen((i) {
      print("CURRENT INDEX STREAM VALUE: $i");
      if(i != null){
        mediaItem.add(_queue[i]);
        customEvent.add(i);
      }
    });

    _audioPlayer.processingStateStream.listen((event) {
      print("PROCESSING STATE: $event");
      switch(event){
        case ProcessingState.idle:
          // _musicPlayerService.closeAudioBackground();
          break;
        case ProcessingState.loading:
          break;
        case ProcessingState.buffering:        
          break;
        case ProcessingState.ready:
          _musicPlayerService.openAudioBackground();
          break;
        case ProcessingState.completed:
          stop();
          break;
      }
    });
  }


  PlaybackState _transformEvent(PlaybackEvent event){
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.processingState]!,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> skipToNext() => _audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => _audioPlayer.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> stop() async{
    _musicPlayerService.closeAudioBackground();
    _audioPlayer.stop();
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    // CASE 0: PLAY SONG
    // CASE 1 : PLAY NEXT SONG
    // CASE 2: ADD QUEUE SONG

    switch(_audioSourceMode){
      case 0:
        if(_nowPlayingAudioSource.length == 0){
          print("AUDIO SOURCE LEN: ${_nowPlayingAudioSource.length}");
          _queue = List.from(newQueue);
          _nowPlayingAudioSource.addAll(
            newQueue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList()
          );
        }
        else{
          print("AUDIO SOURCE LEN: ${_nowPlayingAudioSource.length}");
          _nowPlayingAudioSource = ConcatenatingAudioSource(children: []);
          _queue = List.from(newQueue);
          _nowPlayingAudioSource.addAll(
            newQueue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList()
          );
          mediaItem.add(_queue[_index]);
        }
        
        _audioPlayer.setAudioSource(
          _nowPlayingAudioSource,
          initialIndex: _index,
        );
        break;
      case 1:
        _queue.insertAll(
          _audioPlayer.currentIndex! + 1,
          newQueue
        );
        _nowPlayingAudioSource.insertAll(
          _audioPlayer.currentIndex! + 1,
          newQueue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList()
        );
        break;
      case 2:
        _queue.addAll(newQueue);
        _nowPlayingAudioSource.addAll(newQueue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList());
        break;
      default:
        break;
    }

    queue.add(_queue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async{
    int lastIndex = _queue.length;
    _queue.insert(lastIndex, mediaItem);
    _nowPlayingAudioSource.insert(lastIndex, AudioSource.uri(Uri.parse(mediaItem.id)));
    queue.add(_queue);
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    _queue.insert(index, mediaItem);
    _nowPlayingAudioSource.insert(index, AudioSource.uri(Uri.parse(mediaItem.id)));
    queue.add(_queue);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async{
    switch(repeatMode){
      case AudioServiceRepeatMode.none:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
        _audioPlayer.setLoopMode(LoopMode.all);
        break;
      case AudioServiceRepeatMode.group:
        break;
    }
  }
  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async{
    switch(shuffleMode){
      case AudioServiceShuffleMode.none:
        _audioPlayer.setShuffleModeEnabled(false);
        break;
      case AudioServiceShuffleMode.all:
        _audioPlayer.setShuffleModeEnabled(true);
        break;
      case AudioServiceShuffleMode.group:
        break;
    }
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    _queue.removeAt(_removeIndex!);
    await _nowPlayingAudioSource.removeAt(_removeIndex!);
    _removeIndex = null;

    queue.add(_queue);
  }


  @override
  Future customAction(String name, [arguments]) async {
    switch(name){
      case "setIndex":
        _index = arguments!['index'] as int;
        break;
      case "isPlaying":
        return Future.value(_audioPlayer.playing);
      case "getCurrentIndex":
        return Future.value(_audioPlayer.currentIndex! + 1);
      case "setAudioSourceMode":
        _audioSourceMode = arguments!['audioSourceMode'] as int;
        break;
      case "getAudioSessionId":
        return Future.value(_audioPlayer.androidAudioSessionId);
      case "getRepeatMode":
        return Future.value(_audioPlayer.loopMode);
      case "isShuffle":
        return Future.value(_audioPlayer.shuffleModeEnabled);
      case "reorderSong":
        final mediaItem = _queue[arguments!['oldIndex'] as int];
        _queue.removeAt(arguments['oldIndex'] as int);
        _queue.insert(arguments['newIndex'] as int, mediaItem);
        _nowPlayingAudioSource.move(arguments['oldIndex'] as int, arguments['newIndex'] as int);
        queue.add(_queue);
        break;
      case "initIndex":
        customEvent.add(_audioPlayer.currentIndex);
        break;
      case "setTimer":
        _timer?.cancel();
        if((arguments!['value'] as int) > 0){
          _timer = Timer(Duration(minutes: arguments['value'] as int), (){
            stop();
          });
        }
        break;
      case "removeFromQueue":
        _removeIndex = arguments!['index'] as int;
        break;
      default:
        break;
    }
  }
}