import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music/components/controller.dart';

void audioPlayerTaskEntrypoint() async{
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask{
  AudioPlayer _audioPlayer = AudioPlayer();

  List<MediaItem> _queue = [];

  AudioProcessingState _skipState;

  int _index = 0;
  int _removeIndex;
  int _audioSourceMode = 0;
  
  StreamSubscription<PlaybackEvent> _eventSubscription;
  
  Timer _timer;

  ConcatenatingAudioSource _nowPlayingAudioSource = ConcatenatingAudioSource(
    children: []
  );
  
  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    final audioSession = await AudioSession.instance;
    await audioSession.configure(AudioSessionConfiguration.music());

    _audioPlayer.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          // In this example, the service stops when reaching the end.
          onStop();
          break;
        case ProcessingState.ready:
          // If we just came from skipping between tracks, clear the skip
          // state now that we're ready to play.
          _skipState = null;
          break;
        default:
          break;
      }
    });

    _eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      _broadcastState();
    });

    _audioPlayer.currentIndexStream.listen((i) {
      print("CURRENT INDEX: $i");
      if(i != null){
         AudioServiceBackground.setMediaItem(_queue[i]);
         AudioServiceBackground.sendCustomEvent(i ?? _index);
      }
    });
  }

  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        _audioPlayer.playing
          ? MediaControl.pause
          : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      androidCompactActions: [0, 1, 3],
      processingState: _getProcessingState(),
      playing: _audioPlayer.playing,
      position: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
    );
  }

  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState;
    switch (_audioPlayer.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_audioPlayer.processingState}");
    }
  }

  @override
  Future<void> onPlay() => _audioPlayer.play();

  @override
  Future<void> onPause() => _audioPlayer.pause();

  @override
  Future<void> onSkipToNext() async{
    _skipState = AudioProcessingState.skippingToNext;
    _audioPlayer.seekToNext();
  }

  @override
  Future<void> onSkipToPrevious() async{
    _skipState = AudioProcessingState.skippingToPrevious;
    _audioPlayer.seekToPrevious();
  }

  @override
  Future<void> onSeekTo(Duration position) async => _audioPlayer.seek(position);

  @override
  Future<void> onStop() async {
    await _audioPlayer.dispose();
    _eventSubscription.cancel();
    miniPlayerController.dispose();
    await _broadcastState();
    await super.onStop();
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> newQueue) async {
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
          AudioServiceBackground.setMediaItem(_queue[_index]);
        }
        
        _audioPlayer.setAudioSource(
          _nowPlayingAudioSource,
          initialIndex: _index,
        );
        break;
      case 1:
        _queue.insertAll(
          _audioPlayer.currentIndex + 1,
          newQueue
        );
        _nowPlayingAudioSource.insertAll(
          _audioPlayer.currentIndex + 1,
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

    AudioServiceBackground.setQueue(_queue);
  }

  @override
  Future<void> onAddQueueItem(MediaItem mediaItem) async{
    int lastIndex = _queue.length;
    _queue.insert(lastIndex, mediaItem);
    _nowPlayingAudioSource.insert(lastIndex, AudioSource.uri(Uri.parse(mediaItem.id)));
    AudioServiceBackground.setQueue(_queue);
  }

  @override
  Future<void> onAddQueueItemAt(MediaItem mediaItem, int index) async{
    _queue.insert(index, mediaItem);
    _nowPlayingAudioSource.insert(index, AudioSource.uri(Uri.parse(mediaItem.id)));
    AudioServiceBackground.setQueue(_queue);
  }

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) async{
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
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) async{
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
  Future<void> onRemoveQueueItem(MediaItem mediaItem) async {
    _queue.removeAt(_removeIndex);
    await _nowPlayingAudioSource.removeAt(_removeIndex);
    _removeIndex = null;

    AudioServiceBackground.setQueue(_queue);
  }


  @override
  Future onCustomAction(String name, arguments) async {
    switch(name){
      case "setIndex":
        _index = arguments;
        break;
      case "isPlaying":
        return Future.value(_audioPlayer.playing);
        break;
      case "getCurrentIndex":
        return Future.value(_audioPlayer.currentIndex + 1);
        break;
      case "setAudioSourceMode":
        _audioSourceMode = arguments;
        break;
      case "getAudioSessionId":
        return Future.value(_audioPlayer.androidAudioSessionId);
        break;
      case "getRepeatMode":
        return Future.value(_audioPlayer.loopMode);
        break;
      case "isShuffle":
        return Future.value(_audioPlayer.shuffleModeEnabled);
        break;
      case "reorderSong":
        final mediaItem = _queue[arguments[0]];
        _queue.removeAt(arguments[0]);
        _queue.insert(arguments[1], mediaItem);
        _nowPlayingAudioSource.move(arguments[0], arguments[1]);
        AudioServiceBackground.setQueue(_queue);
        break;
      case "initIndex":
        AudioServiceBackground.sendCustomEvent(_audioPlayer.currentIndex);
        break;
      case "setTimer":
        if(_timer != null) _timer.cancel();
        if(arguments > 0){
          _timer = Timer(Duration(minutes: arguments), (){
            onStop();
          });
        }
        break;
      case "removeFromQueue":
        _removeIndex = arguments;
        break;
      default:
        break;
    }
  }
}