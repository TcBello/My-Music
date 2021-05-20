import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music/main.dart';

void audioPlayerTaskEntrypoint() async{
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask{
  AudioPlayer audioPlayer = AudioPlayer();
  List<MediaItem> queue = [];
  AudioProcessingState skipState;
  int index = 0;
  bool isQueueUpdated = false;
  // StreamSubscription<PlayerState> playerSubscription;
  StreamSubscription<PlaybackEvent> eventSubscription;
  bool isDispose = false;
  int audioSourceMode = 0;

  final audioSourceTest = ConcatenatingAudioSource(
    children: []
  );
  
  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // AudioServiceBackground.setQueue(queue);

    final audioSession = await AudioSession.instance;
    await audioSession.configure(AudioSessionConfiguration.music());

    audioPlayer.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          // In this example, the service stops when reaching the end.
          onStop();
          break;
        case ProcessingState.ready:
          // If we just came from skipping between tracks, clear the skip
          // state now that we're ready to play.
          skipState = null;
          break;
        default:
          break;
      }

      print(state);
    });
    // playerSubscription = audioPlayer.playerStateStream.listen((state) {
    //   AudioServiceBackground.setState(
    //     playing: state.playing,
    //     processingState: {
    //       ProcessingState.idle: AudioProcessingState.stopped,
    //       ProcessingState.loading: AudioProcessingState.connecting,
    //       ProcessingState.buffering: AudioProcessingState.buffering,
    //       ProcessingState.ready: AudioProcessingState.ready,
    //       ProcessingState.completed: AudioProcessingState.completed,
    //     }[state.processingState],
    //     controls: [
    //       MediaControl.skipToPrevious,
    //       state.playing
    //         ? MediaControl.pause
    //         : MediaControl.play,
    //       MediaControl.skipToNext
    //     ],
    //     // androidCompactActions: [0, 1, 3],
    //     // shuffleMode: AudioServiceShuffleMode.none
    //   );
    // });
    
    // try{
    //   await audioPlayer.setAudioSource(
    //     ConcatenatingAudioSource(
    //       children: queue.map((e) => AudioSource.uri(Uri.parse(e.id),)).toList()
    //     ),
    //     initialIndex: index
    //   );
    // }
    // catch(e){
    //   print(e);
    // }

    eventSubscription = audioPlayer.playbackEventStream.listen((event) {
      _broadcastState();
    });
  }

  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        audioPlayer.playing
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
      playing: audioPlayer.playing,
      position: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
    );
  }

  AudioProcessingState _getProcessingState() {
    if (skipState != null) return skipState;
    switch (audioPlayer.processingState) {
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
        throw Exception("Invalid state: ${audioPlayer.processingState}");
    }
  }

  @override
  Future<void> onPlay() async {
    audioPlayer.currentIndexStream.listen((i) {
      AudioServiceBackground.setMediaItem(queue[i]);
    });
    audioPlayer.play();
  }

  @override
  Future<void> onPause() => audioPlayer.pause();

  @override
  Future<void> onSkipToNext() async{
    skipState = AudioProcessingState.skippingToNext;
    audioPlayer.seekToNext();
    // return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() async{
    skipState = AudioProcessingState.skippingToPrevious;
    audioPlayer.seekToPrevious();
    // return super.onSkipToPrevious();
  }

  @override
  Future<void> onSeekTo(Duration position) async => audioPlayer.seek(position);

  @override
  Future<void> onStop() async {
    await audioPlayer.dispose();
    eventSubscription.cancel();
    await _broadcastState();
    await super.onStop();
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> newQueue) async {
    // queue = List.from(newQueue);
    // AudioServiceBackground.setQueue(queue);

    switch(audioSourceMode){
      case 0:
        if(audioSourceTest.length == 0){
          queue = List.from(newQueue);
          audioSourceTest.addAll(
            newQueue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList()
          );
        }
        else{
          queue = List.from(newQueue);
          audioSourceTest.removeRange(0, audioSourceTest.length);
          audioSourceTest.addAll(
            newQueue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList()
          );
        }

        await audioPlayer.setAudioSource(
          audioSourceTest,
          initialIndex: index
        );
        break;
      case 1:
        queue.insertAll(
          audioPlayer.currentIndex + 1,
          newQueue
        );
        audioSourceTest.insertAll(
          audioPlayer.currentIndex + 1,
          newQueue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList()
        );
        break;
      case 2:
        queue.addAll(newQueue);
        audioSourceTest.addAll(newQueue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList());
        break;
    }

    AudioServiceBackground.setQueue(queue);
    
  }

  // @override
  Future<void> onAddQueueItem(MediaItem mediaItem) async{
    int lastIndex = queue.length;
    queue.insert(lastIndex, mediaItem);
    audioSourceTest.insert(lastIndex, AudioSource.uri(Uri.parse(mediaItem.id)));
    AudioServiceBackground.setQueue(queue);

    // await audioPlayer.setAudioSource(
    //   ConcatenatingAudioSource(
    //     children: queue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList()
    //   ),
    //   initialIndex: index,
    //   initialPosition: audioPlayer.position
    // );
  }

  // @override
  Future<void> onAddQueueItemAt(MediaItem mediaItem, int index) async{
    queue.insert(index, mediaItem);
    audioSourceTest.insert(index, AudioSource.uri(Uri.parse(mediaItem.id)));
    AudioServiceBackground.setQueue(queue);

    // audioPlayer.setAudioSource(
    //   ConcatenatingAudioSource(
    //     children: queue.map((e) => AudioSource.uri(Uri.parse(e.id))).toList()
    //   ),
    //   initialIndex: audioPlayer.currentIndex,
    //   initialPosition: audioPlayer.position
    // );

    // return super.onAddQueueItemAt(mediaItem, index);
  }

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) async{
    switch(repeatMode){
      case AudioServiceRepeatMode.none:
        audioPlayer.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        audioPlayer.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
        audioPlayer.setLoopMode(LoopMode.all);
        break;
      case AudioServiceRepeatMode.group:
        break;
    }
  }
  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) async{
    switch(shuffleMode){
      case AudioServiceShuffleMode.none:
        audioPlayer.setShuffleModeEnabled(false);
        break;
      case AudioServiceShuffleMode.all:
        audioPlayer.setShuffleModeEnabled(true);
        break;
      case AudioServiceShuffleMode.group:
        break;
    }
  }

  @override
  Future<void> onClose() => onStop();

  @override
  Future onCustomAction(String name, arguments) {
    switch(name){
      case "setIndex":
        index = arguments;
        break;
      case "isPlaying":
        return Future.value(audioPlayer.playing);
        break;
      case "getCurrentIndex":
        return Future.value(audioPlayer.currentIndex + 1);
        break;
      case "setAudioSourceMode":
        audioSourceMode = arguments;
        break;
      case "getAudioSessionId":
        return Future.value(audioPlayer.androidAudioSessionId);
      case "getRepeatMode":
        return Future.value(audioPlayer.loopMode);
      case "isShuffle":
        return Future.value(audioPlayer.shuffleModeEnabled);
      // case "isPlayerFinish":
      //   return Future.value().asStream();
    }
  }
}