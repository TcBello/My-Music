import 'dart:async';

class MusicPlayerSingleton{
  static final MusicPlayerSingleton _instance = MusicPlayerSingleton._internal();

  factory MusicPlayerSingleton() => _instance;

  MusicPlayerSingleton._internal(){
    _controller = StreamController<bool>.broadcast();
    _controller?.add(false);
    _attempt = 0;
  }

  int? _attempt;
  bool get _canChangeStatus => _attempt! < 1;
  bool get isAudioBackgroundRunning => !_canChangeStatus;

  StreamController<bool>? _controller;
  Stream<bool> get audioBackgroundRunningStream => _controller!.stream;

  void openAudioBackground(){
    if(_canChangeStatus){
      _controller?.add(true);
      _attempt = 1;
      print("OPEN AUDIO BACKGROUND");
    }
  }

  void closeAudioBackground(){
    if(!_canChangeStatus){
      _controller?.add(false);
      _attempt = 0;
      print("CLOSE AUDIO BACKGROUND");
    }
  }

  void dispose(){
    _controller?.close();
    _controller = null;
  }
}